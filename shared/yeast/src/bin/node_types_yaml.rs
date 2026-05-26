use clap::Parser;
use std::io::Read;

#[derive(Parser)]
#[clap(
    name = "node-types-yaml",
    about = "Convert between YAML and JSON node-types formats"
)]
struct Cli {
    /// Input file (reads from stdin if not provided)
    input: Option<String>,

    /// Convert from JSON to YAML (default is YAML to JSON)
    #[arg(long)]
    from_json: bool,
}

fn main() {
    let args = Cli::parse();

    let input = match &args.input {
        Some(path) => std::fs::read_to_string(path).unwrap_or_else(|e| {
            eprintln!("Error reading {path}: {e}");
            std::process::exit(1);
        }),
        None => {
            let mut buf = String::new();
            std::io::stdin()
                .read_to_string(&mut buf)
                .unwrap_or_else(|e| {
                    eprintln!("Error reading stdin: {e}");
                    std::process::exit(1);
                });
            buf
        }
    };

    let result = if args.from_json {
        yeast::node_types_yaml::convert_from_json(&input)
    } else {
        yeast::node_types_yaml::convert(&input)
    };

    match result {
        Ok(output) => print!("{output}"),
        Err(e) => {
            eprintln!("Error: {e}");
            std::process::exit(1);
        }
    }
}
