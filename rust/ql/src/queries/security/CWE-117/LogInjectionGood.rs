use std::env;
use log::info;

fn sanitize_for_logging(input: &str) -> String {
    // Remove newlines and carriage returns to prevent log injection
    input.replace('\n', "").replace('\r', "")
}

fn main() {
    env_logger::init();

    // Get username from command line arguments
    let args: Vec<String> = env::args().collect();
    let username = args.get(1).unwrap_or(&String::from("Guest")).clone();

    // GOOD: log message constructed with sanitized user input
    let sanitized_username = sanitize_for_logging(username.as_str());
    info!("User login attempt: {}", sanitized_username);
}
