// generated by codegen, do not edit

fn test_tuple_struct_pat() -> () {
    // A tuple struct pattern. For example:
    match x {
        Tuple("a", 1, 2, 3) => "great",
        Tuple(.., 3) => "fine",
        Tuple(..) => "fail",
    };
}
