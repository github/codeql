use std::env;
use log::{info, error};

fn main() {
    env_logger::init();
    
    // Get username from command line arguments
    let args: Vec<String> = env::args().collect();
    let username = args.get(1).unwrap_or(&String::from("Guest"));
    
    // BAD: log message constructed with unsanitized user input
    info!("User login attempt: {}", username);
    
    // BAD: another example with error logging
    if username.is_empty() {
        error!("Login failed for user: {}", username);
    }
    
    // BAD: formatted string with user input
    let message = format!("Processing request for user: {}", username);
    info!("{}", message);
}