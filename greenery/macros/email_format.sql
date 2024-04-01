{% test email_format(model, column_name) %}


    SELECT
        {{ column_name }}
    FROM {{ model }}
    WHERE 
        {{ column_name }} !~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'


{% endtest %}