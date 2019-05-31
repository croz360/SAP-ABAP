DATA




FORM f_mostrar_alv  TABLES   lt_alv TYPE tt_alv.



  "=== Tablas y estructuras locales

  DATA: lt_alv_aux TYPE STANDARD TABLE OF ty_alv.



  "=== Variables locales

  DATA: l_table   TYPE REF TO cl_salv_table,

        l_salf    TYPE REF TO cl_salv_functions_list,

        o_display TYPE REF TO cl_salv_display_settings,

        o_columns TYPE REF TO cl_salv_columns_table,

        o_column  TYPE REF TO cl_salv_column,

        lv_titulo TYPE lvc_title.



  APPEND LINES OF lt_alv TO lt_alv_aux.



  "=== Validación que la tabla contenga datos

  IF lt_alv_aux[] IS NOT INITIAL.

    TRY .

        cl_salv_table=>factory(

          IMPORTING

            r_salv_table   = l_table

          CHANGING

            t_table        = lt_alv_aux[] ).



        o_display = l_table->get_display_settings( ).



        o_columns = l_table->get_columns( ).

        o_columns->set_optimize( abap_true ).



        "=== Modificación de posición de columna en ALV

        o_columns->set_column_position(

          EXPORTING

            columnname = 'ACREEDOR'    " ALV Control: Field Name of Internal Table Field

            position   = 1

        ).



        o_columns->set_column_position(

          EXPORTING

            columnname = 'NOMBRE_ACRE'   " ALV Control: Field Name of Internal Table Field

            position   = 2

        ).



        "=== Muestra de las celdas en formato Zebra ALV

        o_display->set_striped_pattern( if_salv_c_bool_sap=>true ).

        "=== Asignación De Nombre Al Titulo Del Reporte

        lv_titulo = 'Reporte Pagos - Recibo Electrónico de pagos'.

        o_display->set_list_header( value = lv_titulo

         ).



      CATCH cx_salv_msg

            cx_salv_not_found.

        RAISE:  cx_salv_not_found,

                cx_salv_msg.

    ENDTRY.



    "=== Asignación de la barra de herramientas

    l_salf = l_table->get_functions( ).

    l_salf->set_all( abap_true ).



    "=== Función para mostrar ALV

    l_table->display( ).



  ENDIF.





ENDFORM.






