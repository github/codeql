function example_binary_op() {
    ex_binary_left + ex_binary_right;
}

function example_binary_op_assignment() {
    ex_binary_lvalue += ex_binary_rvalue;
}

function example_boolean_literal() {
    true;
    false;
}

function example_boolean_op() {
    ex_boolean_op_lhs && ex_boolean_op_rhs
}

function example_class() {
    class ExClass {}
}

function example_class_member() {
    class ExClass {
        ex_class_member() {}
    }
}

function example_cmp_ops() {
    ex_cmp_lhs_a == ex_cmp_rhs_a
    ex_cmp_lhs_b === ex_cmp_rhs_b
    ex_cmp_lhs_c > ex_cmp_rhs_c
}

function example_formatted_value() {
    `hello ${ex_formatted_expr}`;
}

function example_function() {
    function ex_function() {}
}

function example_function_empty_body() {

}

function example_generator() {
    function* ex_generator() {
        yield ex_gen_yield_expr
    }
}

// An import example is omitted as imports only appear on the top level (in ES6).

function example_lambda() {
    ex_lambda_param => ex_lambda_body
}

function example_list() {
    [ex_list_mem_a, ex_list_mem_b];
}

function example_numeric_literal() {
    3.14;
    0xA;
    0xa;
}

function example_object_literal() {
    let ex_dict = {
        ex_dict_key_a: ex_dict_val_a,
        ex_dict_key_b: ex_dict_val_b,
    };
}

function example_property_accesses() {
    ({}).ex_property_access_ident;
    ({})['ex_property_access_str'];
}

function example_string_literal() {
    "ex_str_a";
    'ex_str_b';
}

function example_unary_op() {
    -ex_unary_operand;
}

function example_var_def() {
    let ex_var_def_let_lvalue = ex_var_def_let_rvalue;
    var ex_var_def_var_lvalue = ex_var_def_var_rvalue;
}

function example_var_update() {
    ex_var_update_var = ex_var_update_val;
}

function example_return_extended_class (Parent) {
  return class Child extends Parent {
  }
}

// Parameters

function example_function_with_params() {
    function ex_function_with_params(ex_function_param_a, ex_function_param_b) { }
}

function example_with_params(ex_param_a, [ex_param_b, ex_param_c], { ex_param_d }) {
    return true;
}
