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

    fn test_break_with_labels() -> bool {
        'outer: loop {
            'inner: loop {
                if false {
                    break;
                } else if true {
                    break 'outer;
                }
                break 'inner;
            }
        }
        true
    }

    fn test_continue_with_labels() -> ! {
        'outer: loop {
            1;
            'inner: loop {
                if false {
                    continue;
                } else if true {
                    continue 'outer;
                }
                continue 'inner;
            }
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
        if (if a < 0 { a < -10 } else { a > 10}) {
            1
        } else {
            0
        }
    }

    fn test_nested_if_match(a: i64) -> i64 {
        if (match a { 0 => true, _ => false }) {
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

}

fn test_match(maybe_digit: Option<i64>) -> {
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
        let Some(n) = a else {
            "Expected some"
        };
        n
    }
}
