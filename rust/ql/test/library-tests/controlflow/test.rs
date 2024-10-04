fn test_call() -> bool {
    test_and_operator(true, false, true);
    foo::<u32, u64>(42);
}

mod loop_expression {

    fn test_break_and_continue(n: i64) -> bool {
        let mut i = n;
        loop {
            i = next(i);
            if i > 10000 {
                return false;
            }
            if i == 1 {
                break;
            }
            if i % 2 != 0 {
                continue;
            }
            i = i / 2
        }
        return true;
    }

    fn test_break_with_labels(b: bool) -> bool {
        'outer: loop {
            'inner: loop {
                if b {
                    break;
                } else if b {
                    break 'outer;
                }
                break 'inner;
            }
        }
        true
    }

    fn test_continue_with_labels(b: bool) -> ! {
        'outer: loop {
            1;
            'inner: loop {
                if b {
                    continue;
                } else if b {
                    continue 'outer;
                }
                continue 'inner;
            }
        }
    }

    fn test_loop_label_shadowing(b: bool) -> ! {
        'loop: loop {
            1;
            'loop: loop {
                if b {
                    continue;
                } else if b {
                    continue 'loop;
                }
                continue 'loop;
            }
        }
    }

    fn test_while(i: i64) {
        let mut b = true;
        while b {
            1;
            if (i > 0) {
                break;
            }
            b = false;
        }
    }

    fn test_while_let() {
        let mut iter = 1..10;
        while let Some(x) = iter.next() {
            if (i = 5) {
                break;
            }
        }
    }

    fn test_for(j: i64) {
        for i in 0..10 {
            if (i == j) {
                break;
            }
            1;
        }
    }
}

fn test_nested_function(n: i64) -> i64 {
    let add_one = |i| i + 1;
    add_one(add_one(n))
}

mod if_expression {

    fn test_if_else(n: i64) -> i64 {
        if n <= 0 {
            0
        } else {
            n - 1
        }
    }

    fn test_if_let_else(a: Option<i64>) -> i64 {
        if let Some(n) = a {
            n
        } else {
            0
        }
    }

    fn test_if_let(a: Option<i64>) -> i64 {
        if let Some(n) = a {
            n
        }
        0
    }

    fn test_nested_if(a: i64) -> i64 {
        if (if a < 0 { a < -10 } else { a > 10 }) {
            1
        } else {
            0
        }
    }

    fn test_nested_if_match(a: i64) -> i64 {
        if (match a {
            0 => true,
            _ => false,
        }) {
            1
        } else {
            0
        }
    }

    fn test_nested_if_block(a: i64) -> i64 {
        if {
            ();
            a > 0
        } {
            1
        } else {
            0
        }
    }

    fn test_if_assignment(a: i64) -> i64 {
        let mut x = false;
        if x = true {
            1
        } else {
            0
        }
    }

    fn test_if_loop1(a: i64) -> i64 {
        if (loop {
            if a > 0 {
                break a > 10;
            };
            a < 10;
        }) {
            1
        } else {
            0
        }
    }

    fn test_if_loop2(a: i64) -> i64 {
        if ('label: loop {
            if a > 0 {
                break 'label a > 10;
            };
            a < 10;
        }) {
            1
        } else {
            0
        }
    }

    fn test_labelled_block(a: i64) -> i64 {
        if ('block: {
            break 'block a > 0;
        }) {
            1
        } else {
            0
        }
    }
}

mod logical_operators {

    fn test_and_operator(a: bool, b: bool, c: bool) -> bool {
        let d = a && b && c;
        d
    }

    fn test_or_operator(a: bool, b: bool, c: bool) -> bool {
        let d = a || b || c;
        d
    }

    fn test_or_operator_2(a: bool, b: i64, c: bool) -> bool {
        let d = a || (b == 28) || c;
        d
    }

    fn test_not_operator(a: bool) -> bool {
        let d = !a;
        d
    }

    fn test_if_and_operator(a: bool, b: i64, c: bool) -> bool {
        if a && b && c {
            true
        } else {
            false
        }
    }

    fn test_if_or_operator(a: bool, b: i64, c: bool) -> bool {
        if a || b || c {
            true
        } else {
            false
        }
    }

    fn test_if_not_operator(a: bool) -> bool {
        if !a {
            true
        } else {
            false
        }
    }
}

fn test_match(maybe_digit: Option<i64>) -> i64 {
    match maybe_digit {
        Option::Some(x) if x < 10 => x + 5,
        Option::Some(x) => x,
        Option::None => 5,
    }
}

mod divergence {
    fn test_infinite_loop() -> &'static str {
        loop {
            1
        }
        "never reached"
    }

    fn test_let_match(a: Option<i64>) {
        let Some(n) = a else { "Expected some" };
        n
    }
}

fn dead_code() -> i64 {
    if (true) {
        return 0;
    }
    return 1;
}

fn labelled_block1() -> i64 {
    let result = 'block: {
        do_thing();
        if condition_not_met() {
            break 'block 1;
        }
        do_next_thing();
        if condition_not_met() {
            break 'block 2;
        }
        do_last_thing();
        3
    };
}

fn labelled_block2() -> i64 {
    let result = 'block: {
        let x: Option<i64> = None;
        let Some(y) = x else {
            break 'block 1;
        };
        x
    };
}
