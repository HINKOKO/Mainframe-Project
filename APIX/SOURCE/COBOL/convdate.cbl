       IDENTIFICATION DIVISION.
       PROGRAM-ID. CONVDATE.
       AUTHOR.     HINKOKO.
    		 
      ***************************************************
      *   THIS PROGRAM IS INTENDED TO :                 *
      *      - ACCEPT A DATE EITHER FR | US             *
      *      - RETURNED THE DESIRED FORMAT  US | FR     *
      ***************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       01 WS-DATE-US.
          05 US-AA    PIC X(4).
          05 FILLER   PIC X(1)     VALUE  '/'.
          05 US-MM    PIC X(2).
          05 FILLER   PIC X(1)     VALUE  '/'.
          05 US-JJ    PIC X(2).
       
       01 WS-DATE-FR.
          05 FR-JJ    PIC X(2).
          05 FILLER   PIC X(1)     VALUE  '/'.
          05 FR-MM    PIC X(2).
          05 FILLER   PIC X(1)     VALUE  '/'.
          05 FR-AA    PIC X(4).
       
       01 ED-JJ      PIC Z9.
       01 TMP-DATE   PIC X(30).
       77 WS-ANO     PIC 9 VALUE 0.
       77 WS-DATE    PIC X(10).
      ********************
       LINKAGE SECTION.
       01 LS-DATE      PIC X(10).
       01 LS-FORMAT    PIC X(02).
      *******************
       PROCEDURE DIVISION USING LS-DATE, LS-FORMAT.
             EVALUATE TRUE
               WHEN LS-FORMAT = 'US'
                  PERFORM USA-DATE
               WHEN LS-FORMAT = 'FR'
                  PERFORM EUROPA-DATE
               WHEN OTHER
                  DISPLAY 'INVALID DATE FORMAT - U MARTIAN ? '
             END-EVALUATE
       
             GOBACK.
      *** PARAGRAPHS *****
       USA-DATE.
           UNSTRING LS-DATE DELIMITED BY '/'
              INTO US-JJ US-MM US-AA
           END-UNSTRING
       
           INITIALIZE LS-DATE
               STRING US-AA    DELIMITED BY SIZE
                   '-'         DELIMITED BY SIZE
                   US-MM       DELIMITED BY SIZE
                   '-'         DELIMITED BY SIZE
                   US-JJ       DELIMITED BY SIZE
               INTO LS-DATE
           .
       EUROPA-DATE.
           UNSTRING LS-DATE DELIMITED BY '/'
              INTO FR-JJ FR-MM FR-AA
           END-UNSTRING
       
           INITIALIZE LS-DATE
               STRING FR-JJ  DELIMITED BY SIZE
                   '-'       DELIMITED BY SIZE
                   FR-MM     DELIMITED BY SIZE
                   '-'       DELIMITED BY SIZE
                   FR-AA     DELIMITED BY SIZE
               INTO LS-DATE
           .
