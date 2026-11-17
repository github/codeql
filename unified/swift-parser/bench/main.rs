use std::error::Error;
use std::hint::black_box;
use std::num::NonZeroUsize;
use std::path::PathBuf;
use std::process::ExitCode;

use clap::Parser as _;
use swift_parser::{
    Child, Diagnostic, NodeFlags, Parser, Span, SyntaxKind, SyntaxSink, TriviaKind,
};

/// Benchmark sequential parsing into a fixed-memory counting/checksum sink.
///
/// UTF-8 sources are loaded once, then parsed repeatedly with one reused Parser.
/// Process startup, input reads, and one summary are included once per invocation.
/// No oracle, JSON, AST construction, or extractor work is performed. Choose
/// --iterations to make each invocation last roughly 0.5-2 seconds, and keep it
/// fixed for comparisons. Relative source paths are relative to the file list.
#[derive(clap::Parser)]
struct Options {
    /// UTF-8 file containing one nonempty source path per line (no glob expansion)
    #[arg(long)]
    file_list: PathBuf,

    /// Number of complete in-memory passes over the sources
    #[arg(long, alias = "repeat", default_value = "1")]
    iterations: NonZeroUsize,
}

#[derive(Default)]
struct Sink {
    nodes: u64,
    trivia: u64,
    diagnostics: u64,
    checksum: u64,
}

impl Sink {
    fn mix(&mut self, value: u64) {
        self.checksum = self.checksum.rotate_left(7).wrapping_add(value);
    }

    fn span(&mut self, span: Span) {
        self.mix(span.start as u64);
        self.mix(span.end as u64);
    }
}

impl SyntaxSink for Sink {
    type Node = u64;

    fn node(
        &mut self,
        kind: SyntaxKind,
        span: Span,
        flags: NodeFlags,
        children: &[Child<Self::Node>],
    ) -> Self::Node {
        self.nodes += 1;
        self.mix(kind as u64);
        self.span(span);
        self.mix(u64::from(flags.is_missing) | (u64::from(flags.is_error) << 1));
        self.mix(children.len() as u64);
        for child in children {
            self.mix(child.field as u64);
            self.mix(child.node);
        }
        self.nodes
    }

    fn trivia(&mut self, kind: TriviaKind, span: Span) {
        self.trivia += 1;
        self.mix(kind as u64);
        self.span(span);
    }

    fn diagnostic(&mut self, diagnostic: Diagnostic) {
        self.diagnostics += 1;
        self.span(diagnostic.span);
        for byte in diagnostic.message.bytes() {
            self.mix(u64::from(byte));
        }
    }
}

fn run(options: &Options) -> Result<(), Box<dyn Error>> {
    let list = std::fs::read_to_string(&options.file_list)?;
    let base = options
        .file_list
        .parent()
        .unwrap_or_else(|| std::path::Path::new("."));
    let mut sources = Vec::new();
    for (index, line) in list.lines().enumerate() {
        if line.is_empty() {
            return Err(format!("empty source path on file-list line {}", index + 1).into());
        }
        let path = base.join(line);
        let source = std::fs::read_to_string(&path)
            .map_err(|error| format!("{}: {error}", path.display()))?;
        sources.push((path, source));
    }
    if sources.is_empty() {
        return Err("file list must contain at least one source path".into());
    }

    let bytes: usize = sources.iter().map(|(_, source)| source.len()).sum();
    let mut parser = Parser::new();
    let mut total = Sink::default();
    for _ in 0..options.iterations.get() {
        for (path, source) in &sources {
            let mut sink = Sink::default();
            let root = parser
                .parse_into(black_box(source.as_str()), &mut sink)
                .map_err(|error| format!("{}: {error}", path.display()))?;
            let sink = black_box(sink);
            total.nodes += sink.nodes;
            total.trivia += sink.trivia;
            total.diagnostics += sink.diagnostics;
            total.mix(sink.checksum);
            total.mix(root);
        }
    }
    println!(
        "files={} bytes={} iterations={} nodes={} trivia={} diagnostics={} checksum={:016x}",
        sources.len(),
        bytes,
        options.iterations,
        total.nodes,
        total.trivia,
        total.diagnostics,
        total.checksum
    );
    Ok(())
}

fn main() -> ExitCode {
    match run(&Options::parse()) {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("error: {error}");
            ExitCode::FAILURE
        }
    }
}
