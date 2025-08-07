*&---------------------------------------------------------------------*
*& Report  ZPRG_ALV_ORDER_DTL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zprg_alv_order_dtl_3.

TYPES : BEGIN OF lty_vbak,
        vbeln TYPE vbeln_va,
        erdat TYPE erdat,
        erzet TYPE erzet,
        ernam TYPE ernam,
        END OF lty_vbak.

DATA : lv_vbak TYPE TABLE OF lty_vbak.
DATA : lwa_vbak TYPE lty_vbak.
DATA : lv_vbeln TYPE vbeln_va.
DATA : lt_fieldcat TYPE slis_t_fieldcat_alv.
DATA : lwa_fieldcat TYPE slis_fieldcat_alv.
DATA : lv_final TYPE TABLE OF zstr_avl_order.
DATA : lwa_final TYPE zstr_avl_order.



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

lwa_fieldcat-col_pos = '1'.
lwa_fieldcat-fieldname = 'VBELN'.
lwa_fieldcat-tabname = 'LV_FINAL'.
lwa_fieldcat-seltext_l = 'Sales Document Number'.
APPEND lwa_fieldcat to lt_fieldcat.
CLEAR : lwa_fieldcat.

lwa_fieldcat-col_pos = '2'.
lwa_fieldcat-fieldname = 'ERDAT'.
lwa_fieldcat-tabname = 'LV_FINAL'.
lwa_fieldcat-seltext_l = 'Created Date'.
APPEND lwa_fieldcat to lt_fieldcat.
CLEAR : lwa_fieldcat.

lwa_fieldcat-col_pos = '3'.
lwa_fieldcat-fieldname = 'ERZET'.
lwa_fieldcat-tabname = 'LV_FINAL'.
lwa_fieldcat-seltext_l = 'Entry Time'.
APPEND lwa_fieldcat to lt_fieldcat.
CLEAR : lwa_fieldcat.

lwa_fieldcat-col_pos = '4'.
lwa_fieldcat-fieldname = 'ERNAM'.
lwa_fieldcat-tabname = 'LV_FINAL'.
lwa_fieldcat-seltext_l = 'Created By'.
APPEND lwa_fieldcat to lt_fieldcat.
CLEAR : lwa_fieldcat.

lwa_fieldcat-col_pos = '5'.
lwa_fieldcat-fieldname = 'POSNR'.
lwa_fieldcat-tabname = 'LV_FINAL'.
lwa_fieldcat-seltext_l = 'Sales Document Item'.
APPEND lwa_fieldcat to lt_fieldcat.
CLEAR : lwa_fieldcat.

lwa_fieldcat-col_pos = '6'.
lwa_fieldcat-fieldname = 'MATNR'.
lwa_fieldcat-tabname = 'LV_FINAL'.
lwa_fieldcat-seltext_l = 'Material Number'.
APPEND lwa_fieldcat to lt_fieldcat.
CLEAR : lwa_fieldcat.


*CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
*  EXPORTING
**   I_PROGRAM_NAME         =
**   I_INTERNAL_TABNAME     =
*    i_structure_name       = 'ZSTR_AVL_ORDER'
**   I_CLIENT_NEVER_DISPLAY = 'X'
**   I_INCLNAME             =
**   I_BYPASSING_BUFFER     =
**   I_BUFFER_ACTIVE        =
*  CHANGING
*    ct_fieldcat            = lt_fieldcat
*  EXCEPTIONS
*    inconsistent_interface = 1
*    program_error          = 2
*    OTHERS                 = 3.
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.

CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK              = ' '
*   I_BYPASSING_BUFFER             =
*   I_BUFFER_ACTIVE                = ' '
*   I_CALLBACK_PROGRAM             = ' '
*   I_CALLBACK_PF_STATUS_SET       = ' '
*   I_CALLBACK_USER_COMMAND        = ' '
*   I_STRUCTURE_NAME               =
*   IS_LAYOUT                      =
   IT_FIELDCAT                    = lt_fieldcat
*   IT_EXCLUDING                   =
*   IT_SPECIAL_GROUPS              =
*   IT_SORT                        =
*   IT_FILTER                      =
*   IS_SEL_HIDE                    =
*   I_DEFAULT                      = 'X'
*   I_SAVE                         = ' '
*   IS_VARIANT                     =
*   IT_EVENTS                      =
*   IT_EVENT_EXIT                  =
*   IS_PRINT                       =
*   IS_REPREP_ID                   =
*   I_SCREEN_START_COLUMN          = 0
*   I_SCREEN_START_LINE            = 0
*   I_SCREEN_END_COLUMN            = 0
*   I_SCREEN_END_LINE              = 0
*   IR_SALV_LIST_ADAPTER           =
*   IT_EXCEPT_QINFO                =
*   I_SUPPRESS_EMPTY_DATA          = ABAP_FALSE
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER        =
*   ES_EXIT_CAUSED_BY_USER         =
  TABLES
    t_outtab                       = lv_final
* EXCEPTIONS
*   PROGRAM_ERROR                  = 1
*   OTHERS                         = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
