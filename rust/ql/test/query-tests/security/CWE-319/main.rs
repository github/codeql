use reqwest;
use std::env;

fn main() {
    test_direct_literals();
    test_dynamic_urls();
    test_localhost_exemptions();
}

fn test_direct_literals() {
    // BAD: Direct HTTP URLs that should be flagged
    let _response1 = reqwest::blocking::get("http://example.com/api").unwrap(); // $ Alert[rust/non-https-url]
    let _response2 = reqwest::blocking::get("HTTP://EXAMPLE.COM/API").unwrap(); // $ Alert[rust/non-https-url]
    let _response3 = reqwest::blocking::get("http://api.example.com/data").unwrap(); // $ Alert[rust/non-https-url]

    // GOOD: HTTPS URLs that should not be flagged
    let _response3 = reqwest::blocking::get("https://example.com/api").unwrap();
    let _response4 = reqwest::blocking::get("https://api.example.com/data").unwrap();
}

fn test_dynamic_urls() {
    // BAD: HTTP URLs constructed dynamically
    let base_url = "http://example.com"; // $ Source
    let endpoint = "/api/users";
    let full_url = format!("{}{}", base_url, endpoint);
    let _response = reqwest::blocking::get(&full_url).unwrap(); // $ Alert[rust/non-https-url]

    // GOOD: HTTPS URLs constructed dynamically
    let secure_base = "https://example.com";
    let secure_full = format!("{}{}", secure_base, endpoint);
    let _secure_response = reqwest::blocking::get(&secure_full).unwrap();

    // BAD: HTTP protocol string
    let protocol = "http://"; // $ Source
    let host = "api.example.com";
    let insecure_url = format!("{}{}", protocol, host);
    let _insecure_response = reqwest::blocking::get(&insecure_url).unwrap(); // $ Alert[rust/non-https-url]

    // GOOD: HTTPS protocol string
    let secure_protocol = "https://";
    let secure_url = format!("{}{}", secure_protocol, host);
    let _secure_response2 = reqwest::blocking::get(&secure_url).unwrap();
}

fn test_localhost_exemptions() {
    // GOOD: localhost URLs should not be flagged (local development)
    let _local1 = reqwest::blocking::get("http://localhost:8080/api").unwrap();
    let _local2 = reqwest::blocking::get("HTTP://LOCALHOST:8080/api").unwrap();
    let _local3 = reqwest::blocking::get("http://127.0.0.1:3000/test").unwrap();
    let _local4 = reqwest::blocking::get("http://192.168.1.100/internal").unwrap();
    let _local5 = reqwest::blocking::get("http://10.0.0.1/admin").unwrap();
    let _local6 = reqwest::blocking::get("http://172.16.0.0/foo").unwrap();
    let _local7 = reqwest::blocking::get("http://172.31.255.255/bar").unwrap();

    // GOOD: test IPv6 localhost variants
    let _local8 = reqwest::blocking::get("http://[::1]:8080/api").unwrap();
    let _local9 = reqwest::blocking::get("http://[0:0:0:0:0:0:0:1]/test").unwrap();

    // BAD: non-private IP address
    let _local10 = reqwest::blocking::get("http://172.32.0.0/baz").unwrap(); // $ Alert[rust/non-https-url]

}

// Additional test cases that mirror the Bad/Good examples
fn test_examples() {
    // From UseOfHttpBad.rs - BAD case
    {
        let url = "http://example.com/sensitive-data"; // $ Source

        // This makes an insecure HTTP request that can be intercepted
        let response = reqwest::blocking::get(url).unwrap(); // $ Alert[rust/non-https-url]
        println!("Response: {}", response.text().unwrap());
    }

    // From UseOfHttpGood.rs - GOOD case
    {
        let url = "https://example.com/sensitive-data";

        // This makes a secure HTTPS request that is encrypted
        let response = reqwest::blocking::get(url).unwrap();
        println!("Response: {}", response.text().unwrap());
    }
}
