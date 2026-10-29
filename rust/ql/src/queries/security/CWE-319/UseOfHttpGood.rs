// GOOD: Using HTTPS URL which provides encryption
use reqwest;

fn main() {
    let url = "https://example.com/sensitive-data";
    
    // This makes a secure HTTPS request that is encrypted
    let response = reqwest::blocking::get(url).unwrap();
    println!("Response: {}", response.text().unwrap());
}