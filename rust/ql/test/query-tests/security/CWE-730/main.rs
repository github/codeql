use regex::Regex;

fn simple_bad(hay: &str) -> Option<bool> {
    let username = std::env::var("USER").unwrap_or("".to_string()); // $ Source=env
    let regex = format!("foo{}bar", username);
    let re = Regex::new(&regex).unwrap(); // $ Alert[rust/regex-injection]=env
    Some(re.is_match(hay))
}

fn simple_good(hay: &str) -> Option<bool> {
    let username = std::env::var("USER").unwrap_or("".to_string());
    let escaped = regex::escape(&username);
    let regex = format!("foo{}bar", escaped);
    let re = Regex::new(&regex).unwrap();
    Some(re.is_match(hay))
}

fn not_a_sink_literal() -> Option<bool> {
    let username = std::env::var("USER").unwrap_or("".to_string());
    let re = Regex::new("literal string").unwrap();
    Some(re.is_match(&username))
}

fn not_a_sink_raw_literal() -> Option<bool> {
    let username = std::env::var("USER").unwrap_or("".to_string());
    let re = Regex::new(r"literal string").unwrap();
    Some(re.is_match(&username))
}

fn main() {
    let hay = "a string";
    simple_bad(hay);
    simple_good(hay);
    not_a_sink_literal();
    not_a_sink_raw_literal();
}
