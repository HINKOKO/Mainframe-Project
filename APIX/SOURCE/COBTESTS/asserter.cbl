       IDENTIFICATION DIVISION.
       PROGRAM-ID. ASSERTER.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       COPY TESTCONT.
       
       01 TEST-NAME PIC X(30).
       01 EXPECTED PIC 9(3)V99.
       01 ACTUAL   PIC 9(3)V99.
                                                                             
       PROCEDURE DIVISION USING TEST-CONTEXT, TEST-NAME,                     
                                EXPECTED, ACTUAL.                            
                                                                             
           ADD 1 TO TESTS-RUN
           IF ACTUAL = EXPECTED THEN
                     DISPLAY 'SUCCESS : ' TEST-NAME
                     ADD 1 TO PASSES
           ELSE
                     DISPLAY 'FAILED : ' TEST-NAME
                     DISPLAY 'EXPECTED ' EXPECTED
                     DISPLAY 'ACTUAL : ' ACTUAL
       
                     ADD 1 TO FAILURES
           END-IF
                                                                             
           GOBACK.                                                           
       