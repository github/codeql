// BAD: Using HTTP URL which can be intercepted
use reqwest;

fn main() {
    let url = "http://example.com/sensitive-data";
    
    // This makes an insecure HTTP request that can be intercepted
    let response = reqwest::blocking::get(url).unwrap();
    println!("Response: {}", response.text().unwrap());
}