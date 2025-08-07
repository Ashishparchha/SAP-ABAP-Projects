*&---------------------------------------------------------------------*
*& Report  ZPRG_BLOCK_ALV
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  ZPRG_BLOCK_ALV.

TYPES : BEGIN OF lty_vbak,
        vbeln TYPE vbeln_va,
        erdat TYPE erdat,
        erzet TYPE erzet,
        ernam TYPE ernam,
        END OF lty_vbak.

TYPES : BEGIN OF lty_vbap,
        vbeln TYPE vbeln_va,
        posnr TYPE posnr_va,
        matnr TYPE matnr,
        END OF lty_vbap.

DATA : lt_vbak TYPE TABLE OF lty_vbak.
DATA : ls_vbak TYPE lty_vbak.
DATA : lt_vbap TYPE TABLE OF lty_vbap.
DATA : ls_vbap TYPE lty_vbap.
DATA : lv_vbeln TYPE vbeln_va.
DATA : lt_fieldcat_vbak TYPE slis_t_fieldcat_alv.
DATA : ls_fieldcat_vbak TYPE slis_fieldcat_alv.
DATA : lt_fieldcat_vbap TYPE slis_t_fieldcat_alv.
DATA : ls_fieldcat_vbap TYPE slis_fieldcat_alv.
DATA : lt_layout_vbak TYPE SLIS_LAYOUT_ALV.
DATA : lt_event_vbak TYPE SLIS_T_EVENT.
DATA : lt_layout_vbap TYPE SLIS_LAYOUT_ALV.
DATA : lt_event_vbap TYPE SLIS_T_EVENT.

SELECT-OPTIONS : s_vbeln for lv_vbeln.

SELECT vbeln erdat erzet ernam
  FROM vbak
  INTO TABLE lt_vbak
  WHERE vbeln in s_vbeln.

IF lt_vbak IS NOT INITIAL.
  SELECT vbeln posnr matnr
    FROM vbap
    INTO TABLE lt_vbap
    FOR ALL ENTRIES IN lt_vbak
    WHERE vbeln = lt_vbak-vbeln.
ENDIF.

ls_fieldcat_vbak-col_pos = '1'.
ls_fieldcat_vbak-fieldname = 'VBELN'.
ls_fieldcat_vbak-tabname = 'LT_VBAK'.
ls_fieldcat_vbak-seltext_l = 'Document Number'.
APPEND ls_fieldcat_vbak to lt_fieldcat_vbak.
CLEAR : ls_fieldcat_vbak.

ls_fieldcat_vbak-col_pos = '2'.
ls_fieldcat_vbak-fieldname = 'ERDAT'.
ls_fieldcat_vbak-tabname = 'LT_VBAK'.
ls_fieldcat_vbak-seltext_l = 'Creation Date'.
APPEND ls_fieldcat_vbak to lt_fieldcat_vbak.
CLEAR : ls_fieldcat_vbak.

ls_fieldcat_vbak-col_pos = '3'.
ls_fieldcat_vbak-fieldname = 'ERZET'.
ls_fieldcat_vbak-tabname = 'LT_VBAK'.
ls_fieldcat_vbak-seltext_l = 'Time'.
APPEND ls_fieldcat_vbak to lt_fieldcat_vbak.
CLEAR : ls_fieldcat_vbak.

ls_fieldcat_vbak-col_pos = '4'.
ls_fieldcat_vbak-fieldname = 'ERNAM'.
ls_fieldcat_vbak-tabname = 'LT_VBAK'.
ls_fieldcat_vbak-seltext_l = 'User'.
APPEND ls_fieldcat_vbak to lt_fieldcat_vbak.
CLEAR : ls_fieldcat_vbak.

ls_fieldcat_vbap-col_pos = '1'.
ls_fieldcat_vbap-fieldname = 'VBELN'.
ls_fieldcat_vbap-tabname = 'LT_VBAP'.
ls_fieldcat_vbap-seltext_l = 'Document Number'.
APPEND ls_fieldcat_vbap to lt_fieldcat_vbap.
CLEAR : ls_fieldcat_vbap.

ls_fieldcat_vbap-col_pos = '2'.
ls_fieldcat_vbap-fieldname = 'POSNR'.
ls_fieldcat_vbap-tabname = 'LT_VBAP'.
ls_fieldcat_vbap-seltext_l = 'Item Number'.
APPEND ls_fieldcat_vbap to lt_fieldcat_vbap.
CLEAR : ls_fieldcat_vbap.

ls_fieldcat_vbap-col_pos = '3'.
ls_fieldcat_vbap-fieldname = 'MATNR'.
ls_fieldcat_vbap-tabname = 'LT_VBAP'.
ls_fieldcat_vbap-seltext_l = 'Material Number'.
APPEND ls_fieldcat_vbap to lt_fieldcat_vbap.
CLEAR : ls_fieldcat_vbap.


CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_INIT'
  EXPORTING
    i_callback_program             = sy-repid
*   I_CALLBACK_PF_STATUS_SET       = ' '
*   I_CALLBACK_USER_COMMAND        = ' '
*   IT_EXCLUDING                   =
          .

CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
  EXPORTING
    is_layout                        = lt_layout_vbak
    it_fieldcat                      = lt_fieldcat_vbak
    i_tabname                        = 'LT_VBAK'
    it_events                        = lt_event_vbak
*   IT_SORT                          =
*   I_TEXT                           = ' '
  TABLES
    t_outtab                         = lt_vbak
 EXCEPTIONS
   PROGRAM_ERROR                    = 1
   MAXIMUM_OF_APPENDS_REACHED       = 2
   OTHERS                           = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_APPEND'
  EXPORTING
    is_layout                        = lt_layout_vbap
    it_fieldcat                      = lt_fieldcat_vbap
    i_tabname                        = 'LT_VBAP'
    it_events                        = lt_event_vbap
*   IT_SORT                          =
*   I_TEXT                           = ' '
  TABLES
    t_outtab                         = lt_vbap
 EXCEPTIONS
   PROGRAM_ERROR                    = 1
   MAXIMUM_OF_APPENDS_REACHED       = 2
   OTHERS                           = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


CALL FUNCTION 'REUSE_ALV_BLOCK_LIST_DISPLAY'
* EXPORTING
*   I_INTERFACE_CHECK             = ' '
*   IS_PRINT                      =
*   I_SCREEN_START_COLUMN         = 0
*   I_SCREEN_START_LINE           = 0
*   I_SCREEN_END_COLUMN           = 0
*   I_SCREEN_END_LINE             = 0
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER       =
*   ES_EXIT_CAUSED_BY_USER        =
 EXCEPTIONS
   PROGRAM_ERROR                 = 1
   OTHERS                        = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.