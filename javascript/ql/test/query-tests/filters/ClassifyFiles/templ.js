{% if email %}
common.autofocus('#id_password');
{% else %}
common.autofocus('#id_username');
{% endif %}
// semmle-extractor-options: --tolerate-parse-errors
