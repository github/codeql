use std::process::Command;

fn test_std_command_injection() {
    let arg_string = std::env::args().nth(1).unwrap_or(String::from("ls")); // $ Source=args1
    let remote_string = reqwest::blocking::get("http://example.com/") // $ Source=remote1
        .unwrap()
        .text()
        .unwrap_or(String::from("ls"));
    let const_string = String::from("echo hello");

    // --- safe cases ---

    // Constant command and argument
    Command::new("ls")
        .arg("-la")
        .output()
        .expect("failed"); // safe

    // Constant constructed command
    Command::new(const_string.as_str())
        .output()
        .expect("failed"); // safe

    // --- unsafe cases ---

    // User input as the command itself
    Command::new(arg_string.as_str()) // $ Alert[rust/command-line-injection]=args1
        .output()
        .expect("failed");

    // User input as an argument to sh -c
    Command::new("sh")
        .arg("-c")
        .arg(remote_string.as_str()) // $ Alert[rust/command-line-injection]=remote1
        .output()
        .expect("failed");

    // User input as an argument
    Command::new("grep")
        .arg(arg_string.as_str()) // $ Alert[rust/command-line-injection]=args1
        .arg("file.txt")
        .output()
        .expect("failed");

    // Remote input via args()
    Command::new("bash")
        .args(&["-c", remote_string.as_str()]) // $ Alert[rust/command-line-injection]=remote1
        .output()
        .expect("failed");

    // Remote input concatenated into a command
    let concatenated_command = format!("sh -c echo {}", remote_string);
    Command::new(concatenated_command.as_str()) // $ Alert[rust/command-line-injection]=remote1
        .output()
        .expect("failed");
}

async fn test_tokio_command_injection() {
    let remote_string = reqwest::blocking::get("http://example.com/") // $ Source=remote2
        .unwrap()
        .text()
        .unwrap_or(String::from("ls"));

    // Unsafe: remote input as tokio command
    let _output = tokio::process::Command::new(remote_string.as_str()) // $ Alert[rust/command-line-injection]=remote2
        .output()
        .await
        .expect("failed");

    // Unsafe: remote input as tokio command argument
    tokio::process::Command::new("sh")
        .arg("-c")
        .arg(remote_string.as_str()) // $ Alert[rust/command-line-injection]=remote2
        .output()
        .await
        .expect("failed");
}

fn main() {
    test_std_command_injection();
    test_tokio_command_injection();
}
