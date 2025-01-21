
use log::{debug, error, info, trace, warn, log, Level};

// --- tests ---

fn get_password() -> String {
    return "123456".to_string();
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
    debug!("message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    error!("message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    info!("message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    trace!("message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    warn!("message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    log!(Level::Error, "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]

    // debug! macro, various formatting
    debug!("message");
    debug!("message = {}", harmless);
    debug!("message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    debug!("message = {}", encrypted_password);
    debug!("message = {} {}", harmless, password); // $ MISSING: Alert[rust/cleartext-logging]
    debug!("message = {harmless}");
    debug!("message = {harmless} {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    debug!("message = {password}"); // $ MISSING: Alert[rust/cleartext-logging]
    debug!("message = {password:?}"); // $ MISSING: Alert[rust/cleartext-logging]
    debug!(target: "target", "message = {}", harmless);
    debug!(target: "target", "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    debug!(target: &password, "message = {}", harmless); // $ MISSING: Alert[rust/cleartext-logging]

    // log! macro, various formatting
    log!(Level::Error, "message = {}", harmless);
    log!(Level::Error, "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    log!(target: "target", Level::Error, "message = {}", harmless);
    log!(target: "target", Level::Error, "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    log!(target: &password, Level::Error, "message = {}", harmless); // $ MISSING: Alert[rust/cleartext-logging]

    // structured logging
    error!(value = 1; "message = {}", harmless);
    error!(value = 1; "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    error!(target: "target", value = 1; "message");
    error!(target: "target", value = 1; "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    error!(target: &password, value = 1; "message"); // $ MISSING: Alert[rust/cleartext-logging]
    error!(value = 1; "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    error!(value = password.as_str(); "message"); // $ MISSING: Alert[rust/cleartext-logging]
    error!(value:? = password.as_str(); "message"); // $ MISSING: Alert[rust/cleartext-logging]

    let value1 = 1;
    error!(value1; "message = {}", harmless);
    error!(value1; "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    error!(target: "target", value1; "message");
    error!(target: "target", value1; "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]
    error!(target: &password, value1; "message"); // $ MISSING: Alert[rust/cleartext-logging]
    error!(value1; "message = {}", password); // $ MISSING: Alert[rust/cleartext-logging]

    let value2 = password.as_str();
    error!(value2; "message"); // $ MISSING: Alert[rust/cleartext-logging]
    error!(value2:?; "message"); // $ MISSING: Alert[rust/cleartext-logging]

    // pre-formatted
    let m1 = &password; // $ MISSING: Source=m1
    info!("message = {}", m1); // $ MISSING: Alert[rust/cleartext-logging]=m1

    let m2 = "message = ".to_string() + &password; // $ MISSING: Source=m2
    info!("{}", m2); // $ MISSING: Alert[rust/cleartext-logging]=m2

    let m3 = format!("message = {}", password); // $ MISSING:=m3
    info!("{}", m3); // $  MISSING: Alert[rust/cleartext-logging]=m3

    // logging with a call
    trace!("message = {}", get_password()); // $ MISSING: Alert[rust/cleartext-logging]

    let str1 = "123456".to_string();
    trace!("message = {}", &str1); // $ MISSING: Alert[rust/cleartext-logging]
    use_password(&str1); // (proves that `str1` is a password)
    trace!("message = {}", &str1); // $ MISSING: Alert[rust/cleartext-logging]

    let str2 = "123456".to_string();
    trace!("message = {}", &str2);

    // logging from a tuple
    let t1 = (harmless, password); // $ MISSING:=t1
    trace!("message = {}", t1.0);
    trace!("message = {}", t1.1); // $ MISSING: Alert[rust/cleartext-logging]=t1
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
