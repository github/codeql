// BAD: Disabling certificate validation in Rust

let _client = reqwest::Client::builder()
    .danger_accept_invalid_certs(true) // disables certificate validation
    .build()
    .unwrap();
