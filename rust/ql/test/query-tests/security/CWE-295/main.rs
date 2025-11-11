fn test_native_tls() {
	// unsafe
	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(true) // $ Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_hostnames(true) // $ Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	let _client = native_tls::TlsConnector::builder()
		.min_protocol_version(Some(native_tls::Protocol::Tlsv12))
		.use_sni(true)
		.danger_accept_invalid_certs(true) // $ Alert[rust/disabled-certificate-check]
		.danger_accept_invalid_hostnames(true) // $ Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	// safe
	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(false) // good
		.danger_accept_invalid_hostnames(false) // good
		.build()
		.unwrap();

	// default (safe)
	let _client = native_tls::TlsConnector::builder()
		.build()
		.unwrap();
}

fn test_reqwest() {
	// unsafe
	let _client = reqwest::Client::builder()
		.danger_accept_invalid_certs(true) // $ Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	let _client = reqwest::blocking::ClientBuilder::new()
		.danger_accept_invalid_hostnames(true) // $ Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	let _client = reqwest::ClientBuilder::new()
		.danger_accept_invalid_certs(true) // $ Alert[rust/disabled-certificate-check]
		.danger_accept_invalid_hostnames(true) // $ Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	let _client = reqwest::blocking::Client::builder()
		.tcp_keepalive(std::time::Duration::from_secs(30))
		.https_only(true)
		.danger_accept_invalid_certs(true) // $ Alert[rust/disabled-certificate-check]
		.danger_accept_invalid_hostnames(true) // $ Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	// safe
	let _client = reqwest::blocking::Client::builder()
		.danger_accept_invalid_certs(false) // good
		.danger_accept_invalid_hostnames(false) // good
		.build()
		.unwrap();

	// default (safe)
	let _client = reqwest::blocking::Client::builder()
		.build()
		.unwrap();
}

fn test_data_flow(sometimes_global: bool) {
	let always = true;
	let mut sometimes = true;
	let never = false;

	if rand::random_range(0 .. 2) == 0 {
		sometimes = false;
	}

	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(always) // $ MISSING: Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(sometimes) // $ MISSING: Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(sometimes_global) // $ MISSING: Alert[rust/disabled-certificate-check]
		.build()
		.unwrap();

	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(never) // good
		.build()
		.unwrap();
}

fn main() {
	test_native_tls();
	test_reqwest();
	test_data_flow(true);
	test_data_flow(false);
}
