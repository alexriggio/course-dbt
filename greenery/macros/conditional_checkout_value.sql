{% macro conditional_checkout_value(condition_column, condition_threshold, value_if_met, value_column_if_not_met) %}

    CASE
        WHEN {{ condition_column }} = {{ condition_threshold }} THEN {{ value_if_met }}
        ELSE {{ value_column_if_not_met }} 
    END

{% endmacro %}