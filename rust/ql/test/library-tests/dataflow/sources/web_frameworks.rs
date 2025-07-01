fn sink<T>(_: T) {}

// --- tests ---

mod poem_test {
    use super::sink;
    use poem::{get, handler, listener::TcpListener, web::Path, web::Query, Route, Server};
    use serde::Deserialize;

    #[handler]
    fn my_poem_handler_1(Path(a): Path<String>, // $ Alert[rust/summary/taint-sources]
    ) -> String {
        sink(a.as_str()); // $ MISSING: hasTaintFlow -- no type inference for patterns
        sink(a.as_bytes()); // $ MISSING: hasTaintFlow -- no type inference for patterns
        sink(a); // $ hasTaintFlow

        "".to_string()
    }

    #[handler]
    fn my_poem_handler_2(
        Path((a, b)): Path<(String, String)>, // $ Alert[rust/summary/taint-sources]
    ) -> String {
        sink(a); // $ MISSING: hasTaintFlow
        sink(b); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    #[handler]
    fn my_poem_handler_3(
        path: Path<(String, String)>, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> String {
        sink(&path.0); // $ MISSING: hasTaintFlow
        sink(&path.1); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    #[derive(Deserialize)]
    struct MyStruct {
        a: String,
        b: String,
    }

    #[handler]
    fn my_poem_handler_4(
        Path(MyStruct { a, b }): Path<MyStruct>, // $ Alert[rust/summary/taint-sources]
    ) -> String {
        sink(a); // $ MISSING: hasTaintFlow
        sink(b); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    #[handler]
    fn my_poem_handler_5(
        Path(ms): Path<MyStruct>, // $ Alert[rust/summary/taint-sources]
    ) -> String {
        sink(ms.a); // $ MISSING: hasTaintFlow
        sink(ms.b); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    #[handler]
    fn my_poem_handler_6(
        Query(a): Query<String>, // $ Alert[rust/summary/taint-sources]
    ) -> String {
        sink(a); // $ hasTaintFlow

        "".to_string()
    }

    async fn test_poem() {
        let app = Route::new()
            .at("/1/:a", get(my_poem_handler_1))
            .at("/2/:a/:b", get(my_poem_handler_2))
            .at("/3/:a/:b", get(my_poem_handler_3))
            .at("/4/:a/:b", get(my_poem_handler_4))
            .at("/5/:a/:b", get(my_poem_handler_5))
            .at("/6/:a/", get(my_poem_handler_6));

        Server::new(TcpListener::bind("0.0.0.0:3000"))
            .run(app)
            .await
            .unwrap();

        // ...
    }
}

mod actix_test {
    use super::sink;
    use actix_web::{get, web, App};

    async fn my_actix_handler_1(
        path: web::Path<String>, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> String {
        let a = path.into_inner();
        sink(a.as_str()); // $ MISSING: hasTaintFlow
        sink(a.as_bytes()); // $ MISSING: hasTaintFlow
        sink(a); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    async fn my_actix_handler_2(
        path: web::Path<(String, String)>, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> String {
        let (a, b) = path.into_inner();

        sink(a); // $ MISSING: hasTaintFlow
        sink(b); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    async fn my_actix_handler_3(
        web::Query(a): web::Query<String>, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> String {
        sink(a); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    #[get("/4/{a}")]
    async fn my_actix_handler_4(
        path: web::Path<String>, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> String {
        let a = path.into_inner();
        sink(a); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    async fn test_actix() {
        let app = App::new()
            .route("/1/{a}", web::get().to(my_actix_handler_1))
            .route("/2/{a}/{b}", web::get().to(my_actix_handler_2))
            .route("/3/{a}", web::get().to(my_actix_handler_3))
            .service(my_actix_handler_4);

        // ...
    }
}

mod axum_test {
    use super::sink;
    use axum::extract::{Json, Path, Query, Request};
    use axum::routing::get;
    use axum::Router;
    use std::collections::HashMap;

    async fn my_axum_handler_1(
        Path(a): Path<String>, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> &'static str {
        sink(a.as_str()); // $ MISSING: hasTaintFlow
        sink(a.as_bytes()); // $ MISSING: hasTaintFlow
        sink(a); // $ MISSING: hasTaintFlow

        ""
    }

    async fn my_axum_handler_2(
        Path((a, b)): Path<(String, String)>, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> &'static str {
        sink(a); // $ MISSING: hasTaintFlow
        sink(b); // $ MISSING: hasTaintFlow

        ""
    }

    async fn my_axum_handler_3(
        Query(params): Query<HashMap<String, String>>, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> &'static str {
        for (key, value) in params {
            sink(key); // $ MISSING: hasTaintFlow
            sink(value); // $ MISSING: hasTaintFlow
        }

        ""
    }

    async fn my_axum_handler_4(
        request: Request, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> &'static str {
        sink(request.body()); // $ MISSING: hasTaintFlow
        request.headers().get("header").unwrap(); // $ MISSING: hasTaintFlow
        sink(request.into_body()); // $ MISSING: hasTaintFlow

        ""
    }

    async fn my_axum_handler_5(
        Json(payload): Json<serde_json::Value>, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> &'static str {
        sink(payload.as_str()); // $ MISSING: hasTaintFlow
        sink(payload); // $ MISSING: hasTaintFlow

        ""
    }

    async fn my_axum_handler_6(
        body: String, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> &'static str {
        sink(body); // $ MISSING: hasTaintFlow

        ""
    }

    async fn my_axum_handler_7(
        body: String, // $ MISSING: Alert[rust/summary/taint-sources]
    ) -> &'static str {
        sink(body); // $ MISSING: hasTaintFlow

        ""
    }

    async fn test_axum() {
        let app = Router::<()>::new()
            .route("/1/{a}", get(my_axum_handler_1))
            .route("/2/{a}/{b}", get(my_axum_handler_2))
            .route("/3/:a", get(my_axum_handler_3))
            .route("/4/:a", get(my_axum_handler_4))
            .route("/5/:a", get(my_axum_handler_5))
            .route("/67/:a", get(my_axum_handler_6).get(my_axum_handler_7));

        // ...
    }
}
