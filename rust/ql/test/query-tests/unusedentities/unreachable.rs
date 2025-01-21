pub fn cond() -> bool {
    get_a_number() == 1
}

fn get_a_number() -> i32 {
    maybe_get_a_number().unwrap_or(0)
}

fn maybe_get_a_number() -> Option<i32> {
    std::env::args().nth(1).map(|s| s.parse::<i32>().unwrap())
}

// --- unreachable code --

fn do_something() {}

pub fn unreachable_if_1() {
    if false {
        do_something(); // $ Alert[rust/dead-code]
    } else {
        do_something();
    }

    if true {
        do_something();
    } else {
        do_something(); // $ Alert[rust/dead-code]
    }

    let v = get_a_number();
    if v == 1 {
        if v != 1 {
            do_something(); // $ MISSING: Alert[rust/dead-code]
        }
    }

    if cond() {
        return;
        do_something(); // $ Alert[rust/dead-code]
    }

    if cond() {
        do_something();
    } else {
        return;
        do_something(); // $ Alert[rust/dead-code]
    }
    do_something();

    if cond() {
        let x = cond();

        if (x) {
            do_something();
            if (!x) {
                do_something(); // $ MISSING: Alert[rust/dead-code]
            }
            do_something();
        }
    }

    if cond() {
        return;
    } else {
        return;
    }
    do_something(); // $ Alert[rust/dead-code]
}

pub fn unreachable_if_2() {
    if cond() {
        do_something();
        return;
    } else {
        do_something();
    }

    do_something();
}

pub fn unreachable_if_3() {
    if !cond() {
        do_something();
        return;
    }

    do_something();
}

pub fn unreachable_panic() {
    if cond() {
        do_something();
        panic!("Oh no!!!");
        do_something(); // $ MISSING: Alert[rust/dead-code]
    }

    if cond() {
        do_something();
        unimplemented!();
        do_something(); // $ MISSING: Alert[rust/dead-code]
    }

    if cond() {
        do_something();
        todo!();
        do_something(); // $ MISSING: Alert[rust/dead-code]
    }

    if cond() {
        do_something();
        unreachable!();
        do_something(); // $ MISSING: Alert[rust/dead-code]
    }

    if cond() {
        let mut maybe;

        maybe = Some("Thing");
        _ = maybe.unwrap(); // (safe)
        do_something();

        maybe = if cond() { Some("Other") } else { None };
        _ = maybe.unwrap(); // (might panic)
        do_something();

        maybe = None;
        _ = maybe.unwrap(); // (always panics)
        do_something(); // $ MISSING: Alert[rust/dead-code]
    }

    if cond() {
        do_something();
        _ = false && // .
            panic!(); // $ Alert[rust/dead-code]
        do_something();
        _ = false || panic!();
        do_something(); // $ MISSING: Alert[rust/dead-code]
    }

    if cond() {
        do_something();
        _ = true || // .
            panic!(); // $ Alert[rust/dead-code]
        do_something();
        _ = true && panic!();
        do_something(); // $ MISSING: Alert[rust/dead-code]
    }
}

macro_rules! bail_1 {
    () => {
        return Err(String::from("message"))
    };
}

macro_rules! bail_2 {
    ($message:literal) => {
        return Err(String::from($message))
    };
}

pub fn unreachable_bail() -> Result<i32, String> {
    if cond() {
        do_something();
        return Err(String::from("message"));
        do_something(); // $ Alert[rust/dead-code]
    }

    if cond() {
        do_something();
        bail_1!(); // $ SPURIOUS: Alert[rust/dead-code]
        do_something(); // $ MISSING: Alert[rust/dead-code]
    }

    if cond() {
        do_something();
        bail_2!("message"); // $ SPURIOUS: Alert[rust/dead-code]
    }
    do_something();

    Ok(1)
}

pub fn unreachable_match() {
    if cond() {
        match get_a_number() {
            1 => {
                return;
            }
            _ => {
                do_something();
            }
        }
        do_something();
    }

    if cond() {
        match get_a_number() {
            1 => {
                return;
            }
            _ => {
                return;
            }
        }
        do_something(); // $ Alert[rust/dead-code]
    }

    if cond() {
        _ = match get_a_number() {
            1 => "One",
            _ => "Some"
        };
        do_something();
    }

    if cond() {
        _ = Some(match get_a_number() {
            1 => "One",
            _ => "Some"
        });
        do_something();
    }
}

pub fn unreachable_loop() {
    if cond() {
        loop {
            do_something();
            break;
            do_something(); // $ Alert[rust/dead-code]
        }
    }

    if cond() {
        while cond() {
            do_something();
        }

        while false {
            do_something(); // $ Alert[rust/dead-code]
        }

        while true {
            do_something();
        }
        do_something(); // $ Alert[rust/dead-code]
    }

    if cond() {
        for _ in 1..10 {
            if cond() {
                continue;
                do_something(); // $ Alert[rust/dead-code]
            }
            do_something();
        }
    }

    if cond() {
        loop {
            if cond() {
                return;
                do_something(); // $ Alert[rust/dead-code]
            }
        }
        do_something(); // $ Alert[rust/dead-code]
        do_something();
        do_something();
    }

    if cond() {
        fn do_nothing() { };
        fn loop_forever() { loop {} };
        fn take_a_fn(_: fn() -> ()) {
        };
        fn call_a_fn(f: fn() -> ()) {
            f();
        };

        take_a_fn( do_nothing );
        call_a_fn( do_nothing );
        take_a_fn( loop_forever );
        call_a_fn( loop_forever );
        do_something(); // $ MISSING: Alert[rust/dead-code]
    }
}

async fn do_something_async() {}

pub async fn unreachable_loop_async() {
    let for_ten = async {
        for _ in 1..10 {
            do_something_async().await;
        }
        do_something();
    };

    let for_ever = async {
        loop {
            do_something_async().await;
        }
        do_something(); // $ Alert[rust/dead-code]
    };

    do_something();
    for_ten.await;
    do_something();
    for_ever.await;
    do_something(); // $ MISSING: Alert[rust/dead-code]
}

pub fn unreachable_paren() {
    let _ = (((1)));
}

pub fn unreachable_let_1() {
    if let Some(_) = maybe_get_a_number() {
        do_something();
        return;
    } else {
        do_something();
    }

    do_something();

    if let _ = get_a_number() {
        // (always succeeds)
        do_something();
        return;
    } else {
        do_something(); // $ Alert[rust/dead-code]
    }

    do_something();
}

pub fn unreachable_let_2() {
    let Some(_) = maybe_get_a_number() else {
        do_something();
        return;
    };

    do_something();

    let _ = maybe_get_a_number() else {
        // (always succeeds)
        do_something(); // $ Alert[rust/dead-code]
        return;
    };

    do_something();
}

#[cfg(not(foo))]
pub fn unreachable_attributes() {
    // `#[cfg` and `cfg!` checks can go either way, we should not assume this
    // function or either branch below is unreachable.
    if cfg!(bar) {
        do_something();
    } else {
        do_something();
    }

    #[doc="This is a doc comment declared through an attribute."]

    if (true) {
        do_something();
    } else {
        do_something(); // $ Alert[rust/dead-code]
    }
}

const _: () = {
    _ = 1; // $ SPURIOUS: Alert[rust/dead-code]
};

const _: () = {
    const fn foo() {
        _ = 1;
    };
    foo(); // $ SPURIOUS: Alert[rust/dead-code]
};
