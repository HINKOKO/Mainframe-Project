       IDENTIFICATION DIVISION.                                         
       PROGRAM-ID. MSGASSER.                                            
                                                                        
       DATA DIVISION.                                                   
       WORKING-STORAGE SECTION.                                         
       LINKAGE SECTION.                                                 
       COPY TESTCONT.                                                   
                                                                        
       01 TEST-NAME PIC X(30).                                          
       01 EXPECTED PIC  X(13).                                          
       01 ACTUAL   PIC  X(13).                                          
                                                                        
       PROCEDURE DIVISION USING TEST-CONTEXT, TEST-NAME,                
                                EXPECTED, ACTUAL.                       
                                                                        
            ADD 1 TO TESTS-RUN                                          
            IF ACTUAL EQUAL TO EXPECTED THEN                            
                     DISPLAY 'SUCCESS : ' TEST-NAME                     
                     DISPLAY 'EXPECTED '  EXPECTED                      
                     DISPLAY 'ACTUAL : '  ACTUAL                        
                     ADD 1 TO PASSES                                    
            ELSE                                                        
                     DISPLAY 'FAILED : ' TEST-NAME                      
                     DISPLAY 'EXPECTED ' EXPECTED                       
                     DISPLAY 'ACTUAL : ' ACTUAL                         
                                                                        
                     ADD 1 TO FAILURES                                  
            END-IF                                                      
                                                                        
            GOBACK.                                                     
       