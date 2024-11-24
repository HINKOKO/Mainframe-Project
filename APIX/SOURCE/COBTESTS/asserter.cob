000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. ASSERTER.
000300
000400 DATA DIVISION.
000500 WORKING-STORAGE SECTION.
000600 LINKAGE SECTION.
000700 COPY TESTCONT.
000800
000900 01 TEST-NAME PIC X(30).
001000 01 EXPECTED PIC 9(3)V99.
001100 01 ACTUAL   PIC 9(3)V99.
001200                                                                        00
001210 PROCEDURE DIVISION USING TEST-CONTEXT, TEST-NAME,                      00
001220                          EXPECTED, ACTUAL.                             00
001230                                                                        00
001240     ADD 1 TO TESTS-RUN
001250     IF ACTUAL = EXPECTED THEN
001260               DISPLAY 'SUCCESS : ' TEST-NAME
001270               ADD 1 TO PASSES
001280     ELSE
001290               DISPLAY 'FAILED : ' TEST-NAME
001291               DISPLAY 'EXPECTED ' EXPECTED
001292               DISPLAY 'ACTUAL : ' ACTUAL
001293
001294               ADD 1 TO FAILURES
001295     END-IF
001296                                                                        00
001297     GOBACK.                                                            00
