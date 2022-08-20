let data1 = {{ user_data1 }};
let data2 = {{{ user_data2 }}};
if ({{something}}) {}
foo({{bar}}, {{baz}});

{{not_generated_code}} // parse as block
{{ if (not_generated_code) { } }} // parse as block
if (1 == 2) {{not_generated_code}} // parse as block
let string = "{{ not_generated_code }}"; // parse as string literal
