// GOOD: Certificate validation is enabled (default)

// Using native_tls
let _client = native_tls::TlsConnector::builder()
    .danger_accept_invalid_certs(false) // certificate validation enabled
    .build()
    .unwrap();

// Using reqwest
let _client = reqwest::Client::builder()
    .danger_accept_invalid_certs(false) // certificate validation enabled
    .build()
    .unwrap();

// Or simply use the default builder (safe)
let _client = native_tls::TlsConnector::builder()
    .build()
    .unwrap();
