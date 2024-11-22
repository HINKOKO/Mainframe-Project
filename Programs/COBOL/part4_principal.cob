       IDENTIFICATION  DIVISION.
       PROGRAM-ID.       PART4P.
       AUTHOR.          HINKOKO.
      *******************************************************
      *    THIS PROGRAM IS INTENDED TO :                    *
      *      - CREATE AN XML FILE FOR CONSULTING            *
      *      COMPANY IN MARKET STUDY                        *
      *      - SORT PRODUCTS  BY BEST RANKING               *
      *  Dependencies -> copybook 'stxml' (apixx.cob.cpy)   *
      *******************************************************
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
              SELECT ENRXML ASSIGN TO FXML.
      ******************************************
       DATA DIVISION.
       FILE SECTION.
       FD ENRXML.
       01 ENR-XML PIC X(79).
       
       WORKING-STORAGE SECTION.
       COPY STXML.
       
       01 XML-PROLOG.                                                 
           05 FILLER         PIC X(38).                                
       01 PROLOG             PIC X(38)                                 
               VALUE '<?XML VERSION="1.0" ENCODING="UTF-8"?>'. 
       01 DESIG-STRING      PIC X(79).
       
       01 LINE-COUNT        PIC 9(03) VALUE 0.
       01 PAGE-LIMIT        PIC 9(02) VALUE 50.
       01 PROD-LINE-COUNT   PIC 9(01) VALUE 5.
       
       01 WS-RANK           PIC 9(02) VALUE 1.
       01 STRING-RANK       PIC X(80).
       
       77 IT-VOLUME         PIC S9(2)V USAGE COMP-3.
       77 SEP               PIC X(70) VALUE ALL SPACES.
       77 WS-ANO            PIC 9(01) VALUE 0.
       
       ** EDITOR MODE ***
       01 ED-SQLCODE        PIC +Z(8)9.
       
       01 ED-RANK           PIC ZZ9.
       01 ED-VOLUME         PIC ZZ9.
       01 ED-DESIG          PIC X(30).
      ****************       DB2      ***************
           EXEC SQL INCLUDE SQLCA    END-EXEC
           EXEC SQL INCLUDE ITEMS    END-EXEC
           EXEC SQL INCLUDE PRODUCTS END-EXEC
       
           EXEC SQL
              DECLARE CITEMS CURSOR
              FOR SELECT
                   I.P_NO,
                   P.DESCRIPTION,
                   SUM(I.QUANTITY) AS VOL
                FROM API2.ITEMS I
                JOIN API2.PRODUCTS P
                ON I.P_NO = P.P_NO
                GROUP BY I.P_NO, P.DESCRIPTION
                ORDER BY VOL DESC
           END-EXEC
       
      ***********************************************
       PROCEDURE DIVISION.
           OPEN OUTPUT ENRXML
           
      **************************************************** 
      * WRITING THE XML PROLOGUE TO MEET XML STANDARDS   * 
      **************************************************** 
           MOVE FUNCTION LOWER-CASE(PROLOG) TO XML-PROLOG  
           WRITE ENR-XML FROM XML-PROLOG
           EXEC SQL OPEN CITEMS END-EXEC
           PERFORM TEST-SQLCODE
       
           PERFORM RANK-ITEMS
       
           EXEC SQL CLOSE CITEMS END-EXEC
           PERFORM TEST-SQLCODE
       
           CLOSE ENRXML
       
           GOBACK.
       
      *** PARAGRAPHS ***
       RANK-ITEMS.
           PERFORM FETCH-ITEMS
           MOVE 1 TO WS-RANK
           WRITE ENR-XML FROM ST-OPEN-VT
       
           PERFORM UNTIL SQLCODE NOT = 0
       
               PERFORM WRITE-XML
               PERFORM FETCH-ITEMS
               ADD 1 TO WS-RANK
       
           END-PERFORM
           WRITE ENR-XML FROM ST-CLOSE-VT
           .
       
       WRITE-XML.
           IF WS-RANK < 3 THEN
             PERFORM SHOWCASE-SYSOUT
             DISPLAY SEP
           END-IF
       
           MOVE WS-RANK    TO RANK-NUMBER
           MOVE IT-VOLUME  TO VOL-VALUE
           MOVE IT-P-NO    TO PROD-NUMBER
       
       ** STARTING TO WRITE ***
           IF LINE-COUNT + PROD-LINE-COUNT > PAGE-LIMIT
              WRITE ENR-XML FROM SEP AFTER ADVANCING PAGE
              MOVE 0 TO LINE-COUNT
           END-IF
       
           PERFORM STRINGIFY-DESIG-AND-VOLUME
       
           WRITE ENR-XML FROM OPENING-PRODUCT
           WRITE ENR-XML FROM ST-RANK
           WRITE ENR-XML FROM DESIG-STRING
           WRITE ENR-XML FROM ST-VOLUME
           WRITE ENR-XML FROM ST-CLOSE-PROD
       
           ADD PROD-LINE-COUNT TO LINE-COUNT
           .
       
       STRINGIFY-DESIG-AND-VOLUME.
           STRING '          '      DELIMITED BY SIZE
                  '<DESIGNATION>'
                  PR-DESCRIPTION-TEXT(1:PR-DESCRIPTION-LEN)
                  '</DESIGNATION>'  DELIMITED BY '  '
            INTO DESIG-STRING
           END-STRING
           .
       
       FETCH-ITEMS.
           INITIALIZE VOL-VALUE PROD-NUMBER DESIG-STRING
           EXEC SQL
             FETCH CITEMS
             INTO :IT-P-NO, :PR-DESCRIPTION, :IT-VOLUME
           END-EXEC
           PERFORM TEST-SQLCODE
           .
       
       SHOWCASE-SYSOUT.
           MOVE
              PR-DESCRIPTION-TEXT(1:PR-DESCRIPTION-LEN) TO ED-DESIG
           MOVE IT-VOLUME TO ED-VOLUME
           MOVE WS-RANK TO ED-RANK
           DISPLAY 'RANKED AS NUMBER: ' ED-RANK
                   '| PRODUCT NUMBER: ' IT-P-NO
                   '| DESIGNATED AS: ' ED-DESIG
           DISPLAY 'HAS BEING SOLD: ' ED-VOLUME ' TIMES.'
           .
       
       TEST-SQLCODE.
           EVALUATE TRUE
                WHEN SQLCODE = ZERO
                   CONTINUE
                WHEN SQLCODE > ZERO
                   IF SQLCODE = +100
                     DISPLAY  'END OF PRODUCT RANKING '
                   END-IF
                   MOVE SQLCODE TO ED-SQLCODE
                   DISPLAY 'WARNING : ' ED-SQLCODE
                WHEN OTHER
                   MOVE SQLCODE TO ED-SQLCODE
                   DISPLAY 'ANOMALIE ' ED-SQLCODE
                   PERFORM ABEND-PROG
            END-EVALUATE
            .
       
       ABEND-PROG.
           EXEC SQL ROLLBACK END-EXEC
           DISPLAY 'ROLLING BACK TO PREV TABLE STATE'
           COMPUTE WS-ANO = 1 / WS-ANO.
       