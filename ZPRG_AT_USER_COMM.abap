*&---------------------------------------------------------------------*
*& Report  ZPRG_AT_USER_COMM
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zprg_at_user_comm.

TYPES : BEGIN OF lty_data,
        ono TYPE zonum_1,
        odate TYPE zodate_1,
        pm TYPE zpmode_1,
        curr TYPE zcurre_1,
        END OF lty_data.

DATA :lv_data TYPE TABLE OF lty_data.
DATA : lwa_data TYPE lty_data.
DATA : lv_ono TYPE zonum_1.

SELECT-OPTIONS : s_ono FOR lv_ono.

START-OF-SELECTION.
  SELECT ono odate paymd curr
    FROM zodh_1
    INTO TABLE lv_data
    WHERE ono IN s_ono.

  LOOP AT lv_data INTO lwa_data.
    WRITE : / lwa_data-ono , lwa_data-odate , lwa_data-pm , lwa_data-curr.
  ENDLOOP.

  SET PF-STATUS 'FUNCTION'.

AT USER-COMMAND.
  IF sy-ucomm = 'ASCENDING'.
    SORT lv_data BY ono.
    LOOP AT lv_data INTO lwa_data.
      WRITE : / lwa_data-ono , lwa_data-odate , lwa_data-pm , lwa_data-curr.
    ENDLOOP.
  ENDIF.

  IF sy-ucomm = 'DESCENDING'.
    SORT lv_data BY ono DESCENDING.
    LOOP AT lv_data INTO lwa_data.
      WRITE : / lwa_data-ono , lwa_data-odate , lwa_data-pm , lwa_data-curr.
    ENDLOOP.
  ENDIF.