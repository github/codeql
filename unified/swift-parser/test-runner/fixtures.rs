use std::process::{Command, ExitCode};

fn main() -> std::io::Result<ExitCode> {
    let status = Command::new(env!("CARGO_BIN_EXE_swift-parser-test"))
        .args(std::env::args_os().skip(1))
        .status()?;
    Ok(if status.success() {
        ExitCode::SUCCESS
    } else {
        ExitCode::FAILURE
    })
}
