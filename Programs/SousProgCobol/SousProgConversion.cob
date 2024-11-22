       IDENTIFICATION   DIVISION.
       PROGRAM-ID.       CONVERT.
       DATE-WRITTEN.  11/16/2024.
       DATE-COMPILED. 11/16/2024.
      **********************************************************
      *    THIS PROGRAM IS INTENDED TO RECEIVE A PRICE FROM A  *
      *    A FOREIGN COUNTRY AND RETURNS BACK THE USD PRICE    *
      *       -> KSDS USED TO MAP THE EXCHANGE RATE IS         *
      *       -> WAS EDITED THE SAME DATE AS THIS PROGRAM      *
      *       -> HENCE IN NOVEMBER THE 16TH                    *
      **********************************************************
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
             SELECT FCK ASSIGN TO CHANGEK
             ORGANIZATION IS INDEXED
             ACCESS MODE IS RANDOM
             RECORD KEY IS CHG-CODE
             FILE STATUS IS FS-FCK.
      ******************************************
       DATA DIVISION.
       FILE SECTION.
       FD FCK.
       01 ST-FCK.
          05 CHG-CODE      PIC X(2).
          05 CHG-RATE      PIC 9(2)V9(3).
          05 FILLER        PIC X(73).
       
       WORKING-STORAGE SECTION.
       77 FS-FCK           PIC 99.
       77 WS-ANO           PIC 9.
       77 WS-VAR           PIC 9 VALUE 0.
       
       LINKAGE SECTION.
       01 LK-DEV-CODE      PIC X(2).
       01 LK-PRICE         PIC 9(3)V99.
       01 ERROR-MSG        PIC X(20).
       
       PROCEDURE DIVISION USING LK-DEV-CODE LK-PRICE ERROR-MSG.
       
          OPEN INPUT FCK
          PERFORM CHECK-FILE-STATUS
      *** RECHERCHE PAR CLE AVEC LK-DEV-CODE RECU DU PRINCIPAL
          MOVE LK-DEV-CODE TO CHG-CODE
          READ FCK
          EVALUATE FS-FCK
             WHEN ZERO
                COMPUTE LK-PRICE = LK-PRICE * CHG-RATE
             WHEN 23
                COMPUTE LK-PRICE = 0
                MOVE 'MONEY CODE NOT FOUND' TO ERROR-MSG
             WHEN OTHER
                DISPLAY 'ERROR: FILE STATUS -> ' FS-FCK
                PERFORM ABEND-PROG
          END-EVALUATE
       
          CLOSE FCK
          PERFORM CHECK-FILE-STATUS
          GOBACK.
       
      *** PARAGRAPHS
       CHECK-FILE-STATUS.
          IF FS-FCK NOT = 0 THEN
             DISPLAY 'ERROR: FILE STATUS: ' FS-FCK
             PERFORM ABEND-PROG
          END-IF.
       
       ABEND-PROG.
          COMPUTE WS-ANO = WS-ANO / WS-VAR.
       