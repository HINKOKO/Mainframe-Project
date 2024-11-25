       01 ST-OPEN-VT.
          05 OPEN-VT PIC X(08) VALUE '<VENTES>'.
          01 OPENING-PRODUCT.
          05 FILLER PIC X(05) VALUE SPACES.
          05 OPEN-PROD PIC X(17) VALUE '<PRODUCT NUMBER="'.
          05 PROD-NUMBER PIC X(03).
          05 END-V-PROD PIC X(02) VALUE '">'.
       
       01 ST-RANK.
          05 FILLER PIC X(10) VALUE SPACES.
          05 OPEN-RANK PIC X(06) VALUE '<RANK>'.
          05 RANK-NUMBER PIC 9(02).
          05 CLOSE-RANK PIC X(07) VALUE '</RANK>'.
       
       01 ST-VOLUME.
          05 FILLER PIC X(10) VALUE SPACES.
          05 OPEN-VOL PIC X(08) VALUE '<VOLUME>'.
          05 VOL-VALUE PIC 9(02).
          05 CLOSE-VOL PIC X(09) VALUE '</VOLUME>'.
       
       01 ST-CLOSE-PROD.
          05 FILLER PIC X(05) VALUE SPACES.
          05 CLOSE-PROD PIC X(10) VALUE '</PRODUCT>'.
       
       01 ST-CLOSE-VT.
          05 CLOSE-VT PIC X(09) VALUE '</VENTES>'.
