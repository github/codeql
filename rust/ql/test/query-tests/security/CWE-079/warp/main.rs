use warp::Filter;

#[tokio::main]
pub async fn main() {
    let hello = warp::path("greet")
        .and(warp::path::param())
        .map(|name: String| { // $ Source=name
            // Vulnerable to XSS because it directly includes user input in the response
            let body = format!("<h1>Hello, {name}!</h1>");
            warp::reply::html(body) // $ Alert[rust/xss]=name
        });

    // Start the web server on port 3000
    warp::serve(hello).run(([127, 0, 0, 1], 3000)).await;
}
