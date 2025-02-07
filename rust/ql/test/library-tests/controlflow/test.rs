mod calls {
    use crate::test::logical_operators;
    use std::collections::HashMap;

    fn function_call() {
        logical_operators::test_and_operator(true, false, true);
        method_call();
    }

    fn method_call() {
        let mut map = HashMap::new();
        map.insert(37, "a");
    }
}

mod loop_expression {

    fn next(n: i64) -> i64 {
        if n % 2 == 0 {
            n / 2
        } else {
            3 * n + 1
        }
    }

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
        'label: loop {
            1;
            'label: loop {
                if b {
                    continue;
                } else if b {
                    continue 'label;
                }
                continue 'label;
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
            if (x == 5) {
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

    fn break_with_return() -> i64 {
        loop {
            break return 1;
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

    fn test_if_without_else(b: bool) -> i64 {
        let mut i = 3;
        if b {
            i += 1;
        }
        i
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
            return n;
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

    fn test_nested_if_2(cond1: bool, cond2: bool) -> () {
        if cond1 {
            if cond2 {
                println!("1");
            } else {
                println!("2");
            }
            println!("3");
        };
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
        if {
            x = true;
            x
        } {
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

    pub fn test_and_operator(a: bool, b: bool, c: bool) -> bool {
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

    fn test_if_and_operator(a: bool, b: bool, c: bool) -> bool {
        if a && b && c {
            true
        } else {
            false
        }
    }

    fn test_if_or_operator(a: bool, b: bool, c: bool) -> bool {
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

    fn test_and_return(a: bool) {
        a && return;
    }

    fn test_and_true(a: bool) -> i64 {
        if (a && true) {
            return 1;
        }
        0
    }
}

mod question_mark_operator {
    use std::num;

    fn test_question_mark_operator_1(s: &str) -> Result<u32, std::num::ParseIntError> {
        Ok(s.parse::<u32>()? + 4)
    }

    fn test_question_mark_operator_2(b: Option<bool>) -> Option<bool> {
        match b? {
            true => Some(false),
            false => Some(true),
        }
    }
}

mod match_expression {
    use std::convert::Infallible;

    fn test_match(maybe_digit: Option<i64>) -> i64 {
        match maybe_digit {
            Option::Some(x) if x < 10 => x + 5,
            Option::Some(x) => x,
            Option::None => 5,
        }
    }

    fn test_match_with_return_in_scrutinee(maybe_digit: Option<i64>) -> i64 {
        match (if maybe_digit == Some(3) {
            return 3;
        } else {
            maybe_digit
        }) {
            Option::Some(x) => x + 5,
            Option::None => 5,
        }
    }

    fn test_match_and(cond: bool, r: Option<bool>) -> bool {
        (match r {
            Some(a) => a,
            _ => false,
        }) && cond
    }

    fn test_match_with_no_arms<T>(r: Result<T, Infallible>) -> T {
        match r {
            Ok(value) => value,
            Err(never) => match never {},
        }
    }
}

mod let_statement {

    fn test_let_match(a: Option<i64>) -> i64 {
        let Some(n) = a else { panic!("Expected some") };
        n
    }

    fn test_let_with_return(m: Option<i64>) -> bool {
        let ret = match m {
            Some(ret) => ret,
            None => return false,
        };
        true
    }
}

mod patterns {

    fn empty_tuple_pattern(unit: ()) -> () {
        let () = unit;
        return;
    }

    struct MyStruct {}

    fn empty_struct_pattern(st: MyStruct) -> i64 {
        match st {
            MyStruct { .. } => 1,
        }
    }

    fn range_pattern() -> i64 {
        match 42 {
            ..0 => 1,
            1..2 => 2,
            5.. => 3,
            _ => 4,
        }
    }
}

mod divergence {
    fn test_infinite_loop() -> &'static str {
        loop {
            ()
        }
        "never reached"
    }
}

mod async_await {
    async fn say_hello() {
        println!("hello, world!");
    }

    async fn async_block(b: bool) {
        let say_godbye = async {
            println!("godbye, everyone!");
        };
        let say_how_are_you = async {
            println!("how are you?");
        };
        let noop = async {};
        say_hello().await;
        say_how_are_you.await;
        say_godbye.await;
        noop.await;

        let lambda = |foo| async {
            if b {
                return async_block(true);
            };
            foo
        };
    }
}

mod const_evaluation {
    const PI: f64 = 3.14159;

    const fn add_two(n: i64) -> i64 {
        n + 2
    }

    const A_NUMBER: f64 = if add_two(2) + 2 == 4 { PI } else { 0.0 };

    fn const_block_assert<T>() -> usize {
        // If this code ever gets executed, then the assertion has definitely
        // been evaluated at compile-time.
        const {
            assert!(std::mem::size_of::<T>() > 0);
        }
        // Here we can have unsafe code relying on the type being non-zero-sized.
        42
    }

    fn const_block_panic() -> i64 {
        const N: i64 = 12 + 7;
        if false {
            // The panic may or may not occur when the program is built.
            const {
                panic!();
            }
        }
        N
    }
}

fn dead_code() -> i64 {
    if (true) {
        return 0;
    }
    return 1;
}

fn do_thing() {}

fn condition_not_met() -> bool {
    false
}

fn do_next_thing() {}

fn do_last_thing() {}

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
    result
}

fn labelled_block2() {
    let result = 'block: {
        let x: Option<i64> = None;
        let Some(y) = x else {
            break 'block 1;
        };
        0
    };
}

fn test_nested_function2() {
    let mut x = 0;
    fn nested(x: &mut i64) {
        *x += 1;
    }
    nested(&mut x);
}

trait MyFrom<T> {
    fn my_from(x: T) -> Self;
}

struct MyNumber {
    n: i64,
}

impl MyNumber {
    fn new(a: i64) -> Self {
        MyNumber { n: a }
    }

    fn negated(self) -> Self {
        MyNumber { n: self.n }
    }

    fn multifly_add(&mut self, a: i64, b: i64) {
        self.n = (self.n * a) + b;
    }
}
