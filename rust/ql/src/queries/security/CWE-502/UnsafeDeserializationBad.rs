use serde::Deserialize;

#[derive(Deserialize)]
struct UserData {
    name: String,
    items: Vec<String>,
}

fn handle_request(body: &[u8]) -> UserData {
    // BAD: deserializing user-controlled data without size validation
    serde_json::from_slice(body).unwrap()
}
