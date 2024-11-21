       IDENTIFICATION  DIVISION.
       PROGRAM-ID.      PART1V2.
       AUTHOR.          HINKOKO.
       DATE-WRITTEN.   19/11/24.
       DATE-COMPILED.  19/11/24.
      *********************************************************
      *    THIS PROGRAM IS INTENDED TO :                      *
      *     - PARSE CSV FILE IN TOKENS                        *
      *      - EXTRACT THE TOKENS INTO DB2 VARIABLES          *
      *      - CALL A ROUTINE TO CONVERT PRICE IN USD         *
      *      - FORMAT PRODUCT DESCRIPTION (CAMELCASE)         *
      *      - PERFORM DB2 INSERTION                          *
      *********************************************************
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
              SELECT NEWS ASSIGN TO FICNEWS.
              SELECT FLOG ASSIGN TO FICLOG.
				  
       DATA DIVISION.
       FILE SECTION.
       FD NEWS.
       01 ENR-NEWS.
          05 ENR-CSV      PIC X(45).
       
       FD FLOG.
       01 ENR-LOG         PIC X(80).
       
       WORKING-STORAGE SECTION.
      **  VARIABLES FOR PARSING CSV LINES **
       01 PROD-NO         PIC X(03).
       01 PROD-DESC       PIC X(20).
       01 PROD-PRICE      PIC 9(03)V99.
       01 PROD-PRICE-CSV  PIC X(06).
       01 WS-LEN          PIC 9(02).
       01 WS-NUM          PIC 9(02).
       01 PROD-DEVISE     PIC X(02).

      ***************************************
       77 NEWS-FLAG       PIC 9     VALUE 0.
            88 FF-NEWS              VALUE 1.
       77 VALID-DATA      PIC 9.
            88 DATA-OK              VALUE 1.
            88 DATA-KO              VALUE 0.
       
       77 CSV-LINE        PIC 99    VALUE 0.
       
       77 USD-AMOUNT      PIC 9(03)V99.
       77 WS-ANO          PIC 9(01) VALUE 0.
       01 WS-MSG          PIC X(20) VALUE SPACES.
       01 ED-SQLCODE      PIC +Z(8)9.
       
      ** SOUS PROG ***
       77 WS-SSPROG       PIC X(8) VALUE 'CONVERT'.
       
      ** VARIABLES FOR STRING MANIPULATION **
       01 TMP-DESC        PIC X(20).
       01 FIRST-CHAR      PIC X(20).
       01 WS-I            PIC 9(02).
       ** LOG FILE ***
       01 LOG-HEAD        PIC X(27) VALUE "LOG REPORT FOR NEWPRODS.CSV".
       01 ST-LOG.
          05 FILLER       PIC X(12) VALUE "CSV LINE N. ".
          05 LOG-REF-TO   PIC 9(02).
          05 FILLER       PIC X(02).
          05 LOG-MSG      PIC X(20).
          05 FILLER       PIC X(02).
          05 LOG-PNO      PIC X(03).
          05 LOG-PDESC    PIC X(30).
       
      ***************** DB2 *******************
           EXEC SQL INCLUDE SQLCA END-EXEC
           EXEC SQL INCLUDE PRODUCTS END-EXEC
      ***************************************** 
       PROCEDURE DIVISION.
           OPEN INPUT  NEWS
           OPEN OUTPUT FLOG
           WRITE ENR-LOG FROM LOG-HEAD
       
           PERFORM LECT-NEWS
       
           PERFORM UNTIL FF-NEWS
              SET DATA-OK TO TRUE
              PERFORM PARSE-LINE
       
              IF PROD-PRICE > 0 AND DATA-OK
                  MOVE PROD-NO             TO PR-P-NO
                  MOVE PROD-PRICE          TO PR-PRICE
                  PERFORM FORMAT-DESC
                  PERFORM INSERT-DB
              END-IF
		  
              PERFORM LECT-NEWS
       
           END-PERFORM
       
           CLOSE NEWS FLOG
           GOBACK.
       
      ** PARAGRAPHS **
       LECT-NEWS.
           ADD 1 TO CSV-LINE
           READ NEWS AT END
              SET FF-NEWS TO TRUE
              DISPLAY 'FIN FICHIER NEWS'
           END-READ
           .
      ** PARSE-LINE - splits the CSV ; demilited line into variables for preparing DB2 insertion 
       PARSE-LINE. 
           UNSTRING ENR-CSV DELIMITED BY ';'
               INTO PROD-NO
                    PROD-DESC
                    PROD-PRICE-CSV
                    PROD-DEVISE
           END-UNSTRING
       
		 ** Sanity check of variables
           IF LENGTH  OF PROD-NO IS = 3  AND
              LENGTH  OF PROD-DESC > 0   AND
              LENGTH  OF PROD-DESC < 31  AND
              LENGTH  OF PROD-DEVISE = 2 THEN
              DISPLAY 'ALL FIELDS EXCEPT PRICE ARE GOOD SO FAR '
              SET DATA-OK TO TRUE
              PERFORM CHECK-PRICE
           ELSE
              SET DATA-KO TO TRUE
           END-IF
           .
       
      ** CHECK-PRICE - check if price is actually present in CSV file and properly formatted
       CHECK-PRICE.
           IF PROD-PRICE-CSV = SPACES THEN
              MOVE 'PRICE MISSING'     TO LOG-MSG
              PERFORM WRITE-LOG
              SET DATA-KO TO TRUE
           ELSE
              SET DATA-OK TO TRUE
              COMPUTE PROD-PRICE = FUNCTION NUMVAL(PROD-PRICE-CSV)
              PERFORM USD-CONVERT
           END-IF
           .
       
      ** USD-CONVERT - perform the USD dollar conversion before DB2 insertion 
       USD-CONVERT.
           CALL WS-SSPROG USING
                    PROD-DEVISE
                    PROD-PRICE
                    WS-MSG
       
           IF WS-MSG IS NOT = SPACES THEN
               MOVE    WS-MSG    TO   LOG-MSG
               PERFORM WRITE-LOG
           END-IF
           .
			  
      ** FORMAT-DESC - Transform the Uppercase description to CamelCase style
       FORMAT-DESC.
            MOVE FUNCTION LOWER-CASE(PROD-DESC) TO TMP-DESC
       
            PERFORM VARYING WS-I FROM 1 BY 1 UNTIL
                   WS-I > FUNCTION LENGTH(TMP-DESC)
                   IF WS-I = 1 OR TMP-DESC(WS-I - 1:1) = ' '
                     MOVE FUNCTION UPPER-CASE(TMP-DESC(WS-I:1))
                          TO TMP-DESC(WS-I:1)
                   END-IF
            END-PERFORM
       
            INITIALIZE PROD-DESC
            MOVE TMP-DESC TO PROD-DESC
            MOVE LENGTH OF PROD-DESC TO PR-DESCRIPTION-LEN
            MOVE PROD-DESC           TO PR-DESCRIPTION-TEXT.
       
      ** INSERT-DB - perform the DB2 Insertion after all validations checked 
       INSERT-DB.
           EXEC SQL
             INSERT INTO API2.PRODUCTS
               (P_NO,DESCRIPTION,PRICE)
               VALUES (:PR-P-NO,
                       :PR-DESCRIPTION,
                       :PR-PRICE)
           END-EXEC
           PERFORM EVAL-INSERT.
       
      ** EVAL-INSERT - evaluates the SQLCODE returned by DB2 and trigger a relevant action
       EVAL-INSERT.
           EVALUATE TRUE
               WHEN SQLCODE = ZERO
                  CONTINUE
               WHEN SQLCODE = -803
                  DISPLAY
                    'ERREUR INSERT : DOUBLON SUR-> ' PROD-NO
                  MOVE '  DOUBLON ! -> ' TO LOG-MSG
                  PERFORM WRITE-LOG
               WHEN SQLCODE > ZERO
                  DISPLAY 'WARNING : ' ED-SQLCODE
               WHEN OTHER
                  DISPLAY 'ANOMALIE ' SQLCODE
                  PERFORM ABEND-PROG
            END-EVALUATE
            .
       
      ** WRITE-LOG - writes a log report for rejected products 
       WRITE-LOG.
           COMPUTE LOG-REF-TO = CSV-LINE
           MOVE    PROD-NO        TO LOG-PNO
           MOVE    PROD-DESC      TO LOG-PDESC
           WRITE   ENR-LOG        FROM ST-LOG
           INITIALIZE ST-LOG
           .
			  
      ** ABEND-PROG - Voluntary kill the program execution when bad error happens
       ABEND-PROG.
           EXEC SQL ROLLBACK END-EXEC
           DISPLAY 'ROLLING BACK TO PREV TABLE STATE'
           COMPUTE WS-ANO = 1 / WS-ANO
           .
       
