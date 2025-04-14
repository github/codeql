use regex::Regex;

fn get_value<'h>(key: &str, property: &'h str) -> Option<&'h str> {
    // BAD: User provided `key` is interpolated into the regular expression.
    let pattern = format!(r"^property:{key}=(.*)$");
    let re = Regex::new(&pattern).unwrap();
    re.captures(property)?.get(1).map(|m| m.as_str())
}