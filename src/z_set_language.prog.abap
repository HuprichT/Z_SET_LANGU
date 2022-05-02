*&---------------------------------------------------------------------*
*& Report Z_SET_LANGUAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_set_language.

** Data Declaration **)

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
"Include Search Help Z_LANGUAGES
PARAMETERS: p_langu TYPE sy-langu OBLIGATORY DEFAULT 'EN' MATCHCODE OBJECT z_languages.

SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  IF p_langu EQ sy-langu.
    RETURN. "Exit Logic
  ENDIF.

  "Check if Input Language is valid
  SELECT COUNT(*) FROM t002c WHERE spras = p_langu.

  IF sy-subrc <> 0.
    MESSAGE TEXT-004 TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  SET LOCALE LANGUAGE p_langu.

  "STARTING NEW TASK: Fubas has to be RFC Component because of asynchronous execution
  CALL FUNCTION 'Z_CALL_TRANS' STARTING NEW TASK 'LANGUAGE'
    EXPORTING
      iv_tcode         = 'SESSION_MANAGER'
    EXCEPTIONS
      no_authorization = 1
      OTHERS           = 2.

  CASE sy-subrc.
    WHEN 0. "No Error
      EXIT.
    WHEN 1.
      MESSAGE TEXT-002 TYPE 'I' DISPLAY LIKE 'E'.
    WHEN 2.
      MESSAGE  TEXT-003 TYPE 'I' DISPLAY LIKE 'E'.
    WHEN OTHERS.
      MESSAGE 'Fehler bei der Ausführung' TYPE 'I' DISPLAY LIKE 'E'.
  ENDCASE.
