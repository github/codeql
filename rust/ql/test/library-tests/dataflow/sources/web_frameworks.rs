#![allow(deprecated)]

fn sink<T>(_: T) { }

// --- tests ---

mod poem_test {
    use poem::{get, handler, web::Path, web::Query, Route, Server, listener::TcpListener};
    use serde::Deserialize;
    use crate::web_frameworks::sink;

    #[handler]
    fn my_poem_handler_1(Path(a): Path<String>) -> String { // $ Alert[rust/summary/taint-sources]
        sink(a.as_str()); // $ MISSING: hasTaintFlow
        sink(a.as_bytes()); // $ MISSING: hasTaintFlow
        sink(a); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    #[handler]
    fn my_poem_handler_2(Path((a, b)): Path<(String, String)>) -> String { // $ Alert[rust/summary/taint-sources]
        sink(a); // $ MISSING: hasTaintFlow
        sink(b); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    #[handler]
    fn my_poem_handler_3(path: Path<(String, String)>) -> String { // $ MISSING: Alert[rust/summary/taint-sources]
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
    fn my_poem_handler_4(Path(MyStruct {a, b}): Path<MyStruct>) -> String { // $ Alert[rust/summary/taint-sources]
        sink(a); // $ MISSING: hasTaintFlow
        sink(b); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    #[handler]
    fn my_poem_handler_5(Path(ms): Path<MyStruct>) -> String { // $ Alert[rust/summary/taint-sources]
        sink(ms.a); // $ MISSING: hasTaintFlow
        sink(ms.b); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    #[handler]
    fn my_poem_handler_6(
        Query(a): Query<String>, // $ Alert[rust/summary/taint-sources]
    ) -> String {
        sink(a); // $ MISSING: hasTaintFlow

        "".to_string()
    }

    async fn test_poem() {
        let app = Route::new()
            .at("/1/:a", get(my_poem_handler_1))
            .at("/2/:a/:b", get(my_poem_handler_2))
            .at("/3/:a/:b", get(my_poem_handler_3))
            .at("/4/:a/:b", get(my_poem_handler_4))
            .at("/4/:a/:b", get(my_poem_handler_5))
            .at("/5/:a/", get(my_poem_handler_6));

        _ = Server::new(TcpListener::bind("0.0.0.0:3000")).run(app).await.unwrap();

        // ...
    }
}
