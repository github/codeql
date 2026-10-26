use std::process::Command;

fn handle_request(filename: &str) {
    // GOOD: user input is checked against an allowlist before passing into a shell command
    let allowed_names = ["report.pdf", "summary.txt", "data.csv"];
    if allowed_names.contains(&filename) {
        Command::new("cat")
            .arg(filename)
            .output()
            .expect("failed to execute");
    }
}
