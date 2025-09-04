/// Tests for type inference for closures and higher-order functions.

mod simple_closures {
    pub fn test() {
        // A simple closure without type annotations or invocations.
        let my_closure = |a, b| a && b;

        let x: i64 = 1i64; // $ certainType=x:i64
        let add_one = |n| n + 1i64; // $ target=add
        let _y = add_one(x); // $ type=_y:i64

        // The type of `x` is inferred from the closure's argument type.
        let x = Default::default(); // $ type=x:i64 target=default
        let add_zero = |n: i64| n;
        let _y = add_zero(x); // $ type=_y:i64

        let _get_bool = || -> bool {
            // The return type annotation on the closure lets us infer the type of `b`.
            let b = Default::default(); // $ type=b:bool target=default
            b
        };

        // The parameter type of `id` is inferred from the argument.
        let id = |b| b; // $ type=b:bool
        let _b = id(true); // $ type=_b:bool

        // The return type of `id2` is inferred from the type of the call expression.
        let id2 = |b| b;
        let arg = Default::default(); // $ target=default type=arg:bool
        let _b2: bool = id2(arg); // $ certainType=_b2:bool
    }
}

mod fn_once_trait {
    fn return_type<F: FnOnce(bool) -> i64>(f: F) {
        let _return = f(true); // $ type=_return:i64
    }

    fn argument_type<F: FnOnce(bool) -> i64>(f: F) {
        let arg = Default::default(); // $ target=default type=arg:bool
        f(arg);
    }

    fn apply<A, B, F: FnOnce(A) -> B>(f: F, a: A) -> B {
        f(a)
    }

    fn apply_two(f: impl FnOnce(i64) -> i64) -> i64 {
        f(2)
    }

    fn test() {
        let f = |x: bool| -> i64 {
            if x {
                1
            } else {
                0
            }
        };
        let _r = apply(f, true); // $ target=apply type=_r:i64

        let f = |x| x + 1; // $ MISSING: type=x:i64 target=add
        let _r2 = apply_two(f); // $ target=apply_two certainType=_r2:i64
    }
}

mod dyn_fn_once {
    fn apply_boxed<A, B, F: FnOnce(A) -> B + ?Sized>(f: Box<F>, arg: A) -> B {
        f(arg)
    }

    fn apply_boxed_dyn<A, B>(f: Box<dyn FnOnce(A) -> B>, arg: A) {
        let _r1 = apply_boxed(f, arg); // $ target=apply_boxed type=_r1:B
        let _r2 = apply_boxed(Box::new(|_: i64| true), 3); // $ target=apply_boxed target=new type=_r2:bool
    }
}
