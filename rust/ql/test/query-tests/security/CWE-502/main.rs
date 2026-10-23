use serde::Deserialize;

#[derive(Deserialize)]
struct UserData {
    name: String,
    items: Vec<String>,
}

#[derive(Deserialize)]
struct Config {
    setting: String,
}

fn test_serde_json_deserialization() {
    let remote_bytes = reqwest::blocking::get("http://example.com/") // $ Source=remote1
        .unwrap()
        .bytes()
        .unwrap();
    let remote_string = reqwest::blocking::get("http://example.com/") // $ Source=remote2
        .unwrap()
        .text()
        .unwrap_or(String::from("{}"));
    let const_string = String::from(r#"{"name": "test", "items": []}"#);

    // --- safe cases ---

    // Constant data deserialization
    let _safe: UserData = serde_json::from_str(&const_string).unwrap(); // safe

    // --- unsafe cases ---

    // Remote bytes directly deserialized
    let _unsafe1: UserData = serde_json::from_slice(&remote_bytes).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote1

    // Remote string directly deserialized
    let _unsafe2: UserData = serde_json::from_str(&remote_string).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote2
}

fn test_bincode_deserialization() {
    let remote_bytes = reqwest::blocking::get("http://example.com/data") // $ Source=remote3
        .unwrap()
        .bytes()
        .unwrap();

    // Unsafe: remote data deserialized with bincode
    let _unsafe: Config = bincode::deserialize(&remote_bytes).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote3
}

fn test_safe_with_validation() {
    let remote_string = reqwest::blocking::get("http://example.com/") // $ Source=remote4
        .unwrap()
        .text()
        .unwrap_or(String::from("{}"));

    // Safe: size check before deserialization (still flagged as the barrier
    // is not modeled as a data flow barrier, but demonstrates the pattern)
    if remote_string.len() < 1024 {
        let _data: UserData = serde_json::from_str(&remote_string).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote4
    }
}

fn main() {
    test_serde_json_deserialization();
    test_bincode_deserialization();
    test_safe_with_validation();
}
