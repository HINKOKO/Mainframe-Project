000100 IDENTIFICATION DIVISION.                                               00
000200 PROGRAM-ID. MSGASSER.                                                  00
000300                                                                        00
000400 DATA DIVISION.                                                         00
000500 WORKING-STORAGE SECTION.                                               00
000600 LINKAGE SECTION.                                                       00
000700 COPY TESTCONT.                                                         00
000800                                                                        00
000900 01 TEST-NAME PIC X(30).                                                00
001000 01 EXPECTED PIC  X(13).                                                00
001100 01 ACTUAL   PIC  X(13).                                                00
001200                                                                        00
001300 PROCEDURE DIVISION USING TEST-CONTEXT, TEST-NAME,                      00
001310                                 EXPECTED, ACTUAL.                      00
001320                                                                        00
001330     ADD 1 TO TESTS-RUN                                                 00
001340     IF ACTUAL EQUAL TO EXPECTED THEN                                   00
001350               DISPLAY 'SUCCESS : ' TEST-NAME                           00
001360               DISPLAY 'EXPECTED '  EXPECTED                            00
001370               DISPLAY 'ACTUAL : '  ACTUAL                              00
001380               ADD 1 TO PASSES                                          00
001390     ELSE                                                               00
001391               DISPLAY 'FAILED : ' TEST-NAME                            00
001400               DISPLAY 'EXPECTED ' EXPECTED                             00
001500               DISPLAY 'ACTUAL : ' ACTUAL                               00
001600                                                                        00
001700               ADD 1 TO FAILURES                                        00
001800     END-IF                                                             00
001900                                                                        00
002000     GOBACK.                                                            00
