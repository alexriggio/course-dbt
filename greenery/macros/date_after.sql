{% test date_after(model, column_name, before_date_column) %}


    SELECT {{ before_date_column }}, {{ column_name }}
    FROM {{ model }}
    WHERE {{ column_name }} IS NOT NULL 
    AND {{ before_date_column }} > {{ column_name }}


{% endtest %}