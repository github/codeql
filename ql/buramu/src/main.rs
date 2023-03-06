use lazy_static::lazy_static;
use rayon::prelude::*;
use regex::Regex;
use std::collections::HashMap;
use std::{io::BufRead, process::Command};

// A map from filenames to lists of line numbers (for just the lines with deprecations)
type FileDeprecations = HashMap<String, Vec<String>>;

fn get_filename_and_lineno(line: &str) -> (String, String) {
    let mut parts = line.splitn(3, ':');
    let file = parts.next().unwrap().to_string();
    let lineno = parts.next().unwrap().to_string();
    (file, lineno)
}

#[test]
fn test_get_filename_and_lineno() {
    let line = "path/to/file.ql:61:deprecated class Foo = Bar;";
    let (file, lineno) = get_filename_and_lineno(line);
    assert_eq!(file, "path/to/file.ql");
    assert_eq!(lineno, "61");
}

fn get_files_with_deprecations() -> FileDeprecations {
    let output = Command::new("git")
        .args(&[
            "grep",
            "-n",
            "-E",
            "^[^*]*deprecated", // skip lines that have a `*` before `deprecated`, as they are probably comments
            "--",
            "*.ql",
            "*.qll",
        ])
        .output()
        .expect("failed to execute process");
    let mut file_deprecations: FileDeprecations = HashMap::new();
    for line in output.stdout.lines() {
        let (file, lineno) = get_filename_and_lineno(&line.unwrap());
        file_deprecations
            .entry(file)
            .or_insert_with(Vec::new)
            .push(lineno);
    }
    file_deprecations
}

struct LastModifiedLine {
    date: String,
    lineno: String,
}
type LastModifiedMap = HashMap<String, Vec<String>>;

fn get_blame_dates_for_filedeprecation(file: &str, linenos: &[String]) -> LastModifiedMap {
    let mut command = Command::new("git");
    command.arg("blame");
    for lineno in linenos {
        command.arg("-L").arg(format!("{},{}", lineno, lineno));
    }
    command.arg(file);
    let output = command.output().expect("failed to execute process");
    let mut blame_dates = HashMap::new();
    for line in output.stdout.lines() {
        let line = line.unwrap();
        let LastModifiedLine { date, lineno } = get_last_modified(&line);
        blame_dates
            .entry(date)
            .or_insert_with(Vec::new)
            .push(lineno);
    }
    blame_dates
}

lazy_static! {
    static ref BLAME_RE: Regex =
        Regex::new("(\\d{4}-\\d{2}-\\d{2}).*[+-]\\d{4}\\s+(\\d+)\\)").unwrap();
}

fn get_last_modified(line: &str) -> LastModifiedLine {
    let caps = BLAME_RE.captures(line).unwrap();
    let date = caps.get(1).unwrap().as_str().into();
    let lineno = caps.get(2).unwrap().as_str().into();
    LastModifiedLine { date, lineno }
}

#[test]
fn test_get_date_and_lineno() {
    let line = "cc7a9ef97a78 (john doe 2022-08-24 12:59:07 +0200 61) deprecated class Foo = Bar;";
    let LastModifiedLine { date, lineno } = get_last_modified(line);
    assert_eq!(date, "2022-08-24");
    assert_eq!(lineno, "61");
}

fn main() {
    let filedeprecations = get_files_with_deprecations();
    let filedeprecations: Vec<(String, Vec<String>)> = filedeprecations.into_iter().collect();
    println!("today: {}", chrono::Local::now().format("%Y-%m-%d"));
    let deprecations = filedeprecations
        .par_iter()
        .map(|(file, linenos)| (file, get_blame_dates_for_filedeprecation(file, linenos)));
    deprecations.for_each(|(file, linenos_and_dates)| {
        println!("file: {}", file);
        for (date, linenos) in linenos_and_dates.iter() {
            println!("  last_modified: {} {}", date, linenos.join(" "));
        }
    });
}
