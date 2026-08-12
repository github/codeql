use std::process::Command;

fn handle_request(filename: &str) {
    // GOOD: use a fixed command with the user input as a separate argument,
    // avoiding shell interpretation
    let allowed_names = ["report.pdf", "summary.txt", "data.csv"];
    if allowed_names.contains(&filename) {
        Command::new("cat")
            .arg(filename)
            .output()
            .expect("failed to execute");
    }
}
