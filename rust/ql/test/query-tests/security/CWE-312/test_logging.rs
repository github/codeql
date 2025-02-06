
use log::{debug, error, info, trace, warn, log, Level};
use std::io::Write as _;
use std::fmt::Write as _;

// --- tests ---

fn get_password() -> String {
    "123456".to_string()
}

fn use_password(password: &String) {
    // ...
}

#[derive(Debug)]
struct MyStruct1 {
    harmless: String,
    password: String,
}

impl std::fmt::Display for MyStruct1 {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{} {}", self.harmless, self.password)
    }
}

#[derive(Debug)]
struct MyStruct2 {
    harmless: String,
    password: String,
}

impl std::fmt::Display for MyStruct2 {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{} [REDACTED]", self.harmless) // doesn't output password
    }
}

fn test_log(harmless: String, password: String, encrypted_password: String) {
    // logging macros
    debug!("message = {}", password); // $ Source Alert[rust/cleartext-logging]
    error!("message = {}", password); // $ Source Alert[rust/cleartext-logging]
    info!("message = {}", password); // $ Source Alert[rust/cleartext-logging]
    trace!("message = {}", password); // $ Source Alert[rust/cleartext-logging]
    warn!("message = {}", password); // $ Source Alert[rust/cleartext-logging]
    log!(Level::Error, "message = {}", password); // $ Source Alert[rust/cleartext-logging]

    // debug! macro, various formatting
    debug!("message");
    debug!("message = {}", harmless);
    debug!("message = {}", password); // $ Source Alert[rust/cleartext-logging]
    debug!("message = {}", encrypted_password);
    debug!("message = {} {}", harmless, password); // $ Source Alert[rust/cleartext-logging]
    debug!("message = {harmless}");
    debug!("message = {harmless} {}", password); // $ Source Alert[rust/cleartext-logging]
    debug!("message = {password}"); // $ Source Alert[rust/cleartext-logging]
    debug!("message = {password:?}"); // $ Source Alert[rust/cleartext-logging]
    debug!(target: "target", "message = {}", harmless);
    debug!(target: "target", "message = {}", password); // $ Source Alert[rust/cleartext-logging]
    debug!(target: &password, "message = {}", harmless); // $ Source Alert[rust/cleartext-logging]

    // log! macro, various formatting
    log!(Level::Error, "message = {}", harmless);
    log!(Level::Error, "message = {}", password); // $ Source Alert[rust/cleartext-logging]
    log!(target: "target", Level::Error, "message = {}", harmless);
    log!(target: "target", Level::Error, "message = {}", password); // $ Source Alert[rust/cleartext-logging]
    log!(target: &password, Level::Error, "message = {}", harmless); // $ Source Alert[rust/cleartext-logging]

    // structured logging
    error!(value = 1; "message = {}", harmless);
    error!(value = 1; "message = {}", password); // $ Source Alert[rust/cleartext-logging]
    error!(target: "target", value = 1; "message");
    error!(target: "target", value = 1; "message = {}", password); // $ Source Alert[rust/cleartext-logging]
    error!(target: &password, value = 1; "message"); // $ Source Alert[rust/cleartext-logging]
    error!(value = 1; "message = {}", password); // $ Source Alert[rust/cleartext-logging]
    error!(value = password.as_str(); "message"); // $ MISSING: Alert[rust/cleartext-logging]
    error!(value:? = password.as_str(); "message"); // $ MISSING: Alert[rust/cleartext-logging]

    let value1 = 1;
    error!(value1; "message = {}", harmless);
    error!(value1; "message = {}", password); // $ Source Alert[rust/cleartext-logging]
    error!(target: "target", value1; "message");
    error!(target: "target", value1; "message = {}", password); // $ Source Alert[rust/cleartext-logging]
    error!(target: &password, value1; "message"); // $ Source Alert[rust/cleartext-logging]
    error!(value1; "message = {}", password); // $ Source Alert[rust/cleartext-logging]

    let value2 = password.as_str();
    error!(value2; "message"); // $ MISSING: Alert[rust/cleartext-logging]
    error!(value2:?; "message"); // $ MISSING: Alert[rust/cleartext-logging]

    // pre-formatted
    let m1 = &password; // $ Source=m1
    info!("message = {}", m1); // $ Alert[rust/cleartext-logging]=m1

    let m2 = "message = ".to_string() + &password; // $ Source=m2
    info!("{}", m2); // $ Alert[rust/cleartext-logging]=m2

    let m3 = format!("message = {}", password); // $ Source=m3
    info!("{}", m3); // $  Alert[rust/cleartext-logging]=m3

    let mut m4 = String::new();
    write!(&mut m4, "message = {}", password); // $ MISSING: Source=m4
    info!("{}", m4); // $ MISSING: Alert[rust/cleartext-logging]=m4

    let mut m5 = String::new();
    writeln!(&mut m5, "message = {}", password); // $ MISSING: Source=m5
    info!("{}", m5); // $ MISSING: Alert[rust/cleartext-logging]=m5

    let mut m6 = Vec::new();
    write!(&mut m6, "message = {}", password); // $ MISSING: Source=m6
    info!("{}", std::str::from_utf8(&m6).unwrap()); // $ MISSING: Alert[rust/cleartext-logging]=m6
    unsafe {
        info!("{}", std::str::from_utf8_unchecked(&m6)); // $ MISSING: Alert[rust/cleartext-logging]=m6
    }

    // logging with a call
    trace!("message = {}", get_password()); // $ Source Alert[rust/cleartext-logging]

    let str1 = "123456".to_string();
    trace!("message = {}", &str1); // $ MISSING: Alert[rust/cleartext-logging]
    use_password(&str1); // (proves that `str1` is a password)
    trace!("message = {}", &str1); // $ MISSING: Alert[rust/cleartext-logging]

    let str2 = "123456".to_string();
    trace!("message = {}", &str2);

    // logging from a tuple
    let t1 = (harmless, password); // $ Source=t1
    trace!("message = {}", t1.0);
    trace!("message = {}", t1.1); // $ Alert[rust/cleartext-logging]=t1
    trace!("message = {:?}", t1); // $ MISSING: Alert[rust/cleartext-logging]=t1
    trace!("message = {:#?}", t1); // $ MISSING: Alert[rust/cleartext-logging]=t1

    // logging from a struct
    let s1 = MyStruct1 { harmless: "foo".to_string(), password: "123456".to_string() }; // $ MISSING: Source=s1
    warn!("message = {}", s1.harmless);
    warn!("message = {}", s1.password); // $ MISSING: Alert[rust/cleartext-logging]
    warn!("message = {}", s1); // $ MISSING: Alert[rust/cleartext-logging]=s1
    warn!("message = {:?}", s1); // $ MISSING: Alert[rust/cleartext-logging]=s1
    warn!("message = {:#?}", s1); // $ MISSING: Alert[rust/cleartext-logging]=s1

    let s2 = MyStruct2 { harmless: "foo".to_string(), password: "123456".to_string() }; // $ MISSING: Source=s2
    warn!("message = {}", s2.harmless);
    warn!("message = {}", s2.password); // $ MISSING: Alert[rust/cleartext-logging]
    warn!("message = {}", s2); // (this implementation does not output the password field)
    warn!("message = {:?}", s2); // $ MISSING: Alert[rust/cleartext-logging]=s2
    warn!("message = {:#?}", s2); // $ MISSING: Alert[rust/cleartext-logging]=s2
}

