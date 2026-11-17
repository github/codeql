use std::process::ExitCode;

use clap::Parser;

#[path = "runner.rs"]
mod parser_test;
mod reference_adapter;
#[path = "../../extractor/src/languages/swift/parse.rs"]
mod swift_parse;

fn main() -> ExitCode {
    let options = parser_test::Options::parse();
    match parser_test::run(&options) {
        Ok(true) => ExitCode::SUCCESS,
        Ok(false) => ExitCode::FAILURE,
        Err(error) => {
            eprintln!("error: {error}");
            ExitCode::FAILURE
        }
    }
}
