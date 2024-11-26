       IDENTIFICATION DIVISION.
       PROGRAM-ID.     PART3BP.
       AUTHOR.         MATHIEU.

      ******************************************************************
      * THIS PROGRAM IS INTENDED TO :                                  *
      *    - READ EXTRACT.DATA                                         *
      *    - FILLS FACTURES.DATA WITH BILLS OF EACH ORDER              *
      ******************************************************************

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FEXT ASSIGN TO FICEXT.
           SELECT FACT ASSIGN TO FICFACT.

       DATA DIVISION.
       FILE SECTION.
      *** DECLARATION ENREGISTREMENTS FICHIER ***
       FD FEXT.
       01 ENR-FEXT.
          05 FILLER        PIC X.
          05 F-P-NO        PIC X(3).
          05 F-QUANTITY    PIC X(2).
          05 F-PRICE       PIC X(6).
          05 F-DESCRIPTION PIC X(30).
          05 F-O-NO        PIC X(3).
          05 F-O-DATE      PIC X(10).
          05 F-COMPANY     PIC X(30).
          05 F-ADDRESS     PIC X(100).
          05 F-CITY        PIC X(20).
          05 F-ZIP         PIC X(5).
          05 F-STATE       PIC X(2).
          05 F-LNAME       PIC X(20).
          05 F-FNAME       PIC X(20).
          05 F-COM         PIC X(4).
          05 F-DNAME       PIC X(20).
          05 FILLER        PIC X(24).
       
       FD FACT.
       01 ENR-FACT.
          05 FILLER        PIC X.
          05 FILLER        PIC X(79).

       WORKING-STORAGE SECTION.
      
      ***  VARIABLES FONCTION ABEND-PROG ***
       77 WS-ANO PIC 9 VALUE ZERO.
       77 WS-VAR PIC 9 VALUE ZERO.
      *** VARIABLES FLAG FICHIER ***
       77 WS-FLAG PIC 9 VALUE ZERO.
          88 FF-FEXT VALUE 1.
      *** VARIABLES ORDER ITEM ***
       77 WS-TOTAL       PIC 9(4)V9(2).
       77 WS-QTY         PIC 9(2).
       77 WS-PRICE       PIC 9(3)V9(2).
       77 TP-PRICE       PIC 9(3)V9(2).
       77 WS-COM         PIC 9(2)V9(2).
       77 TP-COM         PIC 9(2)V9(2).
       77 WS-TP-COM      PIC 9(2)V9(2).
       77 WS-COM-LIGNE   PIC 9(2)V9(2).
      *** VARIABLES TOTAUX ORDER ***
       77 WS-TOTAL-HT    PIC 9(4)V9(2).
       77 WS-TOTAL-TTC   PIC 9(4)V9(2).
       77 WS-TOTAL-COM   PIC 9(4)V9(2).
       77 WS-TOTAL-TAX   PIC 9(4)V9(2).
       77 AC-TAX         PIC X(5).
       77 WS-TAX         PIC 9(2)V9(2).
       77 TP-TAX         PIC 9(2)V9(2).
       77 WS-TP-TAX      PIC 9(2)V9(2).
      *** VARIABLES EDITION ***
       77 ED-MONTANT       PIC ZZ9,9(2).
       77 ED-TOTAL         PIC ZZZ9,9(2).
       77 ED-QTY           PIC 99.
       77 ED-COM           PIC Z9,99.
       77 ED-TAX           PIC Z9,99.
       77 ED-CONTACT       PIC X(70).
      *** VARIABLES CURRENT ***
       77 WS-CUR-O-NO      PIC X(3).
       77 WS-CUR-COM       PIC X(4).
      *** VARIABLES SOUS PROGRAMMES ***
       77 LS-DATE          PIC X(30).
       77 LS-ST-CODE       PIC X(2).
       77 LS-ST-NAME       PIC X(30).
       
       01 L-TIRET.
          05 FILLER  PIC X(80) VALUE ALL '-'.
       
       01 L-TIRET-CUS.
          05 FILLER  PIC X(3)  VALUE     '|  '.
          05 FILLER  PIC X(40) VALUE ALL ' '.
          05 FILLER  PIC X(34) VALUE ALL '-'.
          05 FILLER  PIC X(3)  VALUE     '  |'.
       
       01 L-TIRET-ITE.
          05 FILLER  PIC X(3)  VALUE     '|  '.
          05 FILLER  PIC X(74) VALUE ALL '-'.
          05 FILLER  PIC X(3)  VALUE     '  |'.
       
       01 L-VIDE.
          05 FILLER  PIC X(3)  VALUE     '|  '.
          05 FILLER  PIC X(74) VALUE ALL ' '.
          05 FILLER  PIC X(3)  VALUE     '  |'.
       
       01 L-TOTAL.
          05 FILLER      PIC X(3)  VALUE     '|  '.
          05 FILLER      PIC X(40) VALUE ALL ' '.
          05 L-TOT-TITLE PIC X(27).
          05 L-TOT-DATA  PIC ZZZZ,99.
          05 FILLER      PIC X(3)  VALUE     '  |'.
       
       01 L-TITLE-ITE.
          05 FILLER  PIC X(4)  VALUE '|  |'.
          05 FILLER  PIC X(8)  VALUE 'P_NO   |'.
          05 FILLER  PIC X(12) VALUE 'DESCRIPTION'.
          05 FILLER  PIC X(17) VALUE ALL ' '.
          05 FILLER  PIC X     VALUE '|'.
          05 FILLER  PIC X(10) VALUE 'QUANTITY |'.
          05 FILLER  PIC X(8)  VALUE 'PRICE  |'.
          05 FILLER  PIC X(16) VALUE 'TOTAL LIGNE     '.
          05 FILLER  PIC X(4)  VALUE              '|  |'.
      
       01 L-ITE.
          05 FILLER    PIC X(4)  VALUE     '|  |'.
          05 L-ITE-NO  PIC X(7).
          05 FILLER    PIC X     VALUE     '|'.
          05 L-ITE-DES PIC X(29).
          05 FILLER    PIC X     VALUE     '|'.
          05 FILLER    PIC X(7)  VALUE ALL ' '.
          05 L-ITE-QTY PIC X(2).
          05 FILLER    PIC X     VALUE     '|'.
          05 FILLER    PIC X     VALUE ALL ' '.
          05 L-ITE-PRI PIC ZZZ,99.
          05 FILLER    PIC X     VALUE     '|'.
          05 FILLER    PIC X(9)  VALUE ALL ' '.
          05 L-ITE-TOT PIC ZZZZ,99.
          05 FILLER    PIC X(4)  VALUE     '|  |'.
       
       01 L-DATE.
          05 FILLER  PIC X(3)  VALUE     '|  '.
          05 FILLER  PIC X(3)  VALUE     '   '.
          05 L-DATE-TITLE PIC X(10).
          05 L-DATE-DATA PIC X(30).
          05 FILLER  PIC X(31) VALUE ALL ' '.
          05 FILLER  PIC X(3)  VALUE     '  |'.
       
       01 L-ORD.
          05 FILLER  PIC X(3)  VALUE     '|  '.
          05 L-ORD-TITLE PIC X(12).
          05 L-ORD-DATA  PIC X(10).
          05 FILLER  PIC X(52) VALUE ALL ' '.
          05 FILLER  PIC X(3)  VALUE     '  |'.
       
       01 L-EMP-DEUX-LIGNES.
          05 FILLER  PIC X(3)  VALUE     '|  '.
          05 L-EMP-DATA-LNAME PIC X(20).
          05 FILLER  PIC X VALUE ALL ','.
          05 L-EMP-DATA-FNAME PIC X(20).
          05 FILLER  PIC X(33) VALUE ALL ' '.
          05 FILLER  PIC X(3)  VALUE     '  |'.
       
       01 L-EMP-UNE-LIGNE.
          05 FILLER  PIC X(3)  VALUE     '|  '.
          05 L-EMP-DATA PIC X(74).
          05 FILLER  PIC X(3)  VALUE     '  |'.
       
       01 L-DEP.
          05 FILLER  PIC X(3)  VALUE     '|  '.
          05 L-DEP-TITLE PIC X(30).
          05 L-DEP-DATA PIC X(20).
          05 FILLER  PIC X(3) VALUE ALL ' : '.
          05 FILLER  PIC X(21) VALUE ALL ' '.
          05 FILLER  PIC X(3)  VALUE     '  |'.
       
       01 L-CUS.
          05 FILLER       PIC X(3)  VALUE     '|  '.
          05 FILLER       PIC X(40) VALUE ALL ' '.
          05 FILLER       PIC X(2) VALUE '| '.
          05 FILLER       PIC X(2) VALUE '  '.
          05 L-CUS-DATA   PIC X(28).
          05 FILLER       PIC X(2) VALUE ' |'.
          05 FILLER       PIC X(3)  VALUE     '  |'.
       
       PROCEDURE DIVISION.
       
      *** RECUPERATION DU TAUX DE TAXE DANS LA SYSIN ***
           ACCEPT AC-TAX FROM SYSIN
       
      *** OUVERTURE DES FICHIERS ***
           PERFORM OPEN-FEXT
           PERFORM READ-FEXT
           PERFORM OPEN-FACT
       
           PERFORM INIT-ORDER
           PERFORM WRITE-FACT-TOP
           PERFORM WRITE-FACT-ITE-TOP
       
           PERFORM UNTIL FF-FEXT
       
           PERFORM WRITE-FACT-ITE UNTIL FF-FEXT OR
                      F-O-NO NOT EQUAL WS-CUR-O-NO
       
           PERFORM WRITE-FACT-ITE-BOTTOM
           PERFORM WRITE-FACT-BOTTOM
           PERFORM INIT-ORDER
           IF NOT FF-FEXT
              PERFORM WRITE-FACT-TOP
              PERFORM WRITE-FACT-ITE-TOP
           END-IF
               END-PERFORM
               PERFORM CLOSE-FEXT
               PERFORM CLOSE-FACT
               GOBACK.
      ******************************************
      * PARAGRAPHES
      ******************************************
       CLOSE-FEXT.
           CLOSE FEXT.
       OPEN-FEXT.
           OPEN INPUT FEXT.
       CLOSE-FACT.
           CLOSE FACT.
       OPEN-FACT.
           OPEN OUTPUT FACT.
       READ-FEXT.
           READ FEXT AT END
        SET FF-FEXT TO TRUE
        DISPLAY 'FICHIER EXTRACT VIDE OU FINI'
           END-READ.
       ABEND-PROG.
           COMPUTE WS-ANO = WS-ANO / WS-VAR.
      ******************************************
      * PARAGRAPHES DIVERS WRITE
      ******************************************
       WRITE-FACT-ITE-TOP.
           DISPLAY L-TIRET-ITE
           DISPLAY L-TITLE-ITE
           DISPLAY L-TIRET-ITE
           WRITE ENR-FACT FROM L-TIRET-ITE
           WRITE ENR-FACT FROM L-TITLE-ITE
           WRITE ENR-FACT FROM L-TIRET-ITE
           .
       WRITE-FACT-ITE-BOTTOM.
           DISPLAY L-TIRET-ITE
           WRITE ENR-FACT FROM L-TIRET-ITE
           .
       WRITE-FACT-ITE.
      *** CALCULS ET CONVERSION DE TYPE ***
           MOVE F-QUANTITY     TO WS-QTY
           COMPUTE TP-PRICE = FUNCTION NUMVAL(F-PRICE)
           MOVE    TP-PRICE   TO WS-PRICE
           COMPUTE TP-COM   = FUNCTION NUMVAL(F-COM)
           MOVE    TP-COM     TO WS-COM
           COMPUTE WS-TOTAL = WS-QTY * WS-PRICE
           COMPUTE WS-COM-LIGNE = WS-TOTAL * WS-COM
           MOVE WS-TOTAL       TO ED-TOTAL
           MOVE WS-PRICE       TO ED-MONTANT
           MOVE WS-QTY         TO ED-QTY
           MOVE WS-COM         TO ED-COM
      *** TRAITEMENT TOTAUX ***
           ADD WS-TOTAL TO WS-TOTAL-HT
           ADD WS-COM-LIGNE TO WS-TOTAL-COM
      *** MOVE DANS LIGNE ***
           MOVE F-P-NO         TO L-ITE-NO
           MOVE SPACES TO L-ITE-DES
           MOVE F-DESCRIPTION  TO L-ITE-DES
           MOVE SPACES TO F-DESCRIPTION
           MOVE ED-QTY         TO L-ITE-QTY
           MOVE ED-MONTANT     TO L-ITE-PRI
           MOVE ED-TOTAL       TO L-ITE-TOT
           DISPLAY L-ITE
           WRITE ENR-FACT FROM L-ITE
           PERFORM CLEAN-L-ITE
           PERFORM INIT-ITEM
           PERFORM READ-FEXT
           .
       WRITE-FACT-CUS.
      *** COMPANY NAME ***
           WRITE ENR-FACT FROM L-TIRET-CUS
           MOVE F-COMPANY   TO L-CUS-DATA
           DISPLAY L-CUS
           WRITE ENR-FACT FROM L-CUS
      *** COMPANY ADDRESS ***
           MOVE F-ADDRESS   TO L-CUS-DATA
           DISPLAY L-CUS
           WRITE ENR-FACT FROM L-CUS
      *** COMPANY CITY ZIP ***
           STRING
              F-CITY DELIMITED BY '  '
              ', '   DELIMITED BY SIZE
              F-ZIP  DELIMITED BY SIZE
              INTO L-CUS-DATA
           END-STRING
           DISPLAY L-CUS
           WRITE ENR-FACT FROM L-CUS
      *** COMPANY STATE ***
           PERFORM CALL-SSP-STATE
           MOVE LS-ST-NAME  TO L-CUS-DATA
           DISPLAY L-CUS
           WRITE ENR-FACT FROM L-CUS
           DISPLAY L-TIRET-CUS
           WRITE ENR-FACT FROM L-TIRET-CUS
           MOVE SPACES TO F-STATE
           .
       CLEAN-L-EMP.
            MOVE SPACES TO L-DEP-DATA
            MOVE SPACES TO L-EMP-DATA-FNAME
            MOVE SPACES TO L-EMP-DATA-LNAME
            MOVE SPACES TO L-EMP-DATA
            .
       CLEAN-L-ITE.
            MOVE SPACES TO L-ITE-NO
            MOVE SPACES TO L-ITE-DES
            MOVE SPACES TO L-ITE-QTY
            MOVE 0 TO L-ITE-PRI
            MOVE 0 TO L-ITE-TOT
            .
       CLEAN-L-DAT.
            MOVE SPACES TO L-DATE-DATA
            .
       CLEAN-L-ORD.
            MOVE SPACES TO L-ORD-DATA
            .
       WRITE-FACT-DAT.
            MOVE 'PARIS, LE ' TO L-DATE-TITLE
      *** SOUS PROGRAMME DATE ***
            PERFORM CALL-SSP-DATE
            MOVE FUNCTION LOWER-CASE(LS-DATE) TO L-DATE-DATA
            DISPLAY L-DATE
            WRITE ENR-FACT FROM L-DATE
            PERFORM CLEAN-L-DAT
            .
       WRITE-FACT-ORD.
            MOVE 'ORDER NUM  :' TO L-ORD-TITLE
            MOVE F-O-NO TO L-ORD-DATA
            DISPLAY L-ORD
            WRITE ENR-FACT FROM L-ORD
            MOVE 'ORDER DATE :' TO L-ORD-TITLE
            MOVE F-O-DATE TO L-ORD-DATA
            DISPLAY L-ORD
            WRITE ENR-FACT FROM L-ORD
            PERFORM CLEAN-L-ORD
            .
       WRITE-FACT-EMP.
      *** CONSTRUCTION PHRASE CONTACT ***
            STRING
                'V' DELIMITED BY SIZE
                 'otre contact au département ' DELIMITED BY SIZE
                 F-DNAME  DELIMITED BY ' '
                ' : '    DELIMITED BY SIZE
                 F-LNAME  DELIMITED BY ' '
                 ', '     DELIMITED BY SIZE
                 F-FNAME  DELIMITED BY ' '
            INTO ED-CONTACT
            END-STRING
            DISPLAY '--' ED-CONTACT '--'
            MOVE ED-CONTACT TO L-EMP-DATA
            WRITE ENR-FACT FROM L-EMP-UNE-LIGNE
            PERFORM CLEAN-L-EMP
            .
       WRITE-FACT-BOTTOM.
           COMPUTE TP-TAX = FUNCTION NUMVAL(AC-TAX)
           MOVE    TP-TAX   TO WS-TAX
           COMPUTE WS-TP-TAX = WS-TAX + 1
           COMPUTE WS-TOTAL-TAX = WS-TOTAL-HT * WS-TAX
           COMPUTE WS-TOTAL-TTC = WS-TOTAL-HT * WS-TP-TAX
           MOVE 'TOTAL HT'           TO L-TOT-TITLE
           MOVE WS-TOTAL-HT          TO L-TOT-DATA
           WRITE ENR-FACT FROM L-VIDE
           WRITE ENR-FACT FROM L-TOTAL
           WRITE ENR-FACT FROM L-VIDE
      *** TRAITEMENT TOTAL-TAX ***
           COMPUTE WS-TAX = WS-TAX * 100
           MOVE WS-TAX TO ED-TAX
           STRING
                   'TOTAL TAXE (' DELIMITED BY SIZE
                   ED-TAX  DELIMITED BY SIZE
                   '%)' DELIMITED BY SIZE
                   INTO L-TOT-TITLE
           END-STRING
           MOVE WS-TOTAL-TAX TO L-TOT-DATA
           WRITE ENR-FACT FROM L-TOTAL
           WRITE ENR-FACT FROM L-VIDE
      *** TRAITEMENT TOTAL-COM ***
           COMPUTE TP-COM = FUNCTION NUMVAL(WS-CUR-COM)
           MOVE    TP-COM   TO WS-COM
           COMPUTE WS-TP-COM = WS-COM + 1
           COMPUTE WS-TOTAL-COM = WS-TOTAL-HT * WS-COM
           COMPUTE WS-COM = WS-COM * 100
           MOVE WS-COM TO ED-COM
           STRING
                   'COMMISSION (' DELIMITED BY SIZE
                   ED-COM  DELIMITED BY SIZE
                   '%)' DELIMITED BY SIZE
                   INTO L-TOT-TITLE
           END-STRING
           MOVE WS-TOTAL-COM         TO L-TOT-DATA
           WRITE ENR-FACT FROM L-TOTAL
           WRITE ENR-FACT FROM L-VIDE
           MOVE 'TOTAL TTC'          TO L-TOT-TITLE
           MOVE WS-TOTAL-TTC         TO L-TOT-DATA
           WRITE ENR-FACT FROM L-TOTAL
           WRITE ENR-FACT FROM L-VIDE
           WRITE ENR-FACT FROM L-TIRET BEFORE ADVANCING PAGE
           .
       WRITE-FACT-TOP.
           WRITE   ENR-FACT FROM L-TIRET
           WRITE   ENR-FACT FROM L-VIDE
           PERFORM WRITE-FACT-CUS
           PERFORM WRITE-FACT-DAT
           WRITE   ENR-FACT FROM L-VIDE
           PERFORM WRITE-FACT-ORD
           PERFORM WRITE-FACT-EMP
           WRITE   ENR-FACT FROM L-VIDE
           WRITE   ENR-FACT FROM L-VIDE
           .
       INIT-ORDER.
           MOVE F-O-NO TO WS-CUR-O-NO
           MOVE F-COM  TO WS-CUR-COM
           MOVE ZERO TO WS-TOTAL-HT
           MOVE ZERO TO WS-TOTAL-TTC
           MOVE ZERO TO WS-TOTAL-COM
           MOVE ZERO TO WS-TOTAL
           MOVE ZERO TO WS-COM-LIGNE
           MOVE ZERO TO WS-QTY
           MOVE ZERO TO WS-PRICE
           MOVE ZERO TO TP-PRICE
           MOVE ZERO TO WS-COM
           MOVE ZERO TO TP-COM
           .
       INIT-ITEM.
           MOVE F-O-NO TO WS-CUR-O-NO
           MOVE ZERO TO WS-TOTAL
           MOVE ZERO TO WS-COM-LIGNE
           MOVE ZERO TO WS-QTY
           MOVE ZERO TO WS-PRICE
           MOVE ZERO TO TP-PRICE
           MOVE ZERO TO WS-COM
           MOVE ZERO TO TP-COM
           .
       CLEAN-F.
           MOVE SPACES TO F-P-NO
           MOVE SPACES TO F-QUANTITY
           MOVE SPACES TO F-PRICE
           MOVE SPACES TO F-DESCRIPTION
           MOVE SPACES TO F-O-NO
           MOVE SPACES TO F-O-DATE
           MOVE SPACES TO F-COMPANY
           MOVE SPACES TO F-ADDRESS
           MOVE SPACES TO F-CITY
           MOVE SPACES TO F-ZIP
           MOVE SPACES TO F-STATE
           MOVE SPACES TO F-LNAME
           MOVE SPACES TO F-FNAME
           MOVE SPACES TO F-DNAME
           .
       CALL-SSP-DATE.
           CALL 'DATEPROG' USING LS-DATE
           .
       CALL-SSP-STATE.
           MOVE F-STATE TO LS-ST-CODE
           CALL 'STPROG' USING LS-ST-CODE LS-ST-NAME
           .
