*&---------------------------------------------------------------------*
*& Report  ZPRG_FILE_UPLOAD
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zprg_file_upload.

TYPES : BEGIN OF ty_data,
  matnr	TYPE matnr,
  mbrsh	TYPE mbrsh,
  mtart	TYPE mtart,
  maktx	TYPE maktx,
  meins	TYPE meins,
  END OF ty_data.

DATA : ls_data TYPE ty_data.
DATA : it_data TYPE TABLE OF ty_data.
DATA : lv_file TYPE string.

PARAMETERS : p_file TYPE localfile.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

START-OF-SELECTION.

  lv_file = p_file.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                      = lv_file
*     FILETYPE                      = 'ASC'
     has_field_separator           = 'X'
*     HEADER_LENGTH                 = 0
*     READ_BY_LINE                  = 'X'
*     DAT_MODE                      = ' '
*     CODEPAGE                      = ' '
*     IGNORE_CERR                   = ABAP_TRUE
*     REPLACEMENT                   = '#'
*     CHECK_BOM                     = ' '
*     VIRUS_SCAN_PROFILE            =
*     NO_AUTH_CHECK                 = ' '
*     I_X                           =
*   IMPORTING
*     FILELENGTH                    =
*     HEADER                        =
*     E_Y                           =
    TABLES
      data_tab                      = it_data
   EXCEPTIONS
     file_open_error               = 1
     file_read_error               = 2
     no_batch                      = 3
     gui_refuse_filetransfer       = 4
     invalid_type                  = 5
     no_authority                  = 6
     unknown_error                 = 7
     bad_data_format               = 8
     header_not_allowed            = 9
     separator_not_allowed         = 10
     header_too_long               = 11
     unknown_dp_error              = 12
     access_denied                 = 13
     dp_out_of_memory              = 14
     disk_full                     = 15
     dp_timeout                    = 16
     OTHERS                        = 17
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.