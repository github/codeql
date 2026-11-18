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
        let _data: UserData = serde_json::from_str(&remote_string).unwrap(); // $ SPURIOUS: Alert[rust/unsafe-deserialization]=remote4
    }
}

fn test_other_deserialization_models() {
    let remote_bytes = reqwest::blocking::get("http://example.com/data") // $ Source=remote5
        .unwrap()
        .bytes()
        .unwrap();
    let remote_string = reqwest::blocking::get("http://example.com/data") // $ Source=remote6
        .unwrap()
        .text()
        .unwrap();

    let _json: UserData = serde_json::from_reader(&remote_bytes[..]).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote5
    let _bincode: Config = bincode::deserialize_from(&remote_bytes[..]).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote5
    let _msgpack_slice: Config = rmp_serde::from_slice(&remote_bytes).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote5
    let _msgpack_reader: Config = rmp_serde::from_read(&remote_bytes[..]).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote5
    let _cbor: Config = ciborium::from_reader(&remote_bytes[..]).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote5
    let _yaml_str: Config = serde_yaml::from_str(&remote_string).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote6
    let _yaml_slice: Config = serde_yaml::from_slice(&remote_bytes).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote5
    let _yaml_reader: Config = serde_yaml::from_reader(&remote_bytes[..]).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote5
    let _toml: Config = toml::from_str(&remote_string).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote6
    let _json_value: String = serde_json::from_value(serde_json::Value::String(remote_string)).unwrap(); // $ Alert[rust/unsafe-deserialization]=remote6
}

mod qhelp_example_bad {
    use serde::Deserialize;

    #[derive(Deserialize)]
    pub struct UserData {
        name: String,
        items: Vec<String>,
    }

    pub fn handle_request(body: &[u8]) -> UserData {
        // BAD: deserializing user-controlled data without size validation
        serde_json::from_slice(body).unwrap() // $ Alert[rust/unsafe-deserialization]=remote7
    }
}

mod qhelp_example_good {
    use serde::Deserialize;

    const MAX_BODY_SIZE: usize = 1024 * 1024; // 1 MB limit

    #[derive(Deserialize)]
    #[serde(deny_unknown_fields)]
    pub struct UserData {
        name: String,
        #[serde(deserialize_with = "bounded_vec")]
        items: Vec<String>,
    }

    fn bounded_vec<'de, D>(deserializer: D) -> Result<Vec<String>, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        let v = Vec::<String>::deserialize(deserializer)?;
        if v.len() > 100 {
            return Err(serde::de::Error::custom("too many items"));
        }
        Ok(v)
    }

    pub fn handle_request(body: &[u8]) -> Result<UserData, String> {
        // GOOD: validate input size before deserialization, use bounded containers
        if body.len() > MAX_BODY_SIZE {
            return Err("payload too large".to_string());
        }
        serde_json::from_slice(body).map_err(|e| e.to_string()) // $ SPURIOUS: Alert[rust/unsafe-deserialization]=remote7
    }
}

fn main() {
    let remote_bytes = reqwest::blocking::get("http://example.com/data") // $ Source=remote7
        .unwrap()
        .bytes()
        .unwrap();

    test_serde_json_deserialization();
    test_bincode_deserialization();
    test_safe_with_validation();
    test_other_deserialization_models();
    let _ = qhelp_example_bad::handle_request(&remote_bytes);
    let _ = qhelp_example_good::handle_request(&remote_bytes);
}
