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
	let always = true; // $ Source=always
	let mut sometimes = true; // $ Source=sometimes
	let never = false;

	if rand::random_range(0 .. 2) == 0 {
		sometimes = false;
	}

	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(always) // $ Alert[rust/disabled-certificate-check]=always
		.build()
		.unwrap();

	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(sometimes) // $ Alert[rust/disabled-certificate-check]=sometimes
		.build()
		.unwrap();

	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(sometimes_global) // $ Alert[rust/disabled-certificate-check]=arg
		.build()
		.unwrap();

	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_certs(never) // good
		.build()
		.unwrap();
}

fn test_threat_model_source() {
	// hostname setting from `fs` functions returning `bool` directly
	// (these are highly unnatural but serve to create simple tests)

	let b1: bool = std::fs::exists("main.rs").unwrap(); // $ Source=exists
	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_hostnames(b1) // $ Alert[rust/disabled-certificate-check]=exists
		.build()
		.unwrap();

	let b2 = std::path::Path::new("main.rs").metadata().unwrap().is_file(); // $ Source=is_file
	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_hostnames(b2) // $ Alert[rust/disabled-certificate-check]=is_file
		.build()
		.unwrap();

	let b3 = std::fs::metadata("main.rs").unwrap().is_dir(); // $ Source=is_dir
	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_hostnames(b3) // $ Alert[rust/disabled-certificate-check]=is_dir
		.build()
		.unwrap();

	// hostname setting from `stdin`, parsed to `bool`
	// (these are a little closer to something real)

	let mut input_line = String::new();
	let input = std::io::stdin(); // $ Source=stdin
	input.read_line(&mut input_line).unwrap();

	let b4: bool = input_line.parse::<bool>().unwrap_or(false);
	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_hostnames(b4) // $ Alert[rust/disabled-certificate-check]=stdin
		.build()
		.unwrap();

	let b5 = std::str::FromStr::from_str(&input_line).unwrap_or(false);
	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_hostnames(b5) // $ MISSING: Alert[rust/disabled-certificate-check]=stdin
		.build()
		.unwrap();

	let b6 = if (input_line == "true") { true } else { false }; // $ Source=true
	let _client = native_tls::TlsConnector::builder()
		.danger_accept_invalid_hostnames(b6) // $ Alert[rust/disabled-certificate-check]=true
		.build()
		.unwrap();
}

fn main() {
	test_native_tls();
	test_reqwest();
	test_data_flow(true); // $ Source=arg
	test_data_flow(false);
	test_threat_model_source();
}
