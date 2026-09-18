// Verifies that dataflow through the format-family macros is recovered on
// pre-1.94 toolchains, where rust-analyzer no longer expands them and the
// extractor reconstructs the `FormatArgsExpr` (see `rust-toolchain.toml`).

fn source(i: i64) -> String {
    i.to_string()
}

fn sink(_s: String) {}

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
    // these exercise reconstruction of the rest of the family, including the
    // writer-argument handling of `write!`/`writeln!`.
    let a = source(4);
    let b = format_args!("{}", a);
    let c = std::fmt::format(b);
    sink(c); // $ hasTaintFlow=4

    let mut buf1 = String::new();
    let d = source(5);
    let _ = buf1.write_str(d.as_str());
    sink(buf1); // $ hasTaintFlow=5

    let mut buf2 = String::new();
    let e = source(6);
    let _ = buf2.write_fmt(format_args!("{e}"));
    sink(buf2); // $ hasTaintFlow=6

    let mut buf3 = String::new();
    let f = source(7);
    let _ = std::fmt::write(&mut buf3, format_args!("{f}"));
    sink(buf3); // $ hasTaintFlow=7

    use std::fmt::Write;
    let mut buf4 = String::new();
    let g = source(8);
    let _ = write!(buf4, "{}", g);
    sink(buf4); // $ hasTaintFlow=8

    let mut buf5 = String::new();
    let h = source(9);
    let _ = writeln!(buf5, "{h}");
    sink(buf5); // $ hasTaintFlow=9
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
