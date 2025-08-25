use http::Method;
use url::Url;

fn get_with_password_in_url() {
    let password = "Hunter12";
    let url = format!("example.com?password={}", password); // $ Source
    reqwest::blocking::get(url).unwrap().text().unwrap(); // $ Alert[rust/cleartext-transmission]
}

fn get_with_password_in_constructed_url() {
    let password = "Hunter12";
    let address = format!("example.com?password={password}"); // $ Source
    let url = Url::parse(&address).unwrap();
    reqwest::blocking::get(url).unwrap().text().unwrap(); // $ Alert[rust/cleartext-transmission]
}

fn post_with_password_in_url() {
    let password = "Hunter12";
    let url = format!("example.com?password={}", password); // $ Source
    let client = reqwest::Client::new();
    client.post(url).body("body").send(); // $ Alert[rust/cleartext-transmission]
}

fn request_blocking_put_with_password_in_url() {
    let password = "Hunter12";
    let url = format!("example.com?password={}", password); // $ Source
    let client = reqwest::blocking::Client::new();
    client.request(Method::PUT, url).body("body").send(); // $ Alert[rust/cleartext-transmission]
}

fn request_put_with_password_in_url() {
    let password = "Hunter12";
    let url = format!("example.com?password={}", password); // $ Source
    let client = reqwest::Client::new();
    client.request(Method::PUT, url).body("body").send(); // $ Alert[rust/cleartext-transmission]
}

fn main() {
    get_with_password_in_url();
    get_with_password_in_constructed_url();
    post_with_password_in_url();
    request_blocking_put_with_password_in_url();
    request_put_with_password_in_url();
}
