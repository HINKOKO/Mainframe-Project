       IDENTIFICATION DIVISION.
       PROGRAM-ID. P5.
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FAFF ASSIGN TO FICAFF.
       
       DATA DIVISION.
       FILE SECTION.
       FD FAFF.
       01 ENR-FAFF PIC X(200).
       
       WORKING-STORAGE SECTION.
      ******************************************
        INSERT DES DECLARATIONS SQL
           EXEC SQL INCLUDE SQLCA  END-EXEC.
        APPEL DU DLCGEN ...
           EXEC SQL INCLUDE PARTS  END-EXEC.
           EXEC SQL INCLUDE PARTSUPP  END-EXEC.
           EXEC SQL INCLUDE SUP    END-EXEC.
      ******************************************
      **  DECLARATION DU CURSEUR ORDERS
       
           EXEC SQL
               DECLARE CURS1 CURSOR
               FOR
               SELECT S.SNO, S.SNAME, P.PNO, P.PNAME, PA.QTY
               FROM API11.PARTSUPP PA
                    JOIN API11.PARTS P ON PA.PNO = P.PNO
                    JOIN API11.SUPPLIER S ON PA.SNO = S.SNO
               GROUP BY S.SNO, S.SNAME, P.PNO, P.PNAME, PA.QTY
           END-EXEC.
       
           EXEC SQL
               DECLARE CURS1 CURSOR
               FOR
               SELECT S.SNO, S.SNAME , P.PNO,
                  P.PNAME, PA.QTY
               FROM API11.PARTSUPP PA JOIN API11.PARTS P ON
                              PA.PNO = P.PNO
                            JOIN API11.SUPPLIER S ON PA.SNO = S.SNO
               GROUP BY S.SNO, S.SNAME, P.PNO, P.PNAME, PA.QTY
               ORDER BY S.SNO, P.PNO
           END-EXEC.
       
           EXEC SQL
               DECLARE CURS2 CURSOR
               FOR
               SELECT P.PNAME, P.PNO
               FROM API11.PARTS P
           END-EXEC.
       
           EXEC SQL
               DECLARE CURS3 CURSOR
               FOR
               SELECT S.SNAME, S.SNO
               FROM API11.SUPPLIER S
           END-EXEC.
       
       
      *** VARIABLES FONCTION ABEND-PROG
       77 WS-ANO PIC 9 VALUE ZERO.
       77 WS-VAR PIC 9 VALUE ZERO.
       
       77 WS-I PIC 99 VALUE ZERO.
       77 WS-J PIC 99 VALUE ZERO.
       
       77 VAR  PIC 9(9) VALUE ZERO.
       77 WS-SQLCODE PIC 9(9) VALUE ZERO.
       
       
       
      *** VARIABLES UTILES DANS REMPLIS-QTY-TABLE.
       77 SNO-CUR         PIC X(2) VALUE SPACE.
       77 PNO-CUR         PIC X(2) VALUE SPACE.
       
       77 WR-SNAME        PIC X(20) VALUE SPACES.
       
      *** VARIABLES CORRESPONDANTS PARTSUPP
       77 WR-QTY          PIC 9(2)  VALUE ZERO.
       
      *** VARIABLES CORRESPONDANTS PARTS
       77 WS-PNAME     PIC X(30) VALUE SPACES.
       
       77 CH1          PIC X(20) VALUE SPACES.
       77 CH-LIGNE     PIC X(44) VALUE '*'.
       77 TARGET-CH    PIC X(300).
       
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
       
            PERFORM REMPLIS-PARTS-TAB
            PERFORM REMPLIS-SUP-TAB
            PERFORM REMPLIS-QTY-TABLE
            PERFORM AFFICHE
            PERFORM AFFICHE2
            GOBACK.
      ********************************************
      *  PARAGRAPHES
      ********************************************
      * CLOSE-FAFF.
      *     CLOSE FAFF.
      * OPEN-FAFF.
      *     OPEN OUTPUT FAFF.
      * CLOSE-CURS.
      * *   EXEC SQL CLOSE CURS END-EXEC.
       
      * OPEN-CURS.
      *     EXEC SQL
      *       OPEN CURS
      *     END-EXEC.
       
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
       
    *>    FETCH-CURS.
    *>        EXEC SQL
    *>            FETCH CURS
    *>            INTO :SUP-SNAME, :PARTS-PNAME, :PARTSUPP-QTY
    *>        END-EXEC.
       
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
           COMPUTE WS-ANO = WS-ANO / WS-VAR.
       
       REMPLIS-TABLE1.
           MOVE 12345 TO QTY-VALUE (1, 1)
           MOVE 67890 TO QTY-VALUE (1, 2)
           MOVE 11111 TO QTY-VALUE (1, 3)
           MOVE 22222 TO QTY-VALUE (1, 4)
           MOVE 33333 TO QTY-VALUE (1, 5)
       
           MOVE 54321 TO QTY-VALUE (2, 1)
           MOVE 98765 TO QTY-VALUE (2, 2)
           MOVE 66666 TO QTY-VALUE (2, 3)
           MOVE 77777 TO QTY-VALUE (2, 4)
           MOVE 88888 TO QTY-VALUE (2, 5)
                         .
       
       AFFICHE-TABLE.
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 30
               DISPLAY "ROW "   WS-I
               PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > 5
                   DISPLAY  QTY-VALUE (WS-I, WS-J)
       
               END-PERFORM
           END-PERFORM.
       
       AFFICHE-PARTS-TAB.
            PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > LG-PARTS
                DISPLAY 'I = ' WS-I ' PNAME = ' TAB-PNAME(WS-I)
                DISPLAY 'I = ' WS-I ' PNO = '   TAB-PNO(WS-I)
                DISPLAY '*****************************'
            END-PERFORM
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
            PERFORM CLOSE-CURS3
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
       
       AFFICHE-SUP-TAB.
            PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > LG-SUP
            END-PERFORM
           .
    *>    REMPLI.
    *>         MOVE 'S1' TO QTY-ROW-SNO(1)
    *>         MOVE 'NEWEGG' TO QTY-ROW-SNAME(1)
    *>         MOVE 'S2' TO QTY-ROW-SNO(2)
    *>         MOVE 'MICRO CENTER' TO QTY-ROW-SNAME(2)
    *>         MOVE 'S3' TO QTY-ROW-SNO(3)
    *>         MOVE 'ADAFRUIT' TO QTY-ROW-SNAME(3)
       
       
    *>         MOVE 10 TO QTY-VALUE (1, 1)
    *>         MOVE 20 TO QTY-VALUE (1, 2)
    *>         MOVE 90 TO QTY-VALUE (1, 3)
    *>         MOVE 20 TO QTY-VALUE (1, 5)
       
    *>         MOVE 12 TO QTY-VALUE (2, 1)
    *>         MOVE 15 TO QTY-VALUE (2, 3)
    *>         MOVE 25 TO QTY-VALUE (2, 4)
       
    *>         MOVE 18 TO QTY-VALUE (3, 2)
    *>         MOVE 20 TO QTY-VALUE (3, 4)
    *>         MOVE 30 TO QTY-VALUE (3, 5)
    *>         .
       
       AFFICHE.
       
            STRING
                   CH1         DELIMITED BY SIZE
                   ' '        DELIMITED BY SIZE
                   TAB-PNAME(1)  DELIMITED BY ' '
                   ' '                        ' '
                   TAB-PNAME(2)  DELIMITED BY ' '
                   ' '        DELIMITED BY ' '
                   TAB-PNAME(3)  DELIMITED BY ' '
                   ' '        DELIMITED BY SIZE
                   TAB-PNAME(4)  DELIMITED BY ' '
                   ' '        DELIMITED BY ' '
                   TAB-PNAME(5)  DELIMITED BY ' '
                   ' '        DELIMITED BY ' '
            INTO TARGET-CH
            END-STRING
       
            DISPLAY TARGET-CH
            MOVE ALL "*" TO CH-LIGNE
            DISPLAY CH-LIGNE
            PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I  > 3
      ****      DISPLAY QTY-ROW-SNAME(WS-I), ' '
               DISPLAY TAB-SNAME(WS-I), ' ',
                   QTY-VALUE (WS-I, 1), ' ',
                   QTY-VALUE (WS-I, 2), ' ',
                   QTY-VALUE (WS-I, 3), ' ',
                   QTY-VALUE (WS-I, 4), ' ',
                   QTY-VALUE (WS-I, 5)  ' '
            END-PERFORM
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
       
                    *>   INITIALIZE  ST-SUP
                    *>   INITIALIZE  ST-PARTS
                    *>   INITIALIZE  ST-PARTSUPP
                    *>   PERFORM FETCH-CURS1
                    *>   PERFORM TEST-SQLCODE
              END-PERFORM
              ADD 1 TO WS-I
              END-PERFORM
              PERFORM CLOSE-CURS1
                   .
       AFFICHE2.
           DISPLAY 'TOTO'
           DISPLAY TAB-PNAME(1) (1:5)
       
           DISPLAY TAB-PNAME(2)
           DISPLAY TAB-PNAME(3)
           DISPLAY TAB-PNAME(4)
           DISPLAY TAB-PNAME(5)
           DISPLAY 'TITI'
       
           MOVE SPACES TO TARGET-CH
       
           STRING
               CH1                 DELIMITED BY ' '
               TAB-PNAME(1) (1:20) DELIMITED BY ' '
               ' '                 DELIMITED BY ' '
               TAB-PNAME(2) (1:20) DELIMITED BY ' '
               ' '                 DELIMITED BY ' '
               TAB-PNAME(3) (1:20) DELIMITED BY ' '
               ' '                 DELIMITED BY ' '
               TAB-PNAME(4) (1:20) DELIMITED BY ' '
               ' '                 DELIMITED BY ' '
               TAB-PNAME(5) (1:20) DELIMITED BY ' '
               ' '                 DELIMITED BY ' '
           INTO TARGET-CH
           END-STRING
       
           MOVE SPACES TO TARGET-CH
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-J > 5
           STRING
               TAB-SNAME(WS-I)        DELIMITED ' '
               ' '                 DELIMITED BY SIZE
               QTY-VALUE (WS-I, 1) DELIMITED BY SIZE
               ' '                 DELIMITED BY SIZE
               QTY-VALUE (WS-I, 2) DELIMITED BY SIZE
               ' '                 DELIMITED BY SIZE
               QTY-VALUE (WS-I, 3) DELIMITED BY SIZE
               ' '                 DELIMITED BY SIZE
               QTY-VALUE (WS-I, 4) DELIMITED BY SIZE
               ' '                 DELIMITED BY SIZE
               QTY-VALUE (WS-I, 5) DELIMITED BY SIZE
           INTO TARGET-CH
           END-STRING
           DISPLAY TARGET-CH
           DISPLAY QTY-VALUE (1, 5)
           END-PERFORM
                .
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       