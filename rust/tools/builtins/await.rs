use std::future::Future;

fn await_type_matching<T1, T2: Future<Output = T1>>(x: T2) -> T1 {
    panic!(
        "This function exists only in order to implement type inference for `.await` expressions."
    );
}
