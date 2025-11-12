// BAD: Disabling certificate validation in Rust

// Using native_tls
let _client = native_tls::TlsConnector::builder()
    .danger_accept_invalid_certs(true) // disables certificate validation
    .build()
    .unwrap();

// Using reqwest
let _client = reqwest::Client::builder()
    .danger_accept_invalid_certs(true) // disables certificate validation
    .build()
    .unwrap();
