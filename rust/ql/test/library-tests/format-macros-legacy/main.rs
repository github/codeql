// Verifies that dataflow through the format-family macros is recovered on
// pre-1.94 toolchains, where rust-analyzer no longer expands them and the
// extractor reconstructs the `FormatArgsExpr` (see `rust-toolchain.toml`).

fn source(i: i64) -> String {
    i.to_string()
}

fn sink(s: String) {}

pub fn format_flow() {
    let a = source(1);
    sink(format!("{}", a)); // $ hasTaintFlow=1

    let b = source(2);
    sink(format!("{b}")); // $ hasTaintFlow=2

    let c = source(3);
    let s = format!("x={c} y={}", c);
    sink(s); // $ hasTaintFlow=3
}

pub fn exercises_reconstruction() {
    // No flow assertions here: these exercise reconstruction of the rest of the
    // family, including the writer-argument handling of `write!`/`writeln!`.
    //
    // Flow into a writer buffer is not recovered on <1.94 (the
    // `buf.write_fmt(..)` desugaring is absent), but this matches native
    // behavior on >=1.94, where the `Write::write_fmt` content-to-self taint
    // model is also missing. So it is a pre-existing model gap, not a
    // regression from the reconstruction.
    let d = source(4);
    let _ = format_args!("{}", d);

    use std::fmt::Write;
    let mut buf = String::new();
    let e = source(5);
    let _ = write!(buf, "{}", e);
    let _ = writeln!(buf, "{e}");
    sink(buf);
}

// The log-injection sinks (`println!`/`eprintln!`/`panic!`) are reconstructed
// into their real callees (`_print`/`_eprint`/`panic_fmt`), so the manual sink
// models keep firing on <1.94 exactly as they do on native expansions.
pub fn log_injection_sinks() {
    let tainted = std::env::var("USER_INPUT").unwrap_or_default(); // $ Source=environment

    println!("{}", tainted); // $ Alert[rust/log-injection]=environment
    eprintln!("{tainted}"); // $ Alert[rust/log-injection]=environment
    print!("{}", tainted); // $ Alert[rust/log-injection]=environment
    eprint!("{tainted}"); // $ Alert[rust/log-injection]=environment
}

fn main() {
    format_flow();
    exercises_reconstruction();
    log_injection_sinks();
}
