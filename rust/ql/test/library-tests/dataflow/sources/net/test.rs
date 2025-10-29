fn sink<T>(_: T) { }

// --- tests ---

use std::io::{Read, Write, BufRead};
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use http_body_util::BodyExt;
use std::net::ToSocketAddrs;

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
    sink(remote_string5); // $ hasTaintFlow="example.com"

    let remote_string6 = reqwest::get("example.com").await?.bytes().await?; // $ Alert[rust/summary/taint-sources]
    sink(remote_string6); // $ hasTaintFlow="example.com"

    let mut request1 = reqwest::get("example.com").await?; // $ Alert[rust/summary/taint-sources]
    sink(request1.chunk().await?.unwrap()); // $ hasTaintFlow="example.com"
    while let Some(chunk) = request1.chunk().await? {
        sink(chunk); // $ hasTaintFlow="example.com"
    }

    Ok(())
}

async fn test_hyper_http(case: i64) -> Result<(), Box<dyn std::error::Error>> {
    // using http + hyper libs to fetch a web page
    let address = "example.com:80";
    let url = "http://example.com/";

    // create the connection
    println!("connecting to {}...", address);
    let stream = tokio::net::TcpStream::connect(address).await?; // $ Alert[rust/summary/taint-sources]
    let io = hyper_util::rt::TokioIo::new(stream);
    let (sender, conn) = hyper::client::conn::http1::handshake(io).await?;
    let mut sender: hyper::client::conn::http1::SendRequest<String> = sender;

    // drive the HTTP connection
    tokio::task::spawn(async move {
        conn.await.expect("connection failed");
    });

    // make the request
    println!("sending request...");
    if case == 0 {
        // simple flow case
        let request = http::Request::builder().uri(url).body(String::from(""))?;
        let response = sender.send_request(request).await?; // $ Alert[rust/summary/taint-sources]
        sink(&response); // $ hasTaintFlow=request
        sink(response); // $ hasTaintFlow=request
        return Ok(())
    }
    // more realistic uses of results...
    let request = http::Request::builder().uri(url).body(String::from(""))?;
    let mut response = sender.send_request(request).await?; // $ Alert[rust/summary/taint-sources]
    sink(&response); // $ hasTaintFlow=request

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

async fn test_std_tcpstream(case: i64) -> std::io::Result<()> {
    // using std::net to fetch a web page
    let address = "example.com:80";

    if case == 1 {
        // create the connection
        let mut stream = std::net::TcpStream::connect(address)?; // $ Alert[rust/summary/taint-sources]

        // send request
        let _ = stream.write_all(b"GET / HTTP/1.1\nHost:example.com\n\n");

        // read response
        let mut buffer = vec![0; 32 * 1024];
        let _ = stream.read(&mut buffer);

        println!("data = {:?}", buffer);
        sink(&buffer); // $ hasTaintFlow=address
        sink(buffer[0]); // $ hasTaintFlow=address

        let buffer_string = String::from_utf8_lossy(&buffer);
        println!("string = {}", buffer_string);
        sink(buffer_string); // $ MISSING: hasTaintFlow
    } else {
        // create the connection
        let sock_addr = address.to_socket_addrs().unwrap().next().unwrap();
        let mut stream = std::net::TcpStream::connect_timeout(&sock_addr, std::time::Duration::new(1, 0))?; // $ Alert[rust/summary/taint-sources]

        // send request
        let _ = stream.write_all(b"GET / HTTP/1.1\nHost:example.com\n\n");

        // read response
        match case {
            2 => {
                let mut reader = std::io::BufReader::new(stream).take(256);
                let mut line = String::new();
                loop {
                    match reader.read_line(&mut line) {
                        Ok(0) => {
                            println!("end");
                            break;
                        }
                        Ok(_n) => {
                            println!("line = {}", line);
                            sink(&line); // $ hasTaintFlow=&sock_addr
                            line.clear();
                        }
                        Err(e) => {
                            println!("error: {}", e);
                            break;
                        }
                    }
                }
            }
            3 => {
                let reader = std::io::BufReader::new(stream.try_clone()?).take(256);
                for line in reader.lines() { // $ MISSING: Alert[rust/summary/taint-sources]
                    if let Ok(string) = line {
                        println!("line = {}", string);
                        sink(string); // $ MISSING: hasTaintFlow
                    }
                }
            }
            _ => {}
        }
    }

    Ok(())
}

async fn test_tokio_tcpstream(case: i64) -> std::io::Result<()> {
    // using tokio::io to fetch a web page
    let address = "example.com:80";

    // create the connection
    println!("connecting to {}...", address);
    let mut tokio_stream = tokio::net::TcpStream::connect(address).await?; // $ Alert[rust/summary/taint-sources]

    // send request
    tokio_stream.write_all(b"GET / HTTP/1.1\nHost:example.com\n\n").await?;

    if case == 1 {
        // peek response
        let mut buffer1 = vec![0; 2 * 1024];
        let _ = tokio_stream.peek(&mut buffer1).await?;

        // read response
        let mut buffer2 = vec![0; 2 * 1024];
        let n2 = tokio_stream.read(&mut buffer2).await?;

        println!("buffer1 = {:?}", buffer1);
        sink(&buffer1); // $ hasTaintFlow=address
        sink(buffer1[0]); // $ hasTaintFlow=address

        println!("buffer2 = {:?}", buffer2);
        sink(&buffer2); // $ hasTaintFlow=address
        sink(buffer2[0]); // $ hasTaintFlow=address

        let buffer_string = String::from_utf8_lossy(&buffer2[..n2]);
        println!("string = {}", buffer_string);
        sink(buffer_string); // $ MISSING: hasTaintFlow
    } else if case == 2 {
        let mut buffer = [0; 2 * 1024];
        loop {
            match tokio_stream.try_read(&mut buffer) {
                Ok(0) => {
                    println!("end");
                    break;
                }
                Ok(_n) => {
                    println!("buffer = {:?}", buffer);
                    sink(&buffer); // $ hasTaintFlow=address
                    break; // (or we could wait for more data)
                }
                Err(ref e) if e.kind() == std::io::ErrorKind::WouldBlock => {
                    // wait...
                    continue;
                }
                Err(e) => {
                    println!("error: {}", e);
                    break;
                }
            }
        }
    } else {
        let mut buffer = Vec::new();
        loop {
            match tokio_stream.try_read_buf(&mut buffer) {
                Ok(0) => {
                    println!("end");
                    break;
                }
                Ok(_n) => {
                    println!("buffer = {:?}", buffer);
                    sink(&buffer); // $ hasTaintFlow=address
                    break; // (or we could wait for more data)
                }
                Err(ref e) if e.kind() == std::io::ErrorKind::WouldBlock => {
                    // wait...
                    continue;
                }
                Err(e) => {
                    println!("error: {}", e);
                    break;
                }
            }
        }
    }

    Ok(())
}

async fn test_std_to_tokio_tcpstream() -> std::io::Result<()> {
    // using std::net and tokio::net together to fetch a web page
    let address = "example.com:80";

    // create the connection
    println!("connecting to {}...", address);
    let std_stream = std::net::TcpStream::connect(address)?; // $ Alert[rust/summary/taint-sources]

    // convert to tokio stream
    std_stream.set_nonblocking(true)?;
    let mut tokio_stream = tokio::net::TcpStream::from_std(std_stream)?;

    // send request
    tokio_stream.write_all(b"GET / HTTP/1.1\nHost:example.com\n\n").await?;

    // read response
    let mut buffer = vec![0; 32 * 1024];
    let _n = tokio_stream.read(&mut buffer).await?; // $ MISSING: Alert[rust/summary/taint-sources]

    println!("data = {:?}", buffer);
    sink(&buffer); // $ MISSING: hasTaintFlow
    sink(buffer[0]); // $ MISSING: hasTaintFlow

    Ok(())
}

fn test_rustls() -> std::io::Result<()> {
    let config = rustls::ClientConfig::builder()
        .with_root_certificates(rustls::RootCertStore::empty())
        .with_no_client_auth();
    let server_name = rustls::pki_types::ServerName::try_from("www.example.com").unwrap();
    let config_arc = std::sync::Arc::new(config);
    let mut client = rustls::ClientConnection::new(config_arc, server_name).unwrap(); // $ Alert[rust/summary/taint-sources]
    let mut reader = client.reader(); // We cannot resolve the `reader` call because it comes from `Deref`: https://docs.rs/rustls/latest/rustls/client/struct.ClientConnection.html#deref-methods-ConnectionCommon%3CClientConnectionData%3E
    sink(&reader); // $ MISSING: hasTaintFlow=config_arc

    {
        let mut buffer = [0u8; 100];
        let _bytes = reader.read(&mut buffer)?;
        sink(&buffer); // $ MISSING: hasTaintFlow=config_arc
    }

    {
        let mut buffer = Vec::<u8>::new();
        let _bytes = reader.read_to_end(&mut buffer)?;
        sink(&buffer); // $ MISSING: hasTaintFlow=config_arc
    }

    {
        let mut buffer = String::new();
        let _bytes = reader.read_to_string(&mut buffer)?;
        sink(&buffer); // $ MISSING: hasTaintFlow=config_arc
    }

    Ok(())
}

mod futures_rustls {
    use async_std::net::TcpStream;
    use async_std::sync::Arc;
    use futures::io::AsyncBufRead;
    use futures::io::AsyncBufReadExt;
    use futures::io::AsyncRead;
    use futures::io::AsyncReadExt;
    use futures::StreamExt;
    use futures_rustls::TlsConnector;
    use std::io;
    use std::pin::Pin;
    use std::task::{Context, Poll};
    use super::sink;

    pub async fn test_futures_rustls_futures_io() -> io::Result<()> {
        let url = "www.example.com:443";
        let tcp = TcpStream::connect(url).await?; // $ Alert[rust/summary/taint-sources]
        sink(&tcp); // $ hasTaintFlow=url
        let config = rustls::ClientConfig::builder()
            .with_root_certificates(rustls::RootCertStore::empty())
            .with_no_client_auth();
        let connector = TlsConnector::from(Arc::new(config));
        let server_name = rustls::pki_types::ServerName::try_from("www.example.com").unwrap();
        let mut reader = connector.connect(server_name, tcp).await?;
        sink(&reader); // $ hasTaintFlow=url

        {
            // using the `AsyncRead` trait (low-level)
            let mut buffer = [0u8; 64];
            let mut pinned = Pin::new(&mut reader);
            sink(&pinned); // $ hasTaintFlow=url
            let mut cx = Context::from_waker(futures::task::noop_waker_ref());
            let bytes_read = pinned.poll_read(&mut cx, &mut buffer);
            if let Poll::Ready(Ok(n)) = bytes_read {
                sink(&buffer); // $ hasTaintFlow=url
                sink(&buffer[..n]); // $ hasTaintFlow=url
            }
        }

        {
            // using the `AsyncReadExt::read` extension method (higher-level)
            let mut buffer1 = [0u8; 64];
            let bytes_read1 = futures::io::AsyncReadExt::read(&mut reader, &mut buffer1).await?;
            sink(&buffer1[..bytes_read1]); // $ hasTaintFlow=url

            let mut buffer2 = [0u8; 64];
            let bytes_read2 = reader.read(&mut buffer2).await?;

            sink(&buffer2[..bytes_read2]); // $ hasTaintFlow=url
        }

        let mut reader2 = futures::io::BufReader::new(reader);
        sink(&reader2); // $ hasTaintFlow=url

        {
            // using the `AsyncBufRead` trait (low-level)
            let mut pinned = Pin::new(&mut reader2);
            sink(&pinned); // $ hasTaintFlow=url
            let mut cx = Context::from_waker(futures::task::noop_waker_ref());
            let buffer = pinned.poll_fill_buf(&mut cx);
            if let Poll::Ready(Ok(buf)) = buffer {
                sink(&buffer); // $ hasTaintFlow=url
                sink(buf); // $ hasTaintFlow=url
            }

            // using the `AsyncBufRead` trait (alternative syntax)
            let buffer2 = Pin::new(&mut reader2).poll_fill_buf(&mut cx);
            match (buffer2) {
                Poll::Ready(Ok(buf)) => {
                    sink(&buffer2); // $ hasTaintFlow=url
                    sink(buf); // $ hasTaintFlow=url
                }
                _ => {
                    // ...
                }
            }
        }

        {
            // using the `AsyncBufReadExt::fill_buf` extension method (higher-level)
            let buffer = reader2.fill_buf().await?;
            sink(buffer); // $ hasTaintFlow=url
        }

        {
            // using the `AsyncRead` trait (low-level)
            let mut buffer = [0u8; 64];
            let mut pinned = Pin::new(&mut reader2);
            sink(&pinned); // $ hasTaintFlow=url
            let mut cx = Context::from_waker(futures::task::noop_waker_ref());
            let bytes_read = pinned.poll_read(&mut cx, &mut buffer);
            sink(&buffer); // $ hasTaintFlow=url
            if let Poll::Ready(Ok(n)) = bytes_read {
                sink(&buffer[..n]); // $ hasTaintFlow=url
            }
        }

        {
            // using the `AsyncReadExt::read` extension method (higher-level)
            let mut buffer1 = [0u8; 64];
            let bytes_read1 = futures::io::AsyncReadExt::read(&mut reader2, &mut buffer1).await?;
            sink(&buffer1[..bytes_read1]); // $ hasTaintFlow=url

            let mut buffer2 = [0u8; 64];
            let bytes_read2 = reader2.read(&mut buffer2).await?;
            sink(&buffer2[..bytes_read2]); // $ hasTaintFlow=url
        }

        {
            // using the `AsyncBufRead` trait (low-level)
            let mut pinned = Pin::new(&mut reader2);
            sink(&pinned); // $ hasTaintFlow=url
            let mut cx = Context::from_waker(futures::task::noop_waker_ref());
            let buffer = pinned.poll_fill_buf(&mut cx);
            sink(&buffer); // $ hasTaintFlow=url
            if let Poll::Ready(Ok(buf)) = buffer {
                sink(buf); // $ hasTaintFlow=url
            }
        }

        {
            // using the `AsyncBufReadExt::fill_buf` extension method (higher-level)
            let buffer = reader2.fill_buf().await?;
            sink(buffer); // $ hasTaintFlow=url
        }

        {
            // using the `AsyncBufReadExt::read_until` extension method
            let mut line = Vec::new();
            let _bytes_read = reader2.read_until(b'\n', &mut line).await?;
            sink(&line); // $ hasTaintFlow=url
        }

        {
            // using the `AsyncBufReadExt::read_line` extension method
            let mut line = String::new();
            let _bytes_read = reader2.read_line(&mut line).await?;
            sink(&line); // $ hasTaintFlow=url
        }

        {
            // using the `AsyncBufReadExt::read_to_end` extension method
            let mut buffer = Vec::with_capacity(1024);
            let _bytes_read = reader2.read_to_end(&mut buffer).await?;
            sink(&buffer); // $ hasTaintFlow=url
        }

        {
            // using the `AsyncBufReadExt::lines` extension method
            let mut lines_stream = reader2.lines();
            sink(lines_stream.next().await.unwrap()); // $ MISSING: hasTaintFlow=url
            while let Some(line) = lines_stream.next().await {
                sink(line.unwrap()); // $ MISSING: hasTaintFlow
            }
        }

        Ok(())
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let case = std::env::args().nth(1).unwrap_or(String::from("1")).parse::<i64>().unwrap(); // $ Alert[rust/summary/taint-sources]

    println!("test_reqwest...");
    match futures::executor::block_on(test_reqwest()) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_hyper_http...");
    match futures::executor::block_on(test_hyper_http(case)) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_std_tcpstream...");
    match futures::executor::block_on(test_std_tcpstream(case)) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_tokio_tcpstream...");
    match futures::executor::block_on(test_tokio_tcpstream(case)) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_std_to_tokio_tcpstream...");
    match futures::executor::block_on(test_std_to_tokio_tcpstream()) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_rustls...");
    match test_rustls() {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_futures_rustls_futures_io...");
    match futures::executor::block_on(futures_rustls::test_futures_rustls_futures_io()) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    Ok(())
}
