function example_array_type() {
  interface ExArrayTypeBase {};
  type ExArrayType = ExArrayTypeBase[];
}

function example_class_type() {
  function ex_class_type_factory<ExClassType>(c: { new(): ExClassType }): ExClassType {
    return new c();
  }
}

function example_enum() {
  enum ExEnum {
    ExEnumA,
    ExEnumB
  }
}

function example_generics() {
  function ex_generic_fun<ExGenericTypeParam>(ex_generic_arg: ExGenericTypeParam): ExGenericTypeParam {
    return ex_generic_arg
  }
  
  function ex_generic_constrained_fun<
  ExGenericConstrainingType,
  ExGenericConstrainedTypeParam extends ExGenericConstrainingType>
  (ex_generic_arg: ExGenericConstrainedTypeParam): ExGenericConstrainedTypeParam {
    return ex_generic_arg
  }
}

// Namespace example omitted as namespaces don't appear within functions.

function example_tuple_type() {
  interface ExTupleTypeBase {};
  type ExTupleType = [ExTupleTypeBase, ExTupleTypeBase];
}

function example_type_assertion() {
  interface ExCastType {};
  let ex_cast_rhs = 1;
  let ex_cast_lhs_a = <ExCastType>ex_cast_rhs;
  let ex_cast_lhs_b = ex_cast_rhs as ExCastType;
}

function example_type_literals() {
  type ExStringLitType = 'ex_string_lit';
  type ExNumLitType = 0;
  type ExBoolLitType = true;
}

function example_type_operators() {
  interface ExTypeBaseTypeA {}
  interface ExTypeBaseTypeB {}
  type ExTypeIntersectionType = ExTypeBaseTypeA & ExTypeBaseTypeB;
  type ExTypeUnionType = ExTypeBaseTypeA | ExTypeBaseTypeB;
}

function example_var_decl_annotated() {
  class ExVarDeclClass {};
  let ex_var_decl_annotated_let: ExVarDeclClass = null;
  var ex_var_decl_annotated_var: ExVarDeclClass = null;
}

// Parameters

function example_function_with_params_annotated() {
  function ex_function_with_params_annotated(ex_function_param_a: number, ex_function_param_b: string) {}
}

function example_with_params_annotated(ex_param_a: number, [ex_param_b, ex_param_c]: string[], { ex_param_d } : { ex_param_d: object }) {
  return true;
}
