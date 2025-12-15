// GOOD: Certificate validation is enabled (default)

let _client = reqwest::Client::builder()
    .danger_accept_invalid_certs(false) // certificate validation enabled explicitly
    .build()
    .unwrap();

let _client = native_tls::TlsConnector::builder() // certificate validation enabled by default
    .build()
    .unwrap();
