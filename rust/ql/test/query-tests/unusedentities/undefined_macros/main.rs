
// --- undefined macro calls ---

fn undefined_macros1() {
    let a: u16;

    undefined_macro_call!(d);
}

fn undefined_macros2() {
    {
        let a: u16 = 1; // $ MISSING: Alert[rust/unused-value]
    }

    undefined_macro_call!(5);

    let b: u16; // $ MISSING: Alert[rust/unused-variable]
}

fn undefined_macros3() {
    match std::env::args().nth(1).unwrap().parse::<u16>() {
        Ok(n) => {
            undefined_macro_call!(n);
        }
        _ => {}
    }
}

fn main() {
    undefined_macros1();
    undefined_macros2();
    undefined_macros3();
}
