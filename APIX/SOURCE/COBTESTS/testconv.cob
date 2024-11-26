       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTCONV.
       AUTHOR.     HINKOKO.
      ***************************************************
      *  THIS PROGRAM IS INTENDED TO :                  *
      *     - TEST THE ROUTINE OF MONEY CONVERSION      *
      ***************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
               DECIMAL-POINT IS COMMA.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      ***   CHGBOOK IS A COPYBOOK CONTAINING ARRAY OF TEST            ***
      ***   FOR VARIOUS MONEY IN ALL DEVISE-CODE PRESENT IN KSDS FILE ***
       COPY CHGBOOK.
      ***  BAD-CODES - STRING USED TO TEST ERROR MESSAGE ***
      ***   RETURNED BY OUR ROUTINE PROGRAM CONVERT      ***
       77 BAD-CODES           PIC X(6)  VALUE 'KOLMUI'.

       01 LIB                 PIC X(20).
       01 L-SEP               PIC X(30) VALUE ALL '*'.
       01 RESULT              PIC 9(3)V9(2).
       01 EXPECTED            PIC 9(3)V9(2).
       01 EXPECTED-MSG        PIC X(20) VALUE 'MONEY CODE NOT FOUND'.

     *** FOR CALLING & HANDLING ROUTINE RESPONSE ***
       01 LK-DEV-CODE         PIC X(2).
       01 LK-PRICE            PIC 9(3)V99.
       01 LK-MSG              PIC X(20) VALUE SPACES.
       
       01 IDX                 PIC 99    VALUE 0.
       01 RATIO               PIC 9(2)V9(2).
       01 ED-RATIO            PIC Z9,99.
      ************************
        LINKAGE SECTION.
        COPY TESTCONT.
      ***********************************

       PROCEDURE DIVISION USING TEST-CONTEXT.
       
            PERFORM ALL-CURRENCIES
            PERFORM INVALID-CODES
       
            PERFORM SUMMARY
       
            GOBACK.
      * PARAGRAPHS *
      ***************************************************************
      *  ALL-CURRENCIES CALLS ALL VALID CODES FROM OUR KSDS FILES   *
      *  AND CHECK PROPER CONVERSION                                *
      ***************************************************************
       ALL-CURRENCIES.
       DISPLAY L-SEP
       DISPLAY '---- ALL CURRENCIES TEST -----'
       PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX > 9
          INITIALIZE RESULT
          MOVE 'TEST-'        TO LIB
          MOVE TLIB(IDX)      TO LIB(6:13)
          MOVE TCODE(IDX)     TO LK-DEV-CODE
          MOVE TAMOUNT(IDX)   TO LK-PRICE
          MOVE TEXPECT(IDX)   TO EXPECTED
       
          CALL 'CONVERT' USING  LK-DEV-CODE,
                                LK-PRICE,
                                LK-MSG
       
          CALL 'ASSERTER'
                USING TEST-CONTEXT, LIB, EXPECTED, LK-PRICE
       
          DISPLAY 'LIB :' LIB
          DISPLAY 'RUN ', TESTS-RUN, ',OK ', PASSES,
                                     ',KO ', FAILURES
          DISPLAY L-SEP
       
       END-PERFORM
       .

      ***************************************************************
      *  INVALID-CODES CALLS THE KSDS WITH INVALID DEVISE CODES     *
      *  AND CHECK EXPECTED ERROR MESSAGE WHEN DOING SO             *
      ***************************************************************
       INVALID-CODES.
           DISPLAY L-SEP
           DISPLAY '---- INVALID CODES TEST -----'
           INITIALIZE IDX LK-DEV-CODE LK-PRICE
           PERFORM VARYING IDX FROM 1 BY 2 UNTIL
                     IDX > LENGTH OF BAD-CODES
               MOVE 'TEST-INVALID-CODES' TO LIB
               MOVE 100,00            TO LK-PRICE
               MOVE BAD-CODES(IDX:2)  TO LK-DEV-CODE
       
               CALL 'CONVERT' USING LK-DEV-CODE,
                                    LK-PRICE,
                                    LK-MSG
       
               DISPLAY 'LOOKING FOR : ' LK-DEV-CODE
               CALL 'MSGASSER' USING TEST-CONTEXT, LIB,
                     EXPECTED-MSG, LK-MSG
               DISPLAY 'LIB :' LIB
               DISPLAY 'RUN ', TESTS-RUN, ',OK ', PASSES,
                             ',KO ', FAILURES
               DISPLAY L-SEP
       
           END-PERFORM
           .
       SUMMARY.
           DISPLAY L-SEP
           DISPLAY 'TOTAL SUCCESS - ' PASSES
           DISPLAY 'TOTAL FAILURES - ' FAILURES
           COMPUTE RATIO = PASSES / (FAILURES + PASSES)
           MOVE RATIO TO ED-RATIO
           DISPLAY ED-RATIO '% OF SUCCESS TEST COVERAGE'
           .
