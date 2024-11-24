000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. PART5P.
000300
000400 ENVIRONMENT DIVISION.
000500 CONFIGURATION SECTION.
000600 SPECIAL-NAMES.
000700     DECIMAL-POINT IS COMMA.
000800
000900 INPUT-OUTPUT SECTION.
001000 FILE-CONTROL.
001100     SELECT FSTAT ASSIGN TO FICSTATS.
001310
001320 DATA DIVISION.
001400 FILE SECTION.
001610 FD FSTAT.
001620 01 ENR-FSTAT PIC X(100).
001900
002000 WORKING-STORAGE SECTION.
002001******************************************
002002* INSERT DES DECLARATIONS SQL
002003     EXEC SQL INCLUDE SQLCA  END-EXEC.
002004* APPEL DU DLCGEN ...
002005     EXEC SQL INCLUDE PARTS  END-EXEC.
002006     EXEC SQL INCLUDE PARTSUPP  END-EXEC.
002007     EXEC SQL INCLUDE SUP    END-EXEC.
002017******************************************
002018* DECLARATION DU CURSEUR ORDERS
002042     EXEC SQL
002043         DECLARE CURS1 CURSOR
002044         FOR
002045         SELECT S.SNO, S.SNAME , P.PNO,
002046            P.PNAME, PA.QTY
002047         FROM API10.PARTSUPP PA JOIN API10.PARTS P ON
002048                        PA.PNO = P.PNO
002049                      JOIN API10.SUPPLIER S ON PA.SNO = S.SNO
002050         GROUP BY S.SNO, S.SNAME, P.PNO, P.PNAME, PA.QTY
002051         ORDER BY S.SNO, P.PNO
002052     END-EXEC.
002060
002063     EXEC SQL
002064         DECLARE CURS2 CURSOR
002065         FOR
002066         SELECT P.PNAME, P.PNO
002067         FROM API10.PARTS P
002068     END-EXEC.
002069
002070     EXEC SQL
002071         DECLARE CURS3 CURSOR
002072         FOR
002073         SELECT S.SNAME, S.SNO
002074         FROM API10.SUPPLIER S
002075     END-EXEC.
002076
002078* VARIABLES FONCTION ABEND-PROG
002079 77 WS-ANO PIC 9 VALUE ZERO.
002080 77 WS-VAR PIC 9 VALUE ZERO.
002081
002082 77 WS-I PIC 99 VALUE ZERO.
002083 77 WS-J PIC 99 VALUE ZERO.
002090
002091 77 VAR  PIC 9(9) VALUE ZERO.
002092 77 WS-SQLCODE PIC 9(9) VALUE ZERO.
002093
002100
002314
002315* VARIABLES UTILES DANS REMPLIS-QTY-TABLE.
002326 77 SNO-CUR         PIC X(2) VALUE SPACE.
002327 77 PNO-CUR         PIC X(2) VALUE SPACE.
002328
002329 77 WR-SNAME        PIC X(20) VALUE SPACES.
002330
002331* VARIABLES CORRESPONDANTS PARTSUPP
002332 77 WR-QTY          PIC 9(2)  VALUE ZERO.
002333
002334* VARIABLES CORRESPONDANTS PARTS
002335 77 WS-PNAME     PIC X(30) VALUE SPACES.
002336
002343* EDIT LINE
002344 01 L-TIRET.
002345    02 FILLER PIC X.
002346    02 FILLER PIC X(97) VALUE ALL '-'.
002347    02 FILLER PIC X(2) VALUE ALL ' '.
002351 01 L-PROD.
002352    02 FILLER PIC X.
002353    02 FILLER PIC X VALUE '|'.
002354    02 FILLER PIC X(15) VALUE ALL ' '.
002355    02 FILLER PIC X VALUE '|'.
002356    02 L-PRO1 PIC X(15).
002357    02 FILLER PIC X VALUE '|'.
002358    02 L-PRO2 PIC X(15).
002359    02 FILLER PIC X VALUE '|'.
002360    02 L-PRO3 PIC X(15).
002361    02 FILLER PIC X VALUE '|'.
002362    02 L-PRO4 PIC X(15).
002363    02 FILLER PIC X VALUE '|'.
002364    02 L-PRO5 PIC X(15).
002365    02 FILLER PIC X VALUE '|'.
002366    02 FILLER PIC X(2) VALUE ALL ' '.
002367 01 L-STATS.
002368    02 FILLER PIC X.
002369    02 FILLER PIC X VALUE '|'.
002370    02 L-SUP  PIC X(15).
002371    02 FILLER PIC X VALUE '|'.
002372    02 L-STAT1 PIC X(15).
002373    02 FILLER PIC X VALUE '|'.
002374    02 L-STAT2 PIC X(15).
002375    02 FILLER PIC X VALUE '|'.
002376    02 L-STAT3 PIC X(15).
002377    02 FILLER PIC X VALUE '|'.
002378    02 L-STAT4 PIC X(15).
002379    02 FILLER PIC X VALUE '|'.
002380    02 L-STAT5 PIC X(15).
002381    02 FILLER PIC X VALUE '|'.
002382    02 FILLER PIC X(2) VALUE ALL ' '.
002383* TABLE
002384 01 TABLEAU.
002385     05 PARTS-TAB OCCURS 5 TIMES.
002386         10 TAB-PNAME PIC X(30).
002387         10 TAB-PNO   PIC X(2).
002388     05 LG-PARTS  PIC 99.
002389     05 SUP-TAB  OCCURS 5 TIMES.
002390         10 TAB-SNAME PIC X(20).
002391         10 TAB-SNO   PIC X(2).
002392     05 LG-SUP    PIC 99.
002393
002394 01 QTY-TABLE.
002395    05 QTY-ROW OCCURS 3 TIMES.
002396       10 QTY-ROW-SNO     PIC X(2)  VALUE SPACES.
002397       10 QTY-ROW-SNAME   PIC X(20) VALUE SPACES.
002398       10 QTY-COL OCCURS 5 TIMES.
002400          15 QTY-VALUE PIC 9(2)     VALUE ZERO.
002444
002464
002465 PROCEDURE DIVISION.
002480
003712      PERFORM OPEN-FSTAT
003713      PERFORM REMPLIS-PARTS-TAB
003719      PERFORM REMPLIS-SUP-TAB
003735      PERFORM REMPLIS-QTY-TABLE
003736      PERFORM AFFICHE
003737      PERFORM CLOSE-FSTAT
004100      GOBACK.
004110********************************************
004120* PARAGRAPHES
004200********************************************
004798
004799 CLOSE-CURS1.
004800     EXEC SQL CLOSE CURS1 END-EXEC.
004801
004802 CLOSE-CURS2.
004803     EXEC SQL CLOSE CURS2 END-EXEC.
004804
004805 CLOSE-CURS3.
004806     EXEC SQL CLOSE CURS3 END-EXEC.
004807
004808 OPEN-CURS1.
004809     EXEC SQL
004810       OPEN CURS1
004811     END-EXEC.
004812
004813 OPEN-CURS2.
004814     EXEC SQL
004815       OPEN CURS2
004816     END-EXEC.
004817
004818 OPEN-CURS3.
004819     EXEC SQL
004820       OPEN CURS3
004821     END-EXEC.
004822
004828
004829 FETCH-CURS1.
004830     EXEC SQL
004831         FETCH CURS1
004832         INTO :SUP-SNO, :SUP-SNAME, :PARTS-PNO, :PARTS-PNAME,
004833                 :PARTSUPP-QTY
004834     END-EXEC.
004835
004836 FETCH-CURS2.
004837     EXEC SQL
004838         FETCH CURS2
004839         INTO :PARTS-PNAME, :PARTS-PNO
004840     END-EXEC.
004841
004842 FETCH-CURS3.
004843     EXEC SQL
004844         FETCH CURS3
004845         INTO :SUP-SNAME, :SUP-SNO
004846     END-EXEC.
004847
004848 TEST-SQLCODE.
004849     EVALUATE TRUE
004850         WHEN SQLCODE = ZERO
004851              CONTINUE
004852         WHEN SQLCODE > ZERO
004853         MOVE SQLCODE TO WS-SQLCODE
004854*             DISPLAY 'WARNING : ' WS-SQLCODE
004855         WHEN OTHER
004856         MOVE SQLCODE TO WS-SQLCODE
004857              DISPLAY 'ANOMALIE GRAVE : ' WS-SQLCODE
004858              PERFORM ABEND-PROG
004859     END-EVALUATE.
004860 ABEND-PROG.
004861     COMPUTE WS-ANO = WS-ANO / WS-VAR
004862     .
004898
006900
007000 REMPLIS-PARTS-TAB.
007100     PERFORM OPEN-CURS2
007200     PERFORM FETCH-CURS2
007300     PERFORM TEST-SQLCODE
007310     MOVE ZERO TO WS-I
007400     PERFORM UNTIL SQLCODE NOT EQUAL ZERO
007500         ADD 1 TO WS-I
007700         MOVE PARTS-PNO TO TAB-PNO(WS-I)
007800         MOVE PARTS-PNAME-TEXT(1:PARTS-PNAME-LEN) TO
007900              TAB-PNAME(WS-I)
008000         INITIALIZE  ST-PARTS
008100         PERFORM FETCH-CURS2
008110         PERFORM TEST-SQLCODE
008200     END-PERFORM
008210     MOVE WS-I TO LG-PARTS
008300     PERFORM CLOSE-CURS2
008400     .
008500
008510 REMPLIS-SUP-TAB.
008520     PERFORM OPEN-CURS3
008530     PERFORM FETCH-CURS3
008540     PERFORM TEST-SQLCODE
008550     MOVE ZERO TO WS-I
008560     PERFORM UNTIL SQLCODE NOT EQUAL ZERO
008570         ADD 1 TO WS-I
008590         MOVE SUP-SNO TO TAB-SNO(WS-I)
008592         MOVE SUP-SNAME-TEXT(1:SUP-SNAME-LEN) TO
008593              TAB-SNAME(WS-I)
008594         INITIALIZE  ST-SUP
008595         PERFORM FETCH-CURS3
008596         PERFORM TEST-SQLCODE
008597     END-PERFORM
008598     MOVE WS-I TO LG-SUP
008599     PERFORM CLOSE-CURS3
008600     .
008601
011940
011950 AFFICHE.
011960     MOVE TAB-PNAME(1) TO L-PRO1
011961     MOVE TAB-PNAME(2) TO L-PRO2
011962     MOVE TAB-PNAME(3) TO L-PRO3
011963     MOVE TAB-PNAME(4) TO L-PRO4
011964     MOVE TAB-PNAME(5) TO L-PRO5
011968     WRITE ENR-FSTAT FROM L-TIRET
011969     WRITE ENR-FSTAT FROM L-PROD
011970     WRITE ENR-FSTAT FROM L-TIRET
011980
011984     PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I  > 3
011986         MOVE TAB-SNAME(WS-I) TO L-SUP
011987         MOVE QTY-VALUE (WS-I, 1) TO L-STAT1
011988         MOVE QTY-VALUE (WS-I, 2) TO L-STAT2
011989         MOVE QTY-VALUE (WS-I, 3) TO L-STAT3
011990         MOVE QTY-VALUE (WS-I, 4) TO L-STAT4
011991         MOVE QTY-VALUE (WS-I, 5) TO L-STAT5
011992         WRITE ENR-FSTAT FROM L-STATS
012000     END-PERFORM
012001     WRITE ENR-FSTAT FROM L-TIRET
012012     .
012015
012016 REMPLIS-QTY-TABLE.
012017     PERFORM OPEN-CURS1
012018     INITIALIZE  ST-SUP
012019     INITIALIZE  ST-PARTS
012020     INITIALIZE  ST-PARTSUPP
012021     PERFORM FETCH-CURS1
012022     PERFORM TEST-SQLCODE
012023     MOVE 1 TO WS-I
012025     PERFORM UNTIL SQLCODE NOT EQUAL ZERO
012026
012027       MOVE TAB-SNO(WS-I) TO SNO-CUR
012029       PERFORM UNTIL SUP-SNO NOT EQUAL SNO-CUR OR
012030                                       SQLCODE NOT EQUAL ZERO
012031           MOVE  1 TO WS-J
012034               PERFORM UNTIL WS-J > 5 OR SUP-SNO NOT EQUAL SNO-CUR
012035                 MOVE TAB-PNO(WS-J) TO PNO-CUR
012037                 IF PARTS-PNO EQUAL  PNO-CUR
012038                     MOVE PARTSUPP-QTY TO QTY-VALUE(WS-I, WS-J)
012040                          PNO-CUR
012041                     INITIALIZE  ST-SUP
012042                     INITIALIZE  ST-PARTS
012043                     INITIALIZE  ST-PARTSUPP
012044                     PERFORM FETCH-CURS1
012045                     PERFORM TEST-SQLCODE
012046                 END-IF
012047                 ADD 1 TO WS-J
012049                END-PERFORM
012050
012080        END-PERFORM
012090        ADD 1 TO WS-I
012200     END-PERFORM
012300     PERFORM CLOSE-CURS1
012400     .
012500 CLOSE-FSTAT.
012600     CLOSE FSTAT
012610     .
012700 OPEN-FSTAT.
012800     OPEN OUTPUT FSTAT
012810     .
012900
013000
013100
013200