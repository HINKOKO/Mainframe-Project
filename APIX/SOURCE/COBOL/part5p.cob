       IDENTIFICATION DIVISION.
       PROGRAM-ID.      PART5P.
       AUTHOR.            REMI.
      *******************************************************
      *   THIS PROGRAM IS INTENDED TO GENERATE              *
      *   AN ARRAY REPRESENTING THE QUANTITY OF PRODUCTS    *
      *   SUPPLIED BY EACH SUPPLIER                         *
      *******************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FSTAT ASSIGN TO FICSTATS.
       
       DATA DIVISION.
       FILE SECTION.
       FD FSTAT.
       01 ENR-FSTAT PIC X(100).
       
       WORKING-STORAGE SECTION.
      *****************************************
           EXEC SQL INCLUDE SQLCA  END-EXEC.
           EXEC SQL INCLUDE PARTS  END-EXEC.
           EXEC SQL INCLUDE PARTSUPP  END-EXEC.
           EXEC SQL INCLUDE SUP    END-EXEC.
      *****************************************
      *** DECLARATION DU CURSEUR ORDERS ***
           EXEC SQL
               DECLARE CURS1 CURSOR
               FOR
               SELECT S.SNO, S.SNAME , P.PNO,
                  P.PNAME, PA.QTY
               FROM API10.PARTSUPP PA JOIN API10.PARTS P ON
                              PA.PNO = P.PNO
                            JOIN API10.SUPPLIER S ON PA.SNO = S.SNO
               GROUP BY S.SNO, S.SNAME, P.PNO, P.PNAME, PA.QTY
               ORDER BY S.SNO, P.PNO
           END-EXEC.
       
           EXEC SQL
               DECLARE CURS2 CURSOR
               FOR
               SELECT P.PNAME, P.PNO
               FROM API10.PARTS P
           END-EXEC.
       
           EXEC SQL
               DECLARE CURS3 CURSOR
               FOR
               SELECT S.SNAME, S.SNO
               FROM API10.SUPPLIER S
           END-EXEC.
       
      *** VARIABLES FONCTION ABEND-PROG ***
       77 WS-ANO PIC 9 VALUE ZERO.
       77 WS-VAR PIC 9 VALUE ZERO.
       
       77 WS-I PIC 99 VALUE ZERO.
       77 WS-J PIC 99 VALUE ZERO.
       
       77 VAR  PIC 9(9) VALUE ZERO.
       77 WS-SQLCODE PIC 9(9) VALUE ZERO.
       
       
       
      *** VARIABLES UTILES DANS REMPLIS-QTY-TABLE. ***
       77 SNO-CUR         PIC X(2) VALUE SPACE.
       77 PNO-CUR         PIC X(2) VALUE SPACE.
       
       77 WR-SNAME        PIC X(20) VALUE SPACES.
       
      *** VARIABLES CORRESPONDANTS PARTSUPP ***
       77 WR-QTY          PIC 9(2)  VALUE ZERO.
       
      *** VARIABLES CORRESPONDANTS PARTS ***
       77 WS-PNAME     PIC X(30) VALUE SPACES.
       
       01 L-TIRET.
          02 FILLER PIC X.
          02 FILLER PIC X(97) VALUE ALL '-'.
          02 FILLER PIC X(2) VALUE ALL ' '.
       01 L-PROD.
          02 FILLER PIC X.
          02 FILLER PIC X VALUE '|'.
          02 FILLER PIC X(15) VALUE ALL ' '.
          02 FILLER PIC X VALUE '|'.
          02 L-PRO1 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 L-PRO2 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 L-PRO3 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 L-PRO4 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 L-PRO5 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 FILLER PIC X(2) VALUE ALL ' '.
       01 L-STATS.
          02 FILLER PIC X.
          02 FILLER PIC X VALUE '|'.
          02 L-SUP  PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 L-STAT1 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 L-STAT2 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 L-STAT3 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 L-STAT4 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 L-STAT5 PIC X(15).
          02 FILLER PIC X VALUE '|'.
          02 FILLER PIC X(2) VALUE ALL ' '.
      ** TABLEAUX ***
       01 TABLEAU.
           05 PARTS-TAB OCCURS 5 TIMES.
               10 TAB-PNAME PIC X(30).
               10 TAB-PNO   PIC X(2).
           05 LG-PARTS  PIC 99.
           05 SUP-TAB  OCCURS 5 TIMES.
               10 TAB-SNAME PIC X(20).
               10 TAB-SNO   PIC X(2).
           05 LG-SUP    PIC 99.
       
       01 QTY-TABLE.
          05 QTY-ROW OCCURS 3 TIMES.
             10 QTY-ROW-SNO     PIC X(2)  VALUE SPACES.
             10 QTY-ROW-SNAME   PIC X(20) VALUE SPACES.
             10 QTY-COL OCCURS 5 TIMES.
                15 QTY-VALUE PIC 9(2)     VALUE ZERO.
       
       
       PROCEDURE DIVISION.
       
            PERFORM OPEN-FSTAT
            PERFORM REMPLIS-PARTS-TAB
            PERFORM REMPLIS-SUP-TAB
            PERFORM REMPLIS-QTY-TABLE
            PERFORM AFFICHE
            PERFORM CLOSE-FSTAT
            GOBACK.
      *******************************************
      *  PARAGRAPHES
      *******************************************
       
       CLOSE-CURS1.
           EXEC SQL CLOSE CURS1 END-EXEC.
       
       CLOSE-CURS2.
           EXEC SQL CLOSE CURS2 END-EXEC.
       
       CLOSE-CURS3.
           EXEC SQL CLOSE CURS3 END-EXEC.
       
       OPEN-CURS1.
           EXEC SQL
             OPEN CURS1
           END-EXEC.
       
       OPEN-CURS2.
           EXEC SQL
             OPEN CURS2
           END-EXEC.
       
       OPEN-CURS3.
           EXEC SQL
             OPEN CURS3
           END-EXEC.
       
       
       FETCH-CURS1.
           EXEC SQL
               FETCH CURS1
               INTO :SUP-SNO, :SUP-SNAME, :PARTS-PNO, :PARTS-PNAME,
                       :PARTSUPP-QTY
           END-EXEC.
       
       FETCH-CURS2.
           EXEC SQL
               FETCH CURS2
               INTO :PARTS-PNAME, :PARTS-PNO
           END-EXEC.
       
       FETCH-CURS3.
           EXEC SQL
               FETCH CURS3
               INTO :SUP-SNAME, :SUP-SNO
           END-EXEC.
       
       TEST-SQLCODE.
           EVALUATE TRUE
               WHEN SQLCODE = ZERO
                    CONTINUE
               WHEN SQLCODE > ZERO
               MOVE SQLCODE TO WS-SQLCODE
                    DISPLAY 'WARNING : ' WS-SQLCODE
               WHEN OTHER
               MOVE SQLCODE TO WS-SQLCODE
                    DISPLAY 'ANOMALIE GRAVE : ' WS-SQLCODE
                    PERFORM ABEND-PROG
           END-EVALUATE.
       ABEND-PROG.
           COMPUTE WS-ANO = WS-ANO / WS-VAR
           .
       
       
       REMPLIS-PARTS-TAB.
           PERFORM OPEN-CURS2
           PERFORM FETCH-CURS2
           PERFORM TEST-SQLCODE
           MOVE ZERO TO WS-I
           PERFORM UNTIL SQLCODE NOT EQUAL ZERO
               ADD 1 TO WS-I
               MOVE PARTS-PNO TO TAB-PNO(WS-I)
               MOVE PARTS-PNAME-TEXT(1:PARTS-PNAME-LEN) TO
                    TAB-PNAME(WS-I)
               INITIALIZE  ST-PARTS
               PERFORM FETCH-CURS2
               PERFORM TEST-SQLCODE
           END-PERFORM
           MOVE WS-I TO LG-PARTS
           PERFORM CLOSE-CURS2
           .
       
       REMPLIS-SUP-TAB.
           PERFORM OPEN-CURS3
           PERFORM FETCH-CURS3
           PERFORM TEST-SQLCODE
           MOVE ZERO TO WS-I
           PERFORM UNTIL SQLCODE NOT EQUAL ZERO
               ADD 1 TO WS-I
               MOVE SUP-SNO TO TAB-SNO(WS-I)
               MOVE SUP-SNAME-TEXT(1:SUP-SNAME-LEN) TO
                    TAB-SNAME(WS-I)
               INITIALIZE  ST-SUP
               PERFORM FETCH-CURS3
               PERFORM TEST-SQLCODE
           END-PERFORM
           MOVE WS-I TO LG-SUP
           PERFORM CLOSE-CURS3
           .
       
       
       AFFICHE.
           MOVE TAB-PNAME(1) TO L-PRO1
           MOVE TAB-PNAME(2) TO L-PRO2
           MOVE TAB-PNAME(3) TO L-PRO3
           MOVE TAB-PNAME(4) TO L-PRO4
           MOVE TAB-PNAME(5) TO L-PRO5
           WRITE ENR-FSTAT FROM L-TIRET
           WRITE ENR-FSTAT FROM L-PROD
           WRITE ENR-FSTAT FROM L-TIRET
       
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I  > 3
               MOVE TAB-SNAME(WS-I) TO L-SUP
               MOVE QTY-VALUE (WS-I, 1) TO L-STAT1
               MOVE QTY-VALUE (WS-I, 2) TO L-STAT2
               MOVE QTY-VALUE (WS-I, 3) TO L-STAT3
               MOVE QTY-VALUE (WS-I, 4) TO L-STAT4
               MOVE QTY-VALUE (WS-I, 5) TO L-STAT5
               WRITE ENR-FSTAT FROM L-STATS
           END-PERFORM
           WRITE ENR-FSTAT FROM L-TIRET
           .
       
       REMPLIS-QTY-TABLE.
           PERFORM OPEN-CURS1
           INITIALIZE  ST-SUP
           INITIALIZE  ST-PARTS
           INITIALIZE  ST-PARTSUPP
           PERFORM FETCH-CURS1
           PERFORM TEST-SQLCODE
           MOVE 1 TO WS-I
           PERFORM UNTIL SQLCODE NOT EQUAL ZERO
       
             MOVE TAB-SNO(WS-I) TO SNO-CUR
             PERFORM UNTIL SUP-SNO NOT EQUAL SNO-CUR OR
                                             SQLCODE NOT EQUAL ZERO
                 MOVE  1 TO WS-J
                     PERFORM UNTIL WS-J > 5 OR SUP-SNO NOT EQUAL SNO-CUR
                       MOVE TAB-PNO(WS-J) TO PNO-CUR
                       IF PARTS-PNO EQUAL  PNO-CUR
                           MOVE PARTSUPP-QTY TO QTY-VALUE(WS-I, WS-J)
                                PNO-CUR
                           INITIALIZE  ST-SUP
                           INITIALIZE  ST-PARTS
                           INITIALIZE  ST-PARTSUPP
                           PERFORM FETCH-CURS1
                           PERFORM TEST-SQLCODE
                       END-IF
                       ADD 1 TO WS-J
                      END-PERFORM
       
              END-PERFORM
              ADD 1 TO WS-I
           END-PERFORM
           PERFORM CLOSE-CURS1
           .
       CLOSE-FSTAT.
           CLOSE FSTAT
           .
       OPEN-FSTAT.
           OPEN OUTPUT FSTAT
           .
