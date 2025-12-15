use actix_web::{
    get,
    web::{self, Html},
    App, HttpServer, Responder,
};

// The "bad" example from the qldoc
#[get("/bad/{a}")] // $ Source=a
async fn vulnerable_handler(path: web::Path<String>) -> impl Responder {
    let user_input = path.into_inner();

    let html = format!(
        r#"
        <!DOCTYPE html>
        <html>
        <head><title>Welcome</title></head>
        <body>
            <h1>Hello, {}!</h1>
        </body>
        </html>
        "#,
        user_input
    );

    Html::new(html) // $ Alert[rust/xss]=a
}

#[get("/good/{a}")]
// The "good" example from the qldoc
async fn safe_handler_with_encoding(path: web::Path<String>) -> impl Responder {
    let user_input = path.into_inner();
    let escaped_input = html_escape::encode_text(&user_input);

    let html = format!(
        r#"
        <!DOCTYPE html>
        <html>
        <head><title>Welcome</title></head>
        <body>
            <h1>Hello, {}!</h1>
        </body>
        </html>
        "#,
        escaped_input
    );

    Html::new(html) // Safe: user input is HTML-encoded
}

#[actix_web::main]
pub async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(vulnerable_handler)
            .service(safe_handler_with_encoding)
    })
    .bind(("127.0.0.1", 3000))?
    .run()
    .await
}
