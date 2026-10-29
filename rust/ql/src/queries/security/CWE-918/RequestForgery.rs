// BAD: Endpoint handler that makes requests based on user input
async fn vulnerable_endpoint_handler(req: Request) -> Result<Response> {
    // This request is vulnerable to SSRF attacks as the user controls the
    // entire URL
    let response = reqwest::get(&req.user_url).await;
    
    match response {
        Ok(resp) => {
            let body = resp.text().await.unwrap_or_default();
            Ok(Response {
                message: "Success".to_string(),
                data: body,
            })
        }
        Err(_) => Err("Request failed")
    }
}

// GOOD: Validate user input against an allowlist
async fn secure_endpoint_handler(req: Request) -> Result<Response> {
    // Allow list of specific, known-safe URLs
    let allowed_hosts = ["api.example.com", "trusted-service.com"];
    
    if !allowed_hosts.contains(&req.user_url) {
        return Err("Untrusted domain");
    }
    // This request is safe as the user input has been validated
    let response = reqwest::get(&req.user_url).await;
    match response {
        Ok(resp) => {
            let body = resp.text().await.unwrap_or_default();
            Ok(Response {
                message: "Success".to_string(),
                data: body,
            })
        }
        Err(_) => Err("Request failed")
    }
}
