use std::env;
use log::info;

fn main() {
    env_logger::init();

    // Get username from command line arguments
    let args: Vec<String> = env::args().collect();
    let username = args.get(1).unwrap_or(&String::from("Guest")).clone();

    // BAD: log message constructed with unsanitized user input
    info!("User login attempt: {}", username);
}
