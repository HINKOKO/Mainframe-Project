       IDENTIFICATION DIVISION.
       PROGRAM-ID.     PART3AP.
       AUTHOR.         MATHIEU.
       
      ******************************************************************
      *    THIS PROGRAM IS INTENDED TO :                               *
      *    - READ ORDERS AND ITEMS FROM DATABASE                       *
      *    - FILLS EXTRACT.DATA IN ORDER TO EDIT BILLS                 *
      ******************************************************************
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FEXT ASSIGN TO FICEXT.
       
       DATA DIVISION.
       FILE SECTION.
      *** DECLARATION ENREGISTREMENTS FICHIER ***
       FD FEXT.
       01 ENR-FEXT PIC X(299).
       
       WORKING-STORAGE SECTION.
      *** INSERT DES DECLARATIONS SQL ***
           EXEC SQL INCLUDE SQLCA  END-EXEC.
           EXEC SQL INCLUDE ITE    END-EXEC.
           EXEC SQL INCLUDE PRO    END-EXEC.
           EXEC SQL INCLUDE ORD    END-EXEC.
           EXEC SQL INCLUDE CUS    END-EXEC.
           EXEC SQL INCLUDE EMP    END-EXEC.
           EXEC SQL INCLUDE DEP    END-EXEC.
      *** DECLARATION DU CURSEUR ORDERS ***
           EXEC SQL
               DECLARE CURS CURSOR
               FOR
               SELECT
               I.P_NO, I.QUANTITY, I.PRICE,
               P.DESCRIPTION,
               O.O_NO, O.O_DATE,
               C.COMPANY, C.ADDRESS ,C.CITY ,C.ZIP, C.STATE,
               E.LNAME, E.FNAME, E.COM,
               D.DNAME
               FROM API10.ITEMS I
               JOIN API10.PRODUCTS P ON P.P_NO = I.P_NO
               JOIN API10.ORDERS O ON O.O_NO = I.O_NO
               JOIN API10.CUSTOMERS C ON C.C_NO = O.C_NO
               JOIN API10.EMPLOYEES E ON E.E_NO = O.S_NO
               JOIN API10.DEPTS D ON D.DEPT = E.DEPT
               ORDER BY O.O_NO ASC, I.P_NO ASC
           END-EXEC.
       
      *** VARIABLES FONCTION ABEND-PROG ***
       77 WS-ANO PIC 9 VALUE ZERO.
       77 WS-VAR PIC 9 VALUE ZERO.
       
      *** VARIABLES EDITION ***
       77 WR-ITE-QUANTITY PIC X(2).
      *** ITE-PRICE DCLGEN  PIC S9(3)V9(2) USAGE COMP-3. ***
       77 WR-ITE-PRICE    PIC X(6).
       77 WR-EMP-COM      PIC X(4).
       77 NC-ITE-PRICE    PIC S9(3)V9(2).
       77 ED-ITE-PRICE    PIC 999V99.
       77 ED-EMP-COM      PIC 9V99.
       77 WR-ORD-O-NO     PIC X(3).
       77 WR-DATAF        PIC X(299).
       
       01 LIGNE.
          05 L-P-NO        PIC X(3) .
          05 L-QUANTITY    PIC X(2) .
          05 L-PRICE       PIC X(6) .
          05 L-DESCRIPTION PIC X(30) .
          05 L-O-NO        PIC X(3) .
          05 L-O-DATE      PIC X(10).
          05 L-COMPANY     PIC X(30) .
          05 L-ADDRESS     PIC X(100) .
          05 L-CITY        PIC X(20) .
          05 L-ZIP         PIC X(5) .
          05 L-STATE       PIC X(2) .
          05 L-LNAME       PIC X(20).
          05 L-FNAME       PIC X(20).
          05 L-COM         PIC X(4).
          05 L-DNAME       PIC X(20).
          05 FILLER        PIC X(28).
       
       PROCEDURE DIVISION.
      *** PARTIE 1 ALIMENTATION DU FICHIER EXTRACT.DATA ***
            PERFORM OPEN-FEXT
            PERFORM OPEN-CURS
            PERFORM FETCH-CURS
            PERFORM TEST-SQLCODE
            PERFORM UNTIL SQLCODE NOT EQUAL ZERO
               PERFORM WRITE-FEXT
               PERFORM FETCH-CURS
               PERFORM TEST-SQLCODE
            END-PERFORM
            PERFORM CLOSE-CURS
            PERFORM CLOSE-FEXT
      *** PARTIE 2 ALIMENTATION DU FICHIER FACTURES.DATA ***
            GOBACK.
				
      ********************************************
      * PARAGRAPHES                              *
      ********************************************
       CLOSE-FEXT.
           CLOSE FEXT.
       OPEN-FEXT.
           OPEN OUTPUT FEXT.
       CLOSE-CURS.
           EXEC SQL CLOSE CURS END-EXEC.
       OPEN-CURS.
           EXEC SQL OPEN CURS END-EXEC.
       FETCH-CURS.
           EXEC SQL
               FETCH CURS
               INTO
               :ITE-P-NO,
               :ITE-QUANTITY,
               :ITE-PRICE,
               :PRO-DESCRIPTION,
               :ORD-O-NO,
               :ORD-O-DATE,
               :CUS-COMPANY,
               :CUS-ADDRESS,
               :CUS-CITY,
               :CUS-ZIP,
               :CUS-STATE,
               :EMP-LNAME,
               :EMP-FNAME,
               :EMP-COM,
               :DEP-DNAME
           END-EXEC.
       TEST-SQLCODE.
           EVALUATE TRUE
               WHEN SQLCODE = ZERO
                    CONTINUE
               WHEN SQLCODE > ZERO
                    DISPLAY 'WARNING : ' SQLCODE
               WHEN OTHER
                    DISPLAY 'ANOMALIE GRAVE : ' SQLCODE
                    PERFORM ABEND-PROG
           END-EVALUATE.
       ABEND-PROG.
           COMPUTE WS-ANO = WS-ANO / WS-VAR.
       WRITE-FEXT.
      *** TRAITEMENT COMPATIBILITE DONNEES ***
           MOVE ITE-QUANTITY      TO WR-ITE-QUANTITY
           MOVE ITE-PRICE         TO ED-ITE-PRICE
           MOVE EMP-COM           TO ED-EMP-COM
           MOVE ED-ITE-PRICE(1:3) TO WR-ITE-PRICE(1:3)
           MOVE ','               TO WR-ITE-PRICE(4:1)
           MOVE ED-ITE-PRICE(4:2) TO WR-ITE-PRICE(5:2)
           MOVE ED-EMP-COM(1:1)   TO WR-EMP-COM(1:1)
           MOVE ','               TO WR-EMP-COM(2:1)
           MOVE ED-EMP-COM(2:2)   TO WR-EMP-COM(3:2)
           MOVE ORD-O-NO          TO WR-ORD-O-NO
      *** ALIM LIGNE AVEC VARIABLES DU FETCH ***
           MOVE ITE-P-NO                TO L-P-NO
           MOVE WR-ITE-QUANTITY         TO L-QUANTITY
           MOVE WR-ITE-PRICE            TO L-PRICE
           MOVE PRO-DESCRIPTION-TEXT(1:PRO-DESCRIPTION-LEN)
                                        TO L-DESCRIPTION
           MOVE WR-ORD-O-NO             TO L-O-NO
           MOVE ORD-O-DATE              TO L-O-DATE
           MOVE CUS-COMPANY-TEXT(1:CUS-COMPANY-LEN)     TO L-COMPANY
           MOVE CUS-ADDRESS-TEXT(1:CUS-ADDRESS-LEN)     TO L-ADDRESS
           MOVE CUS-CITY-TEXT(1:CUS-CITY-LEN)           TO L-CITY
           MOVE CUS-ZIP                 TO L-ZIP
           MOVE CUS-STATE               TO L-STATE
           MOVE EMP-LNAME-TEXT(1:EMP-LNAME-LEN)         TO L-LNAME
           MOVE EMP-FNAME-TEXT(1:EMP-FNAME-LEN)         TO L-FNAME
           MOVE WR-EMP-COM              TO L-COM
           MOVE DEP-DNAME-TEXT(1:DEP-DNAME-LEN)         TO L-DNAME
           WRITE ENR-FEXT FROM LIGNE BEFORE ADVANCING 1 LINES
           PERFORM CLEAN-L
           .
			  
       CLEAN-L.
           MOVE SPACES TO L-P-NO
           MOVE SPACES TO L-QUANTITY
           MOVE SPACES TO L-PRICE
           MOVE SPACES TO L-DESCRIPTION
           MOVE SPACES TO L-O-NO
           MOVE SPACES TO L-O-DATE
           MOVE SPACES TO L-COMPANY
           MOVE SPACES TO L-ADDRESS
           MOVE SPACES TO L-CITY
           MOVE SPACES TO L-ZIP
           MOVE SPACES TO L-STATE
           MOVE SPACES TO L-LNAME
           MOVE SPACES TO L-FNAME
           MOVE SPACES TO L-COM
           MOVE SPACES TO L-DNAME
           .
