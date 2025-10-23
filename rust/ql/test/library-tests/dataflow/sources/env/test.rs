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
    let arg4 = std::env::args().nth(4).unwrap().parse::<usize>().unwrap(); // $ Alert[rust/summary/taint-sources]

    sink(my_path); // $ hasTaintFlow
    sink(arg1); // $ hasTaintFlow
    sink(arg2); // $ hasTaintFlow
    sink(arg3); // $ hasTaintFlow
    sink(arg4); // $ hasTaintFlow

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

async fn main() -> () {
    println!("test_env_vars...");
    test_env_vars();

    println!("test_env_args...");
    test_env_args();

    println!("test_env_dirs...");
    test_env_dirs();
}
