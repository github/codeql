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
    let arg4 = std::env::args().nth(4).unwrap().parse::<usize>().unwrap(); // $ Alert[rust/summary/taint-sources]

    sink(my_path); // $ hasTaintFlow
    sink(arg1); // $ hasTaintFlow
    sink(arg2); // $ hasTaintFlow
    sink(arg3); // $ hasTaintFlow
    sink(arg4); // $ hasTaintFlow

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
    sink(remote_string5); // $ hasTaintFlow="example.com"

    let remote_string6 = reqwest::get("example.com").await?.bytes().await?; // $ Alert[rust/summary/taint-sources]
    sink(remote_string6); // $ hasTaintFlow="example.com"

    let mut request1 = reqwest::get("example.com").await?; // $ Alert[rust/summary/taint-sources]
    sink(request1.chunk().await?.unwrap()); // $ hasTaintFlow="example.com"
    while let Some(chunk) = request1.chunk().await? {
        sink(chunk); // $ MISSING: hasTaintFlow="example.com"
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
    let stream = tokio::net::TcpStream::connect(address).await?; // $ Alert[rust/summary/taint-sources]
    let io = hyper_util::rt::TokioIo::new(stream);
    let (mut sender, conn) = hyper::client::conn::http1::handshake(io).await?;

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

use std::io::Read;
use std::io::BufRead;

fn test_io_stdin() -> std::io::Result<()> {
    // --- stdin ---

    {
        let mut buffer = [0u8; 100];
        let _bytes = std::io::stdin().read(&mut buffer)?; // $ Alert[rust/summary/taint-sources]
        sink(&buffer); // $ hasTaintFlow
    }

    {
        let mut buffer = Vec::<u8>::new();
        let _bytes = std::io::stdin().read_to_end(&mut buffer)?; // $ Alert[rust/summary/taint-sources]
        sink(&buffer); // $ MISSING: hasTaintFlow
    }

    {
        let mut buffer = String::new();
        let _bytes = std::io::stdin().read_to_string(&mut buffer)?; // $ Alert[rust/summary/taint-sources]
        sink(&buffer); // $ hasTaintFlow
    }

    {
        let mut buffer = String::new();
        let _bytes = std::io::stdin().lock().read_to_string(&mut buffer)?; // $ Alert[rust/summary/taint-sources]
        sink(&buffer); // $ hasTaintFlow
    }

    {
        let mut buffer = [0; 100];
        std::io::stdin().read_exact(&mut buffer)?; // $ Alert[rust/summary/taint-sources]
        sink(&buffer); // $ hasTaintFlow
    }

    for byte in std::io::stdin().bytes() { // $ Alert[rust/summary/taint-sources]
        sink(byte); // $ hasTaintFlow
    }

    // --- BufReader ---

    {
        let mut reader = std::io::BufReader::new(std::io::stdin()); // $ Alert[rust/summary/taint-sources]
        let data = reader.fill_buf()?;
        sink(&data); // $ hasTaintFlow
    }

    {
        let reader = std::io::BufReader::new(std::io::stdin()); // $ Alert[rust/summary/taint-sources]
        let data = reader.buffer();
        sink(&data); // $ hasTaintFlow
    }

    {
        let mut buffer = String::new();
        let mut reader = std::io::BufReader::new(std::io::stdin()); // $ Alert[rust/summary/taint-sources]
        reader.read_line(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow
    }

    {
        let mut buffer = Vec::<u8>::new();
        let mut reader = std::io::BufReader::new(std::io::stdin()); // $ Alert[rust/summary/taint-sources]
        reader.read_until(b',', &mut buffer)?;
        sink(&buffer); // $ hasTaintFlow
        sink(buffer[0]); // $ hasTaintFlow
    }

    {
        let mut reader_split = std::io::BufReader::new(std::io::stdin()).split(b','); // $ Alert[rust/summary/taint-sources]
        sink(reader_split.next().unwrap().unwrap()); // $ hasTaintFlow
        while let Some(chunk) = reader_split.next() {
            sink(chunk.unwrap()); // $ MISSING: hasTaintFlow
        }
    }

    {
        let reader = std::io::BufReader::new(std::io::stdin()); // $ Alert[rust/summary/taint-sources]
        for line in reader.lines() {
            sink(line); // $ hasTaintFlow
        }
    }

    {
        let reader = std::io::BufReader::new(std::io::stdin()); // $ Alert[rust/summary/taint-sources]
        let line = reader.lines().nth(1).unwrap();
        sink(line.unwrap().clone()); // $ MISSING: hasTaintFlow
    }

    {
        let reader = std::io::BufReader::new(std::io::stdin()); // $ Alert[rust/summary/taint-sources]
        let lines: Vec<_> = reader.lines().collect();
        sink(lines[1].as_ref().unwrap().clone()); // $ MISSING: hasTaintFlow
    }

    Ok(())
}

use tokio::io::{AsyncReadExt, AsyncBufReadExt};

async fn test_tokio_stdin() -> Result<(), Box<dyn std::error::Error>> {

    // --- async reading from stdin ---

    {
        let mut stdin = tokio::io::stdin(); // $ Alert[rust/summary/taint-sources]
        let mut buffer = [0u8; 100];
        let _bytes = stdin.read(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow
    }

    {
        let mut stdin = tokio::io::stdin(); // $ Alert[rust/summary/taint-sources]
        let mut buffer = Vec::<u8>::new();
        let _bytes = stdin.read_to_end(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow
    }

    {
        let mut stdin = tokio::io::stdin(); // $ Alert[rust/summary/taint-sources]
        let mut buffer = String::new();
        let _bytes = stdin.read_to_string(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow
    }

    {
        let mut stdin = tokio::io::stdin(); // $ Alert[rust/summary/taint-sources]
        let mut buffer = [0; 100];
        stdin.read_exact(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow
    }

    {
        let mut stdin = tokio::io::stdin(); // $ Alert[rust/summary/taint-sources]
        let v1 = stdin.read_u8().await?;
        let v2 = stdin.read_i16().await?;
        let v3 = stdin.read_f32().await?;
        let v4 = stdin.read_i64_le().await?;
        sink(v1); // $ hasTaintFlow
        sink(v2); // $ hasTaintFlow
        sink(v3); // $ hasTaintFlow
        sink(v4); // $ hasTaintFlow
    }

    {
        let mut stdin = tokio::io::stdin(); // $ Alert[rust/summary/taint-sources]
        let mut buffer = bytes::BytesMut::new();
        stdin.read_buf(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow
    }

    // --- async reading from stdin (BufReader) ---

    {
        let mut reader = tokio::io::BufReader::new(tokio::io::stdin()); // $ Alert[rust/summary/taint-sources]
        let data = reader.fill_buf().await?;
        sink(&data); // $ hasTaintFlow
    }

    {
        let reader = tokio::io::BufReader::new(tokio::io::stdin()); // $ Alert[rust/summary/taint-sources]
        let data = reader.buffer();
        sink(&data); // $ hasTaintFlow
    }

    {
        let mut buffer = String::new();
        let mut reader = tokio::io::BufReader::new(tokio::io::stdin()); // $ Alert[rust/summary/taint-sources]
        reader.read_line(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow
    }

    {
        let mut buffer = Vec::<u8>::new();
        let mut reader = tokio::io::BufReader::new(tokio::io::stdin()); // $ Alert[rust/summary/taint-sources]
        reader.read_until(b',', &mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow
        sink(buffer[0]); // $ hasTaintFlow
    }

    {
        let mut reader_split = tokio::io::BufReader::new(tokio::io::stdin()).split(b','); // $ Alert[rust/summary/taint-sources]
        sink(reader_split.next_segment().await?.unwrap()); // $ hasTaintFlow
        while let Some(chunk) = reader_split.next_segment().await? {
            sink(chunk); // $ MISSING: hasTaintFlow
        }
    }

    {
        let reader = tokio::io::BufReader::new(tokio::io::stdin()); // $ Alert[rust/summary/taint-sources]
        let mut lines = reader.lines();
        sink(lines.next_line().await?.unwrap()); // $ hasTaintFlow
        while let Some(line) = lines.next_line().await? {
            sink(line); // $ MISSING: hasTaintFlow
        }
    }

    Ok(())
}

use std::fs;

fn test_fs() -> Result<(), Box<dyn std::error::Error>> {
    {
        let buffer: Vec<u8> = std::fs::read("file.bin")?; // $ Alert[rust/summary/taint-sources]
        sink(buffer); // $ hasTaintFlow="file.bin"
    }

    {
        let buffer: Vec<u8> = fs::read("file.bin")?; // $ Alert[rust/summary/taint-sources]
        sink(buffer); // $ hasTaintFlow="file.bin"
    }

    {
        let buffer = fs::read_to_string("file.txt")?; // $ Alert[rust/summary/taint-sources]
        sink(buffer); // $ hasTaintFlow="file.txt"
    }

    for entry in fs::read_dir("directory")? {
        let e = entry?;
        let path = e.path(); // $ Alert[rust/summary/taint-sources]
        let file_name = e.file_name(); // $ Alert[rust/summary/taint-sources]
        sink(path); // $ hasTaintFlow
        sink(file_name); // $ hasTaintFlow
    }

    {
        let target = fs::read_link("symlink.txt")?; // $ Alert[rust/summary/taint-sources]
        sink(target); // $ hasTaintFlow="symlink.txt"
    }

    Ok(())
}

async fn test_tokio_fs() -> Result<(), Box<dyn std::error::Error>> {
    {
        let buffer: Vec<u8> = tokio::fs::read("file.bin").await?; // $ Alert[rust/summary/taint-sources]
        sink(buffer); // $ hasTaintFlow="file.bin"
    }

    {
        let buffer: Vec<u8> = tokio::fs::read("file.bin").await?; // $ Alert[rust/summary/taint-sources]
        sink(buffer); // $ hasTaintFlow="file.bin"
    }

    {
        let buffer = tokio::fs::read_to_string("file.txt").await?; // $ Alert[rust/summary/taint-sources]
        sink(buffer); // $ hasTaintFlow="file.txt"
    }

    let mut read_dir = tokio::fs::read_dir("directory").await?;
    for entry in read_dir.next_entry().await? {
        let path = entry.path(); // $ Alert[rust/summary/taint-sources]
        let file_name = entry.file_name(); // $ Alert[rust/summary/taint-sources]
        sink(path); // $ hasTaintFlow
        sink(file_name); // $ hasTaintFlow
    }

    {
        let target = tokio::fs::read_link("symlink.txt").await?; // $ Alert[rust/summary/taint-sources]
        sink(target); // $ hasTaintFlow="symlink.txt"
    }

    Ok(())
}

fn test_io_file() -> std::io::Result<()> {
    // --- file ---

    let mut file = std::fs::File::open("file.txt")?; // $ Alert[rust/summary/taint-sources]

    {
        let mut buffer = [0u8; 100];
        let _bytes = file.read(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    {
        let mut buffer = Vec::<u8>::new();
        let _bytes = file.read_to_end(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    {
        let mut buffer = String::new();
        let _bytes = file.read_to_string(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    {
        let mut buffer = [0; 100];
        file.read_exact(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    for byte in file.bytes() {
        sink(byte); // $ hasTaintFlow="file.txt"
    }

    // --- misc operations ---

    {
        let mut buffer = String::new();
        let file1 = std::fs::File::open("file.txt")?; // $ Alert[rust/summary/taint-sources]
        let file2 = std::fs::File::open("another_file.txt")?; // $ Alert[rust/summary/taint-sources]
        let mut reader = file1.chain(file2);
        reader.read_to_string(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow="file.txt" hasTaintFlow="another_file.txt"
    }

    {
        let mut buffer = String::new();
        let file1 = std::fs::File::open("file.txt")?; // $ Alert[rust/summary/taint-sources]
        let mut reader = file1.take(100);
        reader.read_to_string(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    Ok(())
}

async fn test_tokio_file() -> std::io::Result<()> {
    // --- file ---

    let mut file = tokio::fs::File::open("file.txt").await?; // $ Alert[rust/summary/taint-sources]

    {
        let mut buffer = [0u8; 100];
        let _bytes = file.read(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    {
        let mut buffer = Vec::<u8>::new();
        let _bytes = file.read_to_end(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    {
        let mut buffer = String::new();
        let _bytes = file.read_to_string(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    {
        let mut buffer = [0; 100];
        file.read_exact(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    {
        let v1 = file.read_u8().await?;
        let v2 = file.read_i16().await?;
        let v3 = file.read_f32().await?;
        let v4 = file.read_i64_le().await?;
        sink(v1); // $ hasTaintFlow="file.txt"
        sink(v2); // $ hasTaintFlow="file.txt"
        sink(v3); // $ hasTaintFlow="file.txt"
        sink(v4); // $ hasTaintFlow="file.txt"
    }

    {
        let mut buffer = bytes::BytesMut::new();
        file.read_buf(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    // --- misc operations ---

    {
        let mut buffer = String::new();
        let file1 = tokio::fs::File::open("file.txt").await?; // $ Alert[rust/summary/taint-sources]
        let file2 = tokio::fs::File::open("another_file.txt").await?; // $ Alert[rust/summary/taint-sources]
        let mut reader = file1.chain(file2);
        reader.read_to_string(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="file.txt" hasTaintFlow="another_file.txt"
    }

    {
        let mut buffer = String::new();
        let file1 = tokio::fs::File::open("file.txt").await?; // $ Alert[rust/summary/taint-sources]
        let mut reader = file1.take(100);
        reader.read_to_string(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    Ok(())
}

use std::net::ToSocketAddrs;

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

use tokio::io::AsyncWriteExt;

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
    // using tokio::io to fetch a web page
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

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let case = std::env::args().nth(1).unwrap_or(String::from("1")).parse::<i64>().unwrap(); // $ Alert[rust/summary/taint-sources]

    println!("test_env_vars...");
    test_env_vars();

    println!("test_env_args...");
    test_env_args();

    println!("test_env_dirs...");
    test_env_dirs();

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

    println!("test_io_stdin...");
    match test_io_stdin() {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_tokio_stdin...");
    match futures::executor::block_on(test_tokio_stdin()) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_fs...");
    match test_fs() {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_tokio_fs...");
    match futures::executor::block_on(test_tokio_fs()) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_io_file...");
    match test_io_file() {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    println!("test_tokio_file...");
    match futures::executor::block_on(test_tokio_file()) {
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

    Ok(())
}
