       IDENTIFICATION DIVISION.
       PROGRAM-ID. DATEPROG.
       AUTHOR.     HINKOKO.
       
      *********************************************
      * PROGRAM INTENDED TO RETURN CURRENT DATE   *
      * FORMATTED AS  :                           *
      *   1 JANVIER 1601   (FOR COBOL PURISTS)    *
      *********************************************
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY DAYMONTH.
       
       01 WS-DATEJOUR.
          05 WS-AA PIC XX.
          05 WS-MM PIC XX.
          05 WS-JJ PIC XX.
       
       01 YEAR.
          05 FILLER PIC X(2) VALUE '20'.
          05 WS-YY  PIC X(2).
       
       01 ED-JJ      PIC Z9.
       01 WS-DATE      PIC X(30).
       
       LINKAGE SECTION.
       01 LS-DATE      PIC X(30).
       
       PROCEDURE DIVISION USING LS-DATE.
       
              ACCEPT WS-DATEJOUR FROM DATE
              MOVE WS-MM TO MONTH-NUM
       
              ACCEPT DAY-NUM     FROM DAY-OF-WEEK
       
              IF DAY-NUM >= 1 AND DAY-NUM <= 7
                 MOVE    NAME-OF-DAY(DAY-NUM) TO TMP-DAY
              ELSE
                 DISPLAY 'ERROR: INVALID DAY ' DAY-NUM
              END-IF
       
              IF MONTH-NUM >= 1 AND MONTH-NUM <= 12
                 MOVE    NAME-OF-MONTH(MONTH-NUM) TO TMP-MONTH
              ELSE
                 DISPLAY 'ERROR: INVALID MONTH ' MONTH-NUM
              END-IF
      *** BUILDING UP THE STRING
              MOVE WS-AA TO WS-YY
              MOVE WS-JJ TO ED-JJ
              STRING  TMP-DAY   DELIMITED BY SPACE
                      ' '       DELIMITED BY SIZE
                      ED-JJ     DELIMITED BY SIZE
                      ' '       DELIMITED BY SIZE
                      TMP-MONTH DELIMITED BY SPACE
                      ' '       DELIMITED BY SIZE
                      YEAR      DELIMITED BY SPACE
                 INTO WS-DATE
              END-STRING
              MOVE WS-DATE TO LS-DATE
              DISPLAY 'DATE : ' WS-DATE
       
              GOBACK.
       