// generated by codegen, do not edit

fn test_loop_expr() -> () {
    // A loop expression. For example:
    loop {
        println!("Hello, world (again)!");
    };
    'label: loop {
        println!("Hello, world (once)!");
        break 'label;
    };
    let mut x = 0;
    loop {
        if x < 10 {
            x += 1;
        } else {
            break;
        }
    };
}
