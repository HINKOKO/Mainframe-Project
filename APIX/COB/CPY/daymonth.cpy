000400 01 DAYS-LIST.
000500     05 DAY-01 PIC X(10) VALUE 'LUNDI   '.
000600     05 DAY-02 PIC X(10) VALUE 'MARDI   '.
000700     05 DAY-03 PIC X(10) VALUE 'MERCREDI'.
000800     05 DAY-04 PIC X(10) VALUE 'JEUDI   '.
000900     05 DAY-05 PIC X(10) VALUE 'VENDREDI'.
001000     05 DAY-06 PIC X(10) VALUE 'SAMEDI  '.
001100     05 DAY-07 PIC X(10) VALUE 'DIMANCHE'.
001200 01 DAYS-TABLE REDEFINES DAYS-LIST.
001300     05 NAME-OF-DAY  PIC X(10) OCCURS 7 TIMES.
001310
001400 01 MONTH-LIST.
001500     05 MONTH-01 PIC X(09) VALUE 'JANVIER'.
001600     05 MONTH-02 PIC X(09) VALUE 'FEVRIER'.
001700     05 MONTH-03 PIC X(09) VALUE 'MARS'.
001800     05 MONTH-04 PIC X(09) VALUE 'AVRIL'.
001900     05 MONTH-05 PIC X(09) VALUE 'MAI'.
002000     05 MONTH-06 PIC X(09) VALUE 'JUIN'.
002100     05 MONTH-07 PIC X(09) VALUE 'JUILLET'.
002200     05 MONTH-08 PIC X(09) VALUE 'AOUT'.
002300     05 MONTH-09 PIC X(09) VALUE 'SEPTEMBRE'.
002400     05 MONTH-10 PIC X(09) VALUE 'OCTOBRE'.
002500     05 MONTH-11 PIC X(09) VALUE 'NOVEMBRE'.
002600     05 MONTH-12 PIC X(09) VALUE 'DECEMBRE'.
002700 01 MONTH-TABLE REDEFINES MONTH-LIST.
002800     05 NAME-OF-MONTH  PIC X(09) OCCURS 12 TIMES.
002810
002900 01 DAY-NUM    PIC 9.
003000 01 TMP-DAY    PIC X(10).
003100
003200 01 MONTH-NUM  PIC 99.
003300 01 TMP-MONTH  PIC X(10).
