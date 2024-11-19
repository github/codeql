#![allow(deprecated)]

fn sink<T>(_: T) { }

// --- tests ---

fn test_env_vars() {
    sink(std::env::var("HOME")); // $ MISSING: Alert[rust/summary/taint-sources] hasTaintFlow
    sink(std::env::var_os("PATH")); // $ MISSING: Alert[rust/summary/taint-sources] hasTaintFlow

    let var1 = std::env::var("HOME").expect("HOME not set"); // $ MISSING: Alert[rust/summary/taint-sources]
    let var2 = std::env::var_os("PATH").unwrap(); // $ MISSING: Alert[rust/summary/taint-sources]

    sink(var1); // $ MISSING: hasTaintFlow
    sink(var2); // $ MISSING: hasTaintFlow

    for (key, value) in std::env::vars() { // $ MISSING: Alert[rust/summary/taint-sources]
        sink(key); // $ MISSING: hasTaintFlow
        sink(value); // $ MISSING: hasTaintFlow
    }

    for (key, value) in std::env::vars_os() { // $ MISSING: Alert[rust/summary/taint-sources]
        sink(key); // $ MISSING: hasTaintFlow
        sink(value); // $ MISSING: hasTaintFlow
    }
}

fn test_env_args() {
    let args: Vec<String> = std::env::args().collect(); // $ MISSING: Alert[rust/summary/taint-sources]
    let my_path = &args[0];
    let arg1 = &args[1];
    let arg2 = std::env::args().nth(2).unwrap(); // $ MISSING: Alert[rust/summary/taint-sources]
    let arg3 = std::env::args_os().nth(3).unwrap(); // $ MISSING: Alert[rust/summary/taint-sources]

    sink(my_path); // $ MISSING: hasTaintFlow
    sink(arg1); // $ MISSING: hasTaintFlow
    sink(arg2); // $ MISSING: hasTaintFlow
    sink(arg3); // $ MISSING: hasTaintFlow

    for arg in std::env::args() { // $ MISSING: Alert[rust/summary/taint-sources]
        sink(arg); // $ MISSING: hasTaintFlow
    }

    for arg in std::env::args_os() { // $ MISSING: Alert[rust/summary/taint-sources]
        sink(arg); // $ MISSING: hasTaintFlow
    }
}

fn test_env_dirs() {
    let dir = std::env::current_dir().expect("FAILED"); // $ MISSING: Alert[rust/summary/taint-sources]
    let exe = std::env::current_exe().expect("FAILED"); // $ MISSING: Alert[rust/summary/taint-sources]
    let home = std::env::home_dir().expect("FAILED"); // $ MISSING: Alert[rust/summary/taint-sources]

    sink(dir); // $ MISSING: hasTaintFlow
    sink(exe); // $ MISSING: hasTaintFlow
    sink(home); // $ MISSING: hasTaintFlow
}

async fn test_reqwest() -> Result<(), reqwest::Error> {
    let remote_string1 = reqwest::blocking::get("http://example.com/")?.text()?; // $ MISSING: Alert[rust/summary/taint-sources]
    sink(remote_string1); // $ MISSING: hasTaintFlow

    let remote_string2 = reqwest::blocking::get("http://example.com/").unwrap().text().unwrap(); // $ MISSING: Alert[rust/summary/taint-sources]
    sink(remote_string2); // $ MISSING: hasTaintFlow

    let remote_string3 = reqwest::get("http://example.com/").await?.text().await?; // $ MISSING: Alert[rust/summary/taint-sources]
    sink(remote_string3); // $ MISSING: hasTaintFlow

    Ok(())
}
