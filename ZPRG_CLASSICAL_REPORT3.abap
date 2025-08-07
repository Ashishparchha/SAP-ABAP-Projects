
*&---------------------------------------------------------------------*
*& Report  ZPRG_CLASSICAL_REPORT3
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zprg_classical_report3.

TYPES : BEGIN OF lty_table,
        ono TYPE zonum_1,
        odate TYPE zodate_1,
        paymd TYPE zpmode_1,
        curr TYPE zcurre_1,
        oitnum TYPE zordin_1,
        icost TYPE zitst_1,
        END OF lty_table.

DATA : lv_table TYPE TABLE OF lty_table.
DATA : lwa_table TYPE lty_table.
DATA : lv_sel TYPE zonum_1.
DATA : lv_flag TYPE c.

SELECT-OPTIONS : s_ono FOR lv_sel.

SELECT a~ono a~odate a~paymd a~curr b~oitnum b~icost
FROM zodh_1 AS a LEFT JOIN zitem_1 AS b
ON a~ono = b~ono
INTO TABLE lv_table
WHERE a~ono IN s_ono.

IF sy-subrc <> 0 .
MESSAGE I001(ZMSG_PRG) WITH s_ono.
lv_flag = 'X'.
ENDIF.

IF lv_flag = ' ' .
WRITE : sy-uline(81).
WRITE : / sy-vline, Text-000 , 15 sy-vline, Text-001 ,
          34 sy-vline , Text-002 , 46 sy-vline , Text-003 ,
          60 sy-vline , Text-004 , 71 sy-vline , Text-005,
          81 sy-vline.
WRITE : / sy-uline(81).


LOOP AT lv_table INTO lwa_table.
  WRITE : / sy-vline , lwa_table-ono UNDER Text-000 , 15 sy-vline , lwa_table-oitnum UNDER Text-001 ,
            34 sy-vline , lwa_table-odate UNDER Text-002 , 46 sy-vline , lwa_table-paymd UNDER Text-003 ,
            60 sy-vline , lwa_table-icost UNDER Text-004 , 71 sy-vline , lwa_table-curr UNDER Text-005,
            81 sy-vline.
  WRITE : / sy-uline(81).

ENDLOOP.
ENDIF.