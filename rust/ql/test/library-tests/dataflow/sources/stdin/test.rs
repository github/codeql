fn sink<T>(_: T) { }

// --- tests ---

use std::io::{Read, BufRead};
use tokio::io::{AsyncReadExt, AsyncBufReadExt};

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
        sink(&buffer); // $ hasTaintFlow
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
            sink(chunk.unwrap()); // $ hasTaintFlow
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
            sink(chunk); // $ hasTaintFlow
        }
    }

    {
        let reader = tokio::io::BufReader::new(tokio::io::stdin()); // $ Alert[rust/summary/taint-sources]
        let mut lines = reader.lines();
        sink(lines.next_line().await?.unwrap()); // $ hasTaintFlow
        while let Some(line) = lines.next_line().await? {
            sink(line); // $ hasTaintFlow
        }
    }

    Ok(())
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
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

    Ok(())
}
