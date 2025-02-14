#![allow(deprecated)]

fn sink<T>(_: T) { }

// --- tests ---

fn test_env_vars() {
    sink(std::env::var("HOME")); // $ Alert[rust/summary/taint-sources] hasTaintFlow="HOME"
    sink(std::env::var_os("PATH")); // $ Alert[rust/summary/taint-sources] hasTaintFlow="PATH"

    let var1 = std::env::var("HOME").expect("HOME not set"); // $ Alert[rust/summary/taint-sources]
    let var2 = std::env::var_os("PATH").unwrap(); // $ Alert[rust/summary/taint-sources]

    sink(var1); // $ hasTaintFlow="HOME"
    sink(var2); // $ hasTaintFlow="PATH"

    for (key, value) in std::env::vars() { // $ Alert[rust/summary/taint-sources]
        sink(key); // $ MISSING: hasTaintFlow
        sink(value); // $ MISSING: hasTaintFlow
    }

    for (key, value) in std::env::vars_os() { // $ Alert[rust/summary/taint-sources]
        sink(key); // $ MISSING: hasTaintFlow
        sink(value); // $ MISSING: hasTaintFlow
    }
}

fn test_env_args() {
    let args: Vec<String> = std::env::args().collect(); // $ Alert[rust/summary/taint-sources]
    let my_path = &args[0];
    let arg1 = &args[1];
    let arg2 = std::env::args().nth(2).unwrap(); // $ Alert[rust/summary/taint-sources]
    let arg3 = std::env::args_os().nth(3).unwrap(); // $ Alert[rust/summary/taint-sources]

    sink(my_path); // $ MISSING: hasTaintFlow
    sink(arg1); // $ MISSING: hasTaintFlow
    sink(arg2); // $ MISSING: hasTaintFlow
    sink(arg3); // $ MISSING: hasTaintFlow

    for arg in std::env::args() { // $ Alert[rust/summary/taint-sources]
        sink(arg); // $ hasTaintFlow
    }

    for arg in std::env::args_os() { // $ Alert[rust/summary/taint-sources]
        sink(arg); // $ hasTaintFlow
    }
}

fn test_env_dirs() {
    let dir = std::env::current_dir().expect("FAILED"); // $ Alert[rust/summary/taint-sources]
    let exe = std::env::current_exe().expect("FAILED"); // $ Alert[rust/summary/taint-sources]
    let home = std::env::home_dir().expect("FAILED"); // $ Alert[rust/summary/taint-sources]

    sink(dir); // $ hasTaintFlow
    sink(exe); // $ hasTaintFlow
    sink(home); // $ hasTaintFlow
}

async fn test_reqwest() -> Result<(), reqwest::Error> {
    let remote_string1 = reqwest::blocking::get("example.com")?.text()?; // $ Alert[rust/summary/taint-sources]
    sink(remote_string1); // $ hasTaintFlow="example.com"

    let remote_string2 = reqwest::blocking::get("example.com").unwrap().text().unwrap(); // $ Alert[rust/summary/taint-sources]
    sink(remote_string2); // $ hasTaintFlow="example.com"

    let remote_string3 = reqwest::blocking::get("example.com").unwrap().text_with_charset("utf-8").unwrap(); // $ Alert[rust/summary/taint-sources]
    sink(remote_string3); // $ hasTaintFlow="example.com"

    let remote_string4 = reqwest::blocking::get("example.com").unwrap().bytes().unwrap(); // $ Alert[rust/summary/taint-sources]
    sink(remote_string4); // $ hasTaintFlow="example.com"

    let remote_string5 = reqwest::get("example.com").await?.text().await?; // $ Alert[rust/summary/taint-sources]
    sink(remote_string5); // $ MISSING: hasTaintFlow

    let remote_string6 = reqwest::get("example.com").await?.bytes().await?; // $ Alert[rust/summary/taint-sources]
    sink(remote_string6); // $ MISSING: hasTaintFlow

    let mut request1 = reqwest::get("example.com").await?; // $ Alert[rust/summary/taint-sources]
    while let Some(chunk) = request1.chunk().await? {
        sink(chunk); // $ MISSING: hasTaintFlow
    }

    Ok(())
}
