use serde::Deserialize;

const MAX_BODY_SIZE: usize = 1024 * 1024; // 1 MB limit

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct UserData {
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

fn handle_request(body: &[u8]) -> Result<UserData, String> {
    // GOOD: validate input size before deserialization, use bounded containers
    if body.len() > MAX_BODY_SIZE {
        return Err("payload too large".to_string());
    }
    serde_json::from_slice(body).map_err(|e| e.to_string())
}
