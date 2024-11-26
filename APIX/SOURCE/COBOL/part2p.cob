       IDENTIFICATION DIVISION.
       PROGRAM-ID.      PART2P.
       AUTHOR.         HINKOKO.
      **********************************************************
      *     THIS PROGRAM IS INTENDED TO :                      *
      *      - INSERT NEW SALES IN DB2                         *
      *       - PERFORM A SYNCHRONIZED READ ON ASIA AND        *
      *       - EUROPEAN SALES                                 *
      **********************************************************
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
              SELECT VENTEU ASSIGN TO FVENTEU.
              SELECT VENTAS ASSIGN TO FVENTAS.
      ******************************************
       DATA DIVISION.
       FILE SECTION.
       FD VENTAS.
       COPY VTAS.
       
       FD VENTEU.
       COPY VTEU.
       
       WORKING-STORAGE SECTION.
       COPY VTSTRUCT.
       
      *** VARS CLASSIQUES ***
       77 WS-VENTEU       PIC 9     VALUE 0.
            88 FF-VENTEU            VALUE 1.
       77 WS-VENTAS       PIC 9     VALUE 0.
            88 FF-VENTAS            VALUE 1.
       77 WS-ANO          PIC 9.
       77 WS-VAR          PIC 9     VALUE 0.
       01 ED-SQLCODE      PIC +Z(8)9.
       77 WS-MSG          PIC X(20) VALUE 'DEFAULT MSG'.
       
       77 EU-CMD-CURR     PIC 9(3).
       77 AS-CMD-CURR     PIC 9(3).
       77 CUST-COMM       PIC 9(8)V9(2).
       77 CUST-COMM-TOTAL PIC 9(8)V9(2).
       77 CUST-COMM-UP    PIC S9(8)V9(2) USAGE COMP-3.
       77 WS-PRICE        PIC S9(3)V9(2).
       77 SEP             PIC X(20)      VALUE ALL SPACES.
      ***  SS PROG  ***
       77 WS-DATEPROG     PIC X(8) VALUE 'CONVDATE'.
       77 WS-FORMAT       PIC X(2) VALUE 'US'.
      *****************       DB2      ***************
           EXEC SQL INCLUDE SQLCA    END-EXEC
           EXEC SQL INCLUDE ORD      END-EXEC
           EXEC SQL INCLUDE ITE      END-EXEC
           EXEC SQL INCLUDE PRO      END-EXEC
           EXEC SQL INCLUDE CUS      END-EXEC
      ***********************************************
       PROCEDURE DIVISION.
           OPEN INPUT VENTEU VENTAS
           PERFORM LECT-VENTEU
           PERFORM LECT-VENTAS
           DISPLAY 'CMD EUROPE N  ' EU-O-NO
           DISPLAY 'CMD ASIA   N  ' AS-O-NO
       
           PERFORM UNTIL FF-VENTEU AND FF-VENTAS
              PERFORM EVAL-SALES-FILES
           END-PERFORM
       
           CLOSE VENTEU VENTAS
       
           GOBACK.
       
      *** PARAGRAPHS ***
       LECT-VENTEU.
           READ VENTEU AT END
              SET  FF-VENTEU TO TRUE
              MOVE 999      TO EU-O-NO
              DISPLAY 'FIN FICHIER VENTE EUROPE'
           END-READ.
       
       LECT-VENTAS.
           READ VENTAS AT END
              SET  FF-VENTAS TO TRUE
              MOVE 999       TO AS-O-NO
              DISPLAY 'FIN FICHIER VENTE ASIE'
           END-READ.
       
       EVAL-SALES-FILES.
           EVALUATE TRUE
                WHEN EU-O-NO < AS-O-NO
                    MOVE ENR-VENTES-EU TO ENR-VENTE-ST
                    PERFORM UPDATE-ORDER
                    PERFORM TRAIT-EU
                WHEN EU-O-NO > AS-O-NO
                    MOVE ENR-VENTES-AS TO ENR-VENTE-ST
                    PERFORM UPDATE-ORDER
                    PERFORM TRAIT-AS
                WHEN OTHER
                    MOVE ENR-VENTES-EU TO ENR-VENTE-ST
                    PERFORM UPDATE-ORDER
                    PERFORM TRAIT-EU
                    PERFORM TRAIT-AS
                END-EVALUATE.
       
       FETCH-PRICE.
           MOVE ENR-P-NO TO PRO-P-NO
           EXEC SQL
              SELECT PRICE
              INTO :PRO-PRICE
              FROM APIX.PRODUCTS
              WHERE P_NO = :PRO-P-NO
           END-EXEC
           MOVE 'FETCH PRICE ' TO WS-MSG
           PERFORM TEST-SQLCODE
           .
       
       TRAIT-EU.
           DISPLAY 'EU-O-NO ' EU-O-NO
       
           INITIALIZE ENR-VENTE-ST
           INITIALIZE CUST-COMM-TOTAL
       
           MOVE EU-O-NO TO EU-CMD-CURR
       
           PERFORM UNTIL EU-CMD-CURR NOT = EU-O-NO OR FF-VENTEU
       
               MOVE ENR-VENTES-EU TO ENR-VENTE-ST
               PERFORM UPDATE-ITEMS
               PERFORM LECT-VENTEU
       
           END-PERFORM
           PERFORM UPDATE-CA-CUSTOMER
           .
       
       TRAIT-AS.
           DISPLAY 'AS-O-NO ' AS-O-NO
       
           INITIALIZE ENR-VENTE-ST
           INITIALIZE CUST-COMM-TOTAL
       
           MOVE AS-O-NO TO AS-CMD-CURR
       
           PERFORM UNTIL AS-CMD-CURR NOT = AS-O-NO OR FF-VENTAS
       
               MOVE ENR-VENTES-AS TO ENR-VENTE-ST
               PERFORM UPDATE-ITEMS
               PERFORM LECT-VENTAS
       
           END-PERFORM
           PERFORM UPDATE-CA-CUSTOMER
           .
       
       
       UPDATE-ORDER.
           CALL WS-DATEPROG USING ENR-O-DATE WS-FORMAT
       
           MOVE ENR-O-NO     TO ORD-O-NO
           MOVE ENR-E-NO     TO ORD-S-NO
           MOVE ENR-C-NO     TO ORD-C-NO
           MOVE ENR-O-DATE   TO ORD-O-DATE
       
           EXEC SQL
             INSERT INTO
                   APIX.ORDERS(O_NO, S_NO, C_NO, O_DATE)
             VALUES (:ORD-O-NO, :ORD-S-NO, :ORD-C-NO, :ORD-O-DATE)
           END-EXEC
           PERFORM TEST-SQLCODE
           .
       
       UPDATE-ITEMS.
           MOVE ENR-PRICE TO WS-PRICE
           IF WS-PRICE = 0 THEN
              PERFORM FETCH-PRICE
              MOVE PRO-PRICE TO ENR-PRICE
           END-IF
       
           MOVE ENR-O-NO       TO ITE-O-NO
           MOVE ENR-P-NO       TO ITE-P-NO
           MOVE ENR-QUANTITY   TO ITE-QUANTITY
           MOVE ENR-PRICE      TO ITE-PRICE
       
           EXEC SQL
              INSERT INTO
              APIX.ITEMS(O_NO, P_NO, QUANTITY, PRICE)
              VALUES (:ITE-O-NO, :ITE-P-NO, :ITE-QUANTITY, :ITE-PRICE)
           END-EXEC
           MOVE 'UPDATING ITEMS' TO WS-MSG
           PERFORM TEST-SQLCODE
           PERFORM CUMUL-CA-CUSTOMER
           .
       
       CUMUL-CA-CUSTOMER.
           COMPUTE CUST-COMM = ENR-PRICE * ENR-QUANTITY
           ADD CUST-COMM TO CUST-COMM-TOTAL
           .
       
       UPDATE-CA-CUSTOMER.
           MOVE CUST-COMM-TOTAL TO CUST-COMM-UP
           MOVE ORD-C-NO  TO CUS-C-NO
           EXEC SQL
             UPDATE APIX.CUSTOMERS
             SET BALANCE = BALANCE + :CUST-COMM-UP
             WHERE C_NO = :CUS-C-NO
           END-EXEC
           PERFORM TEST-SQLCODE
           .
       
       TEST-SQLCODE.
           EVALUATE TRUE
                WHEN SQLCODE = ZERO
                   CONTINUE
                WHEN SQLCODE = -803
                   DISPLAY
                     'ERREUR INSERT : DOUBLON SUR CODE '
                WHEN SQLCODE > ZERO
                   IF SQLCODE = +100
                     DISPLAY  'CODE XX INTROUVABLE POUR OPERATION '
                   END-IF
                   MOVE SQLCODE TO ED-SQLCODE
                   DISPLAY 'WARNING : ' ED-SQLCODE
                WHEN OTHER
                   DISPLAY 'MSG -> ' WS-MSG
                   MOVE SQLCODE TO ED-SQLCODE
                   DISPLAY 'ANOMALIE ' ED-SQLCODE
                   PERFORM ABEND-PROG
            END-EVALUATE.
       
       ABEND-PROG.
           EXEC SQL ROLLBACK END-EXEC
           DISPLAY 'ROLLING BACK TO PREV TABLE STATE'
           COMPUTE WS-ANO = 1 / WS-ANO.
