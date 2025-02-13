#![allow(deprecated)]

fn sink<T>(_: T) { }

// --- tests ---

fn test_env_vars() {
    sink(std::env::var("HOME")); // $ Alert[rust/summary/taint-sources] hasTaintFlow="HOME"
    sink(std::env::var_os("PATH")); // $ Alert[rust/summary/taint-sources] hasTaintFlow="PATH"

    let var1 = std::env::var("HOME").expect("HOME not set"); // $ Alert[rust/summary/taint-sources]
    let var2 = std::env::var_os("PATH").unwrap(); // $ Alert[rust/summary/taint-sources]

    sink(var1); // $ hasTaintFlow="HOME"
    sink(var2); // $ hasTaintFlow="PATH"

    for (key, value) in std::env::vars() { // $ Alert[rust/summary/taint-sources]
        sink(key); // $ MISSING: hasTaintFlow
        sink(value); // $ MISSING: hasTaintFlow
    }

    for (key, value) in std::env::vars_os() { // $ Alert[rust/summary/taint-sources]
        sink(key); // $ MISSING: hasTaintFlow
        sink(value); // $ MISSING: hasTaintFlow
    }
}

fn test_env_args() {
    let args: Vec<String> = std::env::args().collect(); // $ Alert[rust/summary/taint-sources]
    let my_path = &args[0];
    let arg1 = &args[1];
    let arg2 = std::env::args().nth(2).unwrap(); // $ Alert[rust/summary/taint-sources]
    let arg3 = std::env::args_os().nth(3).unwrap(); // $ Alert[rust/summary/taint-sources]

    sink(my_path); // $ hasTaintFlow
    sink(arg1); // $ hasTaintFlow
    sink(arg2); // $ hasTaintFlow
    sink(arg3); // $ hasTaintFlow

    for arg in std::env::args() { // $ Alert[rust/summary/taint-sources]
        sink(arg); // $ hasTaintFlow
    }

    for arg in std::env::args_os() { // $ Alert[rust/summary/taint-sources]
        sink(arg); // $ hasTaintFlow
    }
}

fn test_env_dirs() {
    let dir = std::env::current_dir().expect("FAILED"); // $ Alert[rust/summary/taint-sources]
    let exe = std::env::current_exe().expect("FAILED"); // $ Alert[rust/summary/taint-sources]
    let home = std::env::home_dir().expect("FAILED"); // $ Alert[rust/summary/taint-sources]

    sink(dir); // $ hasTaintFlow
    sink(exe); // $ hasTaintFlow
    sink(home); // $ hasTaintFlow
}

async fn test_reqwest() -> Result<(), reqwest::Error> {
    let remote_string1 = reqwest::blocking::get("example.com")?.text()?; // $ Alert[rust/summary/taint-sources]
    sink(remote_string1); // $ hasTaintFlow="example.com"

    let remote_string2 = reqwest::blocking::get("example.com").unwrap().text().unwrap(); // $ Alert[rust/summary/taint-sources]
    sink(remote_string2); // $ hasTaintFlow="example.com"

    let remote_string3 = reqwest::blocking::get("example.com").unwrap().text_with_charset("utf-8").unwrap(); // $ Alert[rust/summary/taint-sources]
    sink(remote_string3); // $ hasTaintFlow="example.com"

    let remote_string4 = reqwest::blocking::get("example.com").unwrap().bytes().unwrap(); // $ Alert[rust/summary/taint-sources]
    sink(remote_string4); // $ hasTaintFlow="example.com"

    let remote_string5 = reqwest::get("example.com").await?.text().await?; // $ Alert[rust/summary/taint-sources]
    sink(remote_string5); // $ MISSING: hasTaintFlow

    let remote_string6 = reqwest::get("example.com").await?.bytes().await?; // $ Alert[rust/summary/taint-sources]
    sink(remote_string6); // $ MISSING: hasTaintFlow

    let mut request1 = reqwest::get("example.com").await?; // $ Alert[rust/summary/taint-sources]
    while let Some(chunk) = request1.chunk().await? {
        sink(chunk); // $ MISSING: hasTaintFlow
    }

    Ok(())
}

use std::io::Write;
use http_body_util::BodyExt;

