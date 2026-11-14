fn attributed_non_leaf_expr() {
    let _ = [#[allow(unused)] (1 + 2)];
}

struct S {
    field: i32,
}

fn attributed_macro_expr() {
    let _ = [#[allow(unused)] (vec![1])];
}

fn attributed_struct_expr() {
    let _ = [#[allow(unused)] (S { field: 1 })];
}

fn comments_in_parentheses() {
    let _ = (1 + 2 /* expression parentheses */);
    let (value /* pattern parentheses */) = 1;
    let _ = value;
}
