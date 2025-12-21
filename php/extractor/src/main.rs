use clap::Parser;

mod autobuilder;
mod extractor;
mod generator;

#[derive(Parser)]
#[command(author, version, about)]
enum Cli {
    Extract(extractor::Options),
    Generate(generator::Options),
    Autobuild(autobuilder::Options),
}

fn main() -> std::io::Result<()> {
    let cli = Cli::parse();

    match cli {
        Cli::Extract(options) => extractor::run(options),
        Cli::Generate(options) => generator::run(options),
        Cli::Autobuild(options) => autobuilder::run(options),
    }
}
