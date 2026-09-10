use std::process::Command;

fn handle_request(user_input: &str) {
    // BAD: user input is passed directly to a shell command
    Command::new("sh")
        .arg("-c")
        .arg(user_input)
        .output()
        .expect("failed to execute");
}
