use axum::{extract::Query, response::Html, routing::get, Router};

#[derive(serde::Deserialize)]
struct GreetingParams {
    name: String,
}

async fn greet_handler(Query(params): Query<GreetingParams>) -> Html<String> {
    let html_content = format!("<p>Hello, {}!</p>", params.name);
    Html(html_content) // $ Alert[rust/xss]=greet
}

#[tokio::main]
pub async fn main() {
    let app = Router::<()>::new().route("/greet", get(greet_handler)); // $ Source=greet
    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000")
        .await
        .unwrap();
    axum::serve(listener, app).await.unwrap();
}