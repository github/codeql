//! Tests for XSS
//! 
use warp::Filter;

#[tokio::main]
pub async fn main() {
    let hello = warp::path("greet")
        .and(warp::path::param())
        .map(|name: String| {
            // Vulnerable to XSS because it directly includes user input in the response
            let body = format!("<h1>Hello, {name}!</h1>");
            warp::reply::html(body) // $ MISSING: Alert[rust/xss]
        });

    // Start the web server on port 3000
    warp::serve(hello).run(([127, 0, 0, 1], 3000)).await;
}
