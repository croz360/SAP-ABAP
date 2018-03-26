
*Descripcion:
*Programa de control para imprimir smartform
DATA:   date1       type dats,
        carrier1    type s_carr_id,
        connection1 type s_conn_id,
        usu         type sy-uname,
        lv_va       type string,
        l_funcion   type rs381_fnam. " variable nombre de la funcion para llamar al smartform

types begin of ty_sbook.
        include structure sflight.
types end of   ty_sbook.
* tabla para la selecion de los datos que se mostrarar en el smartform
data: it_sbook type standard table of ty_sbook.

start-of-selection.
*Asisgnacion de datos a los campos 
    carrier1    = 'LH'.
    connection1 = '0400'.
    date1       = '20150808'.
    usu         = sy-uname.
*seleccion de datos para meterlos en la tabla interna IT_SBOOK
    select *
        from sflight
        up to 15 rows
        into corresponding fields of table it_sbook
        where carrid eq 'LH'.
* llamado de la funcion para asignar el nombre del smartform y a la variable l_FUNCION
call function 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
        formname            = 'ZPRUEBA_UPU'
    IMPORTING               = l_funcion
        no_form             = 1
        no_function_module  = 2
        OTHERS              = 3.
    if sy-subrc <> 0.

        message id sy-msgid type sy-msgty NUMBER sy-msgno
                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    endif.

    if sy-subrc eq 0.
*Uso de la funcion para el llamado del smartform para mostrar los datos en una impresora 
        CALL FUNCTION l_funcion
            EXPORTING
                fldate          = date1
                carrier1        = carrier1
                connection      = connection1
                usuario         = usu
            TABLES
                gs_sbook        = it_sbook
            EXCEPTIONS
                formatting_error = 1
                internal_error   = 2
                send_error       = 3
                user_canceled    = 4
                OTHERS           = 5.

    endif.