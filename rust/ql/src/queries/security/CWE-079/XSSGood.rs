use actix_web::{web, HttpResponse, Result};
use askama::Template;

// GOOD: Manual HTML encoding using an `html_escape` function
async fn safe_handler_with_encoding(path: web::Path<String>) -> impl Responder {
    let user_input = path.into_inner();
    let escaped_input = html_escape(&user_input);

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
