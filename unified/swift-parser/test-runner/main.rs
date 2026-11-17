use std::process::ExitCode;

use clap::Parser;

#[path = "runner.rs"]
mod parser_test;
#[path = "../../extractor/src/languages/swift/adapter.rs"]
mod reference_adapter;
#[allow(
    unexpected_cfgs,
    reason = "the extractor also supports a swift-syntax feature, unused by this runner"
)]
#[path = "../../extractor/src/languages/swift/parse.rs"]
mod swift_parse;
#[path = "../../extractor/src/languages/swift/rust_parser.rs"]
mod swift_rust_parser;

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
