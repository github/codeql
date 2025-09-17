mod poem_server {
    use poem::{handler, web::Query, Route, Server};

    #[handler]
    async fn endpoint(Query(user_url): Query<String>, // $ Source=user_url
    ) -> String {
        // BAD: The user can control the entire URL
        let response = reqwest::get(&user_url).await; // $ Alert[rust/request-forgery]=user_url

        // If this example is actually executed, forward the response text
        if let Ok(resp) = response {
            return resp.text().await.unwrap_or_default();
        }

        // BAD: The user can control a prefix of the URL
        let url = format!("{}/resource", user_url);
        let _response = reqwest::get(&url).await; // $ Alert[rust/request-forgery]=user_url

        // BAD: The user can control a prefix of the URL - only the protocol is restricted
        let url = format!("https://{}/resource", user_url);
        let _response = reqwest::get(&url).await; // $ Alert[rust/request-forgery]=user_url

        // GOOD: The user can only control a suffix after the hostname, this is likely ok
        let url = format!("https://hostname.com/resource/{}", user_url);
        let _response = reqwest::get(&url).await; // $ SPURIOUS: Alert[rust/request-forgery]=user_url

        let allowed_hosts = ["api.example.com", "trusted-service.com"];

        // GOOD: The URL is guaranteed to be in the allowlist
        if allowed_hosts.contains(&user_url.as_str()) {
            let _response = reqwest::get(&user_url).await; // $ SPURIOUS: Alert[rust/request-forgery]=user_url
        }

        if let Ok(url) = reqwest::Url::parse(&user_url) {
            if let Some(host) = url.host_str() {
                if allowed_hosts.contains(&host) {
                    let _response = reqwest::get(&user_url).await; // $ SPURIOUS: Alert[rust/request-forgery]=user_url
                }
            }
        }

        "".to_string()
    }

    // Function to create the Poem application
    pub async fn create_app() -> Result<(), Box<dyn std::error::Error>> {
        let app = Route::new().at("/fetch", poem::get(endpoint));

        Server::new(poem::listener::TcpListener::bind("127.0.0.1:8080"))
            .run(app)
            .await?;

        Ok(())
    }
}

mod warp_test {
    use warp::Filter;

    #[tokio::main]
    #[rustfmt::skip]
    async fn test_warp() {
        // A route with parameter and `and_then`
        let map_route =
            warp::path::param().and_then(async |a: String| // $ Source=a
            {

            let response = reqwest::get(&a).await; // $ Alert[rust/request-forgery]=a
            match response {
                Ok(resp) => Ok(resp.text().await.unwrap_or_default()),
                Err(_err) => Err(warp::reject::not_found()),
            }
        });
    }
}

/// Start the Poem web application
pub fn start() {
    tokio::runtime::Runtime::new()
        .unwrap()
        .block_on(poem_server::create_app())
        .unwrap();
}
