use std::env;
use log::{info, warn, error, debug, trace};

fn main() {
    env_logger::init();

    // Sources of user input
    let args: Vec<String> = env::args().collect();
    let username = args.get(1).unwrap_or(&String::from("Guest")).clone(); // $ MISSING: Source=commandargs
    let user_input = std::env::var("USER_INPUT").unwrap_or("default".to_string()); // $ Source=environment
    let remote_data = reqwest::blocking::get("http://example.com/user") // $ Source=remote
        .unwrap().text().unwrap_or("remote_user".to_string());

    // BAD: Direct logging of user input
    info!("User login: {}", username); // $ MISSING: Alert[rust/log-injection]
    warn!("Warning for user: {}", user_input); // $ Alert[rust/log-injection]=environment
    error!("Error processing: {}", remote_data); // $ Alert[rust/log-injection]=remote
    debug!("Debug info: {}", username); // $ MISSING: Alert[rust/log-injection]
    trace!("Trace data: {}", user_input); // $ Alert[rust/log-injection]=environment

    // BAD: Formatted strings with user input
    let formatted_msg = format!("Processing user: {}", username);
    info!("{}", formatted_msg); // $ MISSING: Alert[rust/log-injection]

    // BAD: String concatenation with user input
    let concat_msg = "User activity: ".to_string() + &username;
    info!("{}", concat_msg); // $ MISSING: Alert[rust/log-injection]

    // BAD: Complex formatting
    info!("User {} accessed resource at {}", username, remote_data); // $ Alert[rust/log-injection]=remote

    // GOOD: Sanitized input
    let sanitized_username = username.replace('\n', "").replace('\r', "");
    info!("Sanitized user login: {}", sanitized_username);

    // GOOD: Constant strings
    info!("System startup complete");

    // GOOD: Non-user-controlled data
    let system_time = std::time::SystemTime::now();
    info!("Current time: {:?}", system_time);

    // GOOD: Numeric data derived from user input (not directly logged)
    let user_id = username.len();
    info!("User ID length: {}", user_id);

    // More complex test cases
    test_complex_scenarios(&username, &user_input);
    test_indirect_flows(&remote_data);
}

fn test_complex_scenarios(username: &str, user_input: &str) {
    // BAD: Indirect logging through variables
    let log_message = format!("Activity for {}", username);
    info!("{}", log_message); // $ MISSING: Alert[rust/log-injection]

    // BAD: Through function parameters
    log_user_activity(username); // Function call - should be tracked

    // BAD: Through struct fields
    let user_info = UserInfo { name: username.to_string() };
    info!("User info: {}", user_info.name); // $ MISSING: Alert[rust/log-injection]

    // GOOD: After sanitization
    let clean_input = sanitize_input(user_input);
    info!("Clean input: {}", clean_input);
}

fn log_user_activity(user: &str) {
    info!("User activity: {}", user); // $ MISSING: Alert[rust/log-injection]
}

fn sanitize_input(input: &str) -> String {
    input.replace('\n', "").replace('\r', "").replace('\t', " ")
}

struct UserInfo {
    name: String,
}

fn test_indirect_flows(data: &str) {
    // BAD: Flow through intermediate variables
    let temp_var = data;
    let another_var = temp_var;
    info!("Indirect flow: {}", another_var); // $ MISSING: Alert[rust/log-injection]

    // BAD: Flow through collections
    let data_vec = vec![data];
    if let Some(item) = data_vec.first() {
        info!("Vector item: {}", item); // $ MISSING: Alert[rust/log-injection]
    }

    // BAD: Flow through Option/Result
    let optional_data = Some(data);
    if let Some(unwrapped) = optional_data {
        info!("Unwrapped data: {}", unwrapped); // $ MISSING: Alert[rust/log-injection]
    }
}

// Additional test patterns for different logging scenarios
mod additional_tests {
    use log::*;

    pub fn test_macro_variations() {
        let user_data = std::env::args().nth(1).unwrap_or_default(); // $ Source=commandargs

        // BAD: Different log macro variations
        info!("Info: {}", user_data); // $ Alert[rust/log-injection]=commandargs
        warn!("Warning: {}", user_data); // $ Alert[rust/log-injection]=commandargs
        error!("Error: {}", user_data); // $ Alert[rust/log-injection]=commandargs
        debug!("Debug: {}", user_data); // $ Alert[rust/log-injection]=commandargs
        trace!("Trace: {}", user_data); // $ Alert[rust/log-injection]=commandargs

        // BAD: Complex format strings
        info!("User {} did action {} at time {}", user_data, "login", "now"); // $ Alert[rust/log-injection]=commandargs
    }

    pub fn test_println_patterns() {
        let user_data = std::env::var("USER").unwrap_or_default(); // $ Source=environment

        // These might not be caught depending on model coverage, but are potential logging sinks
        println!("User: {}", user_data); // $ Alert[rust/log-injection]=environment
        eprintln!("Error for user: {}", user_data); // $ Alert[rust/log-injection]=environment
    }
}