async fn test_hyper_http(case: i64) -> Result<(), Box<dyn std::error::Error>> {
    // using http + hyper libs to fetch a web page
    let address = "example.com:80";
    let url = "http://example.com/";

    // create the connection
    println!("connecting to {}...", address);
    let stream = tokio::net::TcpStream::connect(address).await?;
    let io = hyper_util::rt::TokioIo::new(stream);
    let (mut sender, conn) = hyper::client::conn::http1::handshake(io).await?;

    // drive the HTTP connection
    tokio::task::spawn(async move {
        conn.await.expect("connection failed");
    });

    // make the request
    println!("sending request...");
    if (case == 0) {
        // simple flow case
        let request = http::Request::builder().uri(url).body(String::from(""))?;
        let mut response = sender.send_request(request).await?; // $ Alert[rust/summary/taint-sources]
        sink(&response); // $ hasTaintFlow=request
        sink(response); // $ hasTaintFlow=request
        return Ok(())
    }
    // more realistic uses of results...
    let request = http::Request::builder().uri(url).body(String::from(""))?;
    let mut response = sender.send_request(request).await?; // $ Alert[rust/summary/taint-sources]
    sink(&response); // $ MISSING: hasTaintFlow=request

    if !response.status().is_success() {
        return Err("request failed".into())
    }

    match case {
        1 => {
            sink(response.body()); // $ MISSING: hasTaintFlow
            sink(response.body_mut()); // $ MISSING: hasTaintFlow

            let body = response.into_body();
            sink(&body); // $ MISSING: hasTaintFlow

            println!("awaiting response...");
            let data = body.collect().await?;
            sink(&data); // $ MISSING: hasTaintFlow

            let bytes = data.to_bytes();
            println!("bytes = {:?}", &bytes);
            sink(bytes); // $ MISSING: hasTaintFlow
        }
        2 => {
            println!("streaming response...");
            while let Some(frame) = response.frame().await {
                if let Some(data) = frame?.data_ref() {
                    std::io::stdout().write_all(data)?;
                    sink(data); // $ MISSING: hasTaintFlow
                    sink(data[0]); // $ MISSING: hasTaintFlow
                    for byte in data {
                        sink(byte); // $ MISSING: hasTaintFlow
                    }
                }
            }
        }
        3 => {
            let headers = response.headers();

            if headers.contains_key(http::header::CONTENT_TYPE) {
                println!("CONTENT_TYPE = {}", response.headers()[http::header::CONTENT_TYPE].to_str().unwrap());
                sink(&headers[http::header::CONTENT_TYPE]); // $ MISSING: hasTaintFlow
                sink(headers[http::header::CONTENT_TYPE].to_str().unwrap()); // $ MISSING: hasTaintFlow
                sink(headers[http::header::CONTENT_TYPE].as_bytes()); // $ MISSING: hasTaintFlow
                sink(headers.get(http::header::CONTENT_TYPE).unwrap()); // $ MISSING: hasTaintFlow
            }

            if headers.contains_key("Content-type") {
                println!("Content-type = {}", response.headers().get("Content-type").unwrap().to_str().unwrap());
                sink(headers.get("Content-type").unwrap()); // $ MISSING: hasTaintFlow
                sink(headers.get("Content-type").unwrap().to_str().unwrap()); // $ MISSING: hasTaintFlow
                sink(headers.get("Content-type").unwrap().as_bytes()); // $ MISSING: hasTaintFlow
                sink(&headers["Content-type"]); // $ MISSING: hasTaintFlow
            }

            if headers.contains_key(http::header::COOKIE) {
                sink(response.headers().get(http::header::COOKIE)); // $ MISSING: hasTaintFlow
                for cookie in headers.get_all(http::header::COOKIE) {
                    println!("cookie = {}", cookie.to_str().unwrap());
                    sink(cookie); // $ MISSING: hasTaintFlow
                    sink(cookie.to_str().unwrap()); // $ MISSING: hasTaintFlow
                }
            }

            let (parts, body) = response.into_parts();

            if parts.headers.contains_key(http::header::CONTENT_TYPE) {
                println!("CONTENT_TYPE = {}", parts.headers[http::header::CONTENT_TYPE].to_str().unwrap());
                sink(&parts.headers[http::header::CONTENT_TYPE]); // $ MISSING: hasTaintFlow
                sink(parts.headers[http::header::CONTENT_TYPE].to_str().unwrap()); // $ MISSING: hasTaintFlow
                sink(parts.headers[http::header::CONTENT_TYPE].as_bytes()); // $ MISSING: hasTaintFlow
                sink(parts.headers.get(http::header::CONTENT_TYPE).unwrap()); // $ MISSING: hasTaintFlow
            }

            sink(body); // $ MISSING: hasTaintFlow
        }
        _ => {}
    }

    Ok(())
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let case = std::env::args().nth(1).unwrap_or(String::from("1")).parse::<i64>().unwrap(); // $ Alert[rust/summary/taint-sources]

    println!("test_hyper_http...");
    match futures::executor::block_on(test_hyper_http(case)) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }
    println!("");

    Ok(())
}
