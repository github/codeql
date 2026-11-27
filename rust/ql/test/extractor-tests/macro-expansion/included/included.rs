fn included() {
    _ = concat!("Hello", " ", "world!");  // this doesn't expand (in included.rs) since 0.0.274
}

#[derive(Debug)]
struct IncludedDerived {
    value: usize,
}

macro_rules! identity {
    ($value:expr) => {
        $value
    };
}

fn argument_location() {
    identity!({
        dangerous_call();
    });
}

fn dangerous_call() {}

macro_rules! definition_location {
    () => {
        dangerous_call()
    };
}

fn definition_origin() {
    definition_location!();
}

macro_rules! shadowed {
    () => { struct IncludedShadowed; };
}

shadowed!();