fn test_std(password: String, i: i32, opt_i: Option<i32>) {
    print!("message = {}\n", password); // $ Source Alert[rust/cleartext-logging]
    println!("message = {}", password); // $ Source Alert[rust/cleartext-logging]
    eprint!("message = {}\n", password); // $ Source Alert[rust/cleartext-logging]
    eprintln!("message = {}", password); // $ Source Alert[rust/cleartext-logging]

    match i {
        1 => { panic!("message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        2 => { todo!("message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        3 => { unimplemented!("message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        4 => { unreachable!("message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        5 => { assert!(false, "message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        6 => { assert_eq!(1, 2, "message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        7 => { assert_ne!(1, 1, "message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        8 => { debug_assert!(false, "message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        9 => { debug_assert_eq!(1, 2, "message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        10 => { debug_assert_ne!(1, 1, "message = {}", password); } // $ Source Alert[rust/cleartext-logging]
        11 => { _ = opt_i.expect(format!("message = {}", password).as_str()); } // $ Source Alert[rust/cleartext-logging]
        _ => {}
    }

    std::io::stdout().lock().write_fmt(format_args!("message = {}\n", password)); // $ MISSING: Alert[rust/cleartext-logging]
    std::io::stderr().lock().write_fmt(format_args!("message = {}\n", password)); // $ MISSING: Alert[rust/cleartext-logging]
    std::io::stdout().lock().write(format!("message = {}\n", password).as_bytes()); // $ Source Alert[rust/cleartext-logging]
    std::io::stdout().lock().write_all(format!("message = {}\n", password).as_bytes()); // $ Source Alert[rust/cleartext-logging]

    let mut out = std::io::stdout().lock();
    out.write(format!("message = {}\n", password).as_bytes()); // $ Source Alert[rust/cleartext-logging]

    let mut err = std::io::stderr().lock();
    err.write(format!("message = {}\n", password).as_bytes()); // $ Source Alert[rust/cleartext-logging]
}

fn main() {
    simple_logger::SimpleLogger::new().init().unwrap();

    test_log("harmless".to_string(), "123456".to_string(), "[encrypted]".to_string());
    test_std("123456".to_string(), 0, None);
}
