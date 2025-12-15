use actix_web::{web, HttpResponse, Result};

// BAD: User input is directly included in HTML response without sanitization
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

    Html::new(html) // Unsafe: User input included directly in the response
}
