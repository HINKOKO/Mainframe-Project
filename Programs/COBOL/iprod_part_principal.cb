       IDENTIFICATION DIVISION.
       PROGRAM-ID. IPROD.
    	 AUTHOR.     HINKOKO.
      *********************************************************************
      *   THIS PROGRAM IS INTENDED TO :                                   *  
      *       - PARSE CSV FILE FOR PREPARING A DB12 INSERT                *
      *       - CALL A ROUTINE TO CONVERT PRICE IN USD                    *
      *       - FORMAT DESCRIPTION PRODUCT IN A NICE CAMEL CASE           *
      *       - PERFORM THE DB2 INSERTION (DEALS WITH DB2 ERRORS AS WELL) *
      *********************************************************************
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
              SELECT NEWS ASSIGN TO FICNEWS.
       ******************************************
       DATA DIVISION.
       FILE SECTION.
       FD NEWS.
       01 ENR-NEWS.
          05 ENR-CSV      PIC X(45).
       
       WORKING-STORAGE SECTION.
      *  variables for holding csv parsing *
       01 PROD-NO         PIC X(3).
       01 PROD-DESC       PIC X(20).
       01 PROD-PRICE      PIC 9(3)V99.
       01 PROD-PRICE-CSV  PIC X(6).
       01 PROD-DEVISE     PIC X(2).
       ** VARS CLASSIQUES
       77 NEWS-FLAG      PIC 9 VALUE 0.
            88 FF-NEWS         VALUE 1.
       77 USD-AMOUNT  PIC 9(3)V99.
       77 WS-ANO         PIC 9 VALUE 0.
       01 ED-SQLCODE     PIC +Z(8)9.
       
       ** SOUS PROG ***
       77 WS-SSPROG      PIC X(8) VALUE 'CONVERT'.
       
      ** STRING MANIP UPPER AND LOWER ****
       01 TMP-DESC       PIC X(20).
       01 FIRST-CHAR     PIC X(20).
       01 WS-I           PIC 9(2).
      **************** DB2 *******
           EXEC SQL INCLUDE SQLCA END-EXEC
           EXEC SQL INCLUDE PRODUCTS END-EXEC

       PROCEDURE DIVISION.
           OPEN INPUT NEWS
           PERFORM LECT-NEWS
       
           PERFORM UNTIL FF-NEWS
              PERFORM PARSE-LINE
              PERFORM USD-CONVERT
              IF PROD-PRICE  > 0
                  MOVE PROD-NO             TO PR-P-NO
                  MOVE PROD-PRICE          TO PR-PRICE
                  PERFORM FORMAT-DESC
                  PERFORM INSERT-DB
              ELSE
                  DISPLAY 'ERREUR CONVERSION SUR PROD-NO : '
                       PROD-NO
              END-IF
              PERFORM LECT-NEWS
           END-PERFORM
           GOBACK.
       
      * PARAGRAPHS
       LECT-NEWS.
           READ NEWS AT END
              SET FF-NEWS TO TRUE
              DISPLAY 'FIN FICHIER NEWS'
           END-READ.

       PARSE-LINE.
           UNSTRING ENR-CSV DELIMITED BY ';'
              INTO PROD-NO
                   PROD-DESC
                   PROD-PRICE-CSV
                   PROD-DEVISE
           END-UNSTRING
           DISPLAY 'PRIX (STR) CSV ' PROD-PRICE-CSV
           COMPUTE PROD-PRICE = FUNCTION NUMVAL(PROD-PRICE-CSV).
       
       USD-CONVERT.
           CALL WS-SSPROG USING
                    PROD-DEVISE
                    PROD-PRICE.
       
       FORMAT-DESC.
            MOVE FUNCTION LOWER-CASE(PROD-DESC) TO TMP-DESC
       
            INSPECT TMP-DESC
               REPLACING ALL ' ' BY '*'
            PERFORM VARYING WS-I FROM 1 BY 1 UNTIL
                   WS-I > FUNCTION LENGTH(TMP-DESC)
                   IF WS-I = 1 OR TMP-DESC(WS-I - 1:1) = '*'
                     MOVE FUNCTION UPPER-CASE(TMP-DESC(WS-I:1))
                        TO TMP-DESC(WS-I:1)
                   END-IF
            END-PERFORM
            INSPECT TMP-DESC REPLACING ALL '*' BY ' '
       
            INITIALIZE PROD-DESC
            MOVE TMP-DESC TO PROD-DESC
            MOVE LENGTH OF PROD-DESC TO PR-DESCRIPTION-LEN
            MOVE PROD-DESC           TO PR-DESCRIPTION-TEXT.
       
       INSERT-DB.
           EXEC SQL
             INSERT INTO API2.PRODUCTS
               (P_NO,DESCRIPTION,PRICE)
               VALUES (:PR-P-NO,
                       :PR-DESCRIPTION,
                       :PR-PRICE)
           END-EXEC
           PERFORM EVAL-INSERT.
       
       EVAL-INSERT.
           EVALUATE TRUE
               WHEN SQLCODE = ZERO
                  CONTINUE
               WHEN SQLCODE = -803
                  DISPLAY
                    'ERREUR INSERT : DOUBLON SUR-> ' PROD-NO
               WHEN SQLCODE > ZERO
                  DISPLAY 'WARNING : ' ED-SQLCODE
               WHEN OTHER
                  DISPLAY 'ANOMALIE ' SQLCODE
                  PERFORM ABEND-PROG
            END-EVALUATE.

       ABEND-PROG.
           EXEC SQL ROLLBACK END-EXEC
           DISPLAY 'ROLLING BACK TO PREV TABLE STATE'
           COMPUTE WS-ANO = 1 / WS-ANO.
