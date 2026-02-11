use regex::{escape, Regex};

fn get_value<'h>(key: &str, property: &'h str) -> option<&'h str> {
    // GOOD: User input is escaped before being used in the regular expression.
    let escaped_key = escape(key);
    let pattern = format!(r"^property:{escaped_key}=(.*)$");
    let re = regex::new(&pattern).unwrap();
    re.captures(property)?.get(1).map(|m| m.as_str())
}