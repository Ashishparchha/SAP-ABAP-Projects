*&---------------------------------------------------------------------*
*& Report  ZPRG_ALV_ORDER_DTL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zprg_alv_order_dtl.

TYPES : BEGIN OF lty_vbak,
        vbeln TYPE vbeln_va,
        erdat TYPE erdat,
        erzet TYPE erzet,
        ernam TYPE ernam,
        END OF lty_vbak.

DATA : lv_vbak TYPE TABLE OF lty_vbak.
DATA : lwa_vbak TYPE lty_vbak.
DATA : lv_vbeln TYPE vbeln_va.
DATA : lv_final TYPE TABLE OF zstr_avl_order.
DATA : lwa_final TYPE zstr_avl_order.
DATA : lt_fieldcat TYPE slis_t_fieldcat_alv.
DATA : lwa_fieldcat TYPE slis_fieldcat_alv.


TYPES : BEGIN OF lty_vbap,
        vbeln TYPE vbeln_va,
        posnr TYPE posnr_va,
        matnr TYPE matnr,
        END OF lty_vbap.

DATA : lv_vbap TYPE TABLE OF lty_vbap.
DATA : lwa_vbap TYPE lty_vbap.

SELECT-OPTIONS : s_vbeln FOR lv_vbeln.

SELECT vbeln erdat erzet ernam
  FROM vbak
  INTO TABLE lv_vbak
  WHERE vbeln in s_vbeln.

IF lv_vbak IS NOT INITIAL.
  SELECT vbeln posnr matnr
    FROM vbap
    INTO TABLE lv_vbap
    FOR ALL ENTRIES IN lv_vbak
    WHERE vbeln = lv_vbak-vbeln.
ENDIF.

LOOP AT lv_vbak INTO lwa_vbak.
  LOOP AT lv_vbap INTO lwa_vbap WHERE vbeln = lwa_vbak-vbeln.
    lwa_final-vbeln = lwa_vbak-vbeln.
    lwa_final-erdat = lwa_vbak-erdat.
    lwa_final-erzet = lwa_vbak-erzet.
    lwa_final-ernam = lwa_vbak-ernam.
    lwa_final-posnr = lwa_vbap-posnr.
    lwa_final-matnr = lwa_vbap-matnr.
    APPEND lwa_final TO lv_final.
    CLEAR : lwa_final.
  ENDLOOP.
ENDLOOP.

CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
  EXPORTING
*   I_PROGRAM_NAME         =
*   I_INTERNAL_TABNAME     =
    i_structure_name       = 'ZSTR_AVL_ORDER'
*   I_CLIENT_NEVER_DISPLAY = 'X'
*   I_INCLNAME             =
*   I_BYPASSING_BUFFER     =
*   I_BUFFER_ACTIVE        =
  CHANGING
    ct_fieldcat            = lt_fieldcat
  EXCEPTIONS
    inconsistent_interface = 1
    program_error          = 2
    OTHERS                 = 3.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

LOOP AT lt_fieldcat into lwa_fieldcat.
IF lwa_fieldcat-fieldname = 'VBELN'.
 lwa_fieldcat-seltext_l = 'Document Number'.
 MODIFY lt_fieldcat FROM lwa_fieldcat TRANSPORTING seltext_l.
ENDIF.
IF lwa_fieldcat-fieldname = 'ERDAT'.
 lwa_fieldcat-col_pos = '3'.
 MODIFY lt_fieldcat FROM lwa_fieldcat TRANSPORTING col_pos.
ENDIF.
IF lwa_fieldcat-fieldname = 'ERZET'.
 lwa_fieldcat-col_pos = '2'.
 MODIFY lt_fieldcat FROM lwa_fieldcat TRANSPORTING col_pos.
ENDIF.
ENDLOOP.



CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*     I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER                = ' '
*     I_BUFFER_ACTIVE                   = ' '
*     I_CALLBACK_PROGRAM                = ' '
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME                  = 'ZSTR_AVL_ORDER'
*     I_BACKGROUND_ID                   = ' '
*     I_GRID_TITLE                      =
*     I_GRID_SETTINGS                   =
*     IS_LAYOUT                         =
   it_fieldcat                       = lt_fieldcat
*     IT_EXCLUDING                      =
*     IT_SPECIAL_GROUPS                 =
*     IT_SORT                           = lt_sort
*     IT_FILTER                         =
*     IS_SEL_HIDE                       =
*     I_DEFAULT                         = 'X'
*     I_SAVE                            = ' '
*     IS_VARIANT                        =
*     IT_EVENTS                         =
*     IT_EVENT_EXIT                     =
*     IS_PRINT                          =
*     IS_REPREP_ID                      =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE                 = 0
*     I_HTML_HEIGHT_TOP                 = 0
*     I_HTML_HEIGHT_END                 = 0
*     IT_ALV_GRAPHICS                   =
*     IT_HYPERLINK                      =
*     IT_ADD_FIELDCAT                   =
*     IT_EXCEPT_QINFO                   =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = lv_final
* EXCEPTIONS
*   program_error                     = 1
*   OTHERS                            = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.