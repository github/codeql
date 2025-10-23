fn sink<T>(_: T) { }

// --- tests ---

use std::fs;
use std::io::Read;
use tokio::io::AsyncReadExt;
use async_std::io::ReadExt;

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
        sink(path.clone()); // $ hasTaintFlow
        sink(path.clone().as_path()); // $ hasTaintFlow
        sink(path.clone().into_os_string()); // $ MISSING: hasTaintFlow
        sink(std::path::PathBuf::from(path.clone().into_boxed_path())); // $ MISSING: hasTaintFlow
        sink(path.clone().as_os_str()); // $ MISSING: hasTaintFlow
        sink(path.clone().as_mut_os_str()); // $ MISSING: hasTaintFlow
        sink(path.to_str()); // $ MISSING: hasTaintFlow
        sink(path.to_path_buf()); // $ MISSING: hasTaintFlow
        sink(path.file_name().unwrap()); // $ MISSING: hasTaintFlow
        sink(path.extension().unwrap()); // $ MISSING: hasTaintFlow
        sink(path.canonicalize().unwrap()); // $ MISSING: hasTaintFlow
        sink(path); // $ hasTaintFlow

        let file_name = e.file_name(); // $ Alert[rust/summary/taint-sources]
        sink(file_name.clone()); // $ hasTaintFlow
        sink(file_name.clone().into_string().unwrap()); // $ MISSING: hasTaintFlow
        sink(file_name.to_str().unwrap()); // $ MISSING: hasTaintFlow
        sink(file_name.to_string_lossy().to_mut()); // $ MISSING: hasTaintFlow
        sink(file_name.clone().as_encoded_bytes()); // $ MISSING: hasTaintFlow
        sink(file_name); // $ hasTaintFlow
    }
    for entry in std::path::Path::new("directory").read_dir()? {
        let e = entry?;

        let path = e.path(); // $ Alert[rust/summary/taint-sources]
        let file_name = e.file_name(); // $ Alert[rust/summary/taint-sources]
    }
    for entry in std::path::PathBuf::from("directory").read_dir()? {
        let e = entry?;

        let path = e.path(); // $ MISSING: Alert[rust/summary/taint-sources]
        let file_name = e.file_name(); // $ MISSING: Alert[rust/summary/taint-sources]
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

    // --- OpenOptions ---

    {
        let mut f1 = std::fs::OpenOptions::new().open("f1.txt").unwrap(); // $ Alert[rust/summary/taint-sources]
        let mut buffer = [0u8; 1024];
        let _bytes = f1.read(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow="f1.txt"
    }

    {
        let mut f2 = std::fs::OpenOptions::new().create_new(true).open("f2.txt").unwrap(); // $ Alert[rust/summary/taint-sources]
        let mut buffer = [0u8; 1024];
        let _bytes = f2.read(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow="f2.txt"
    }

    {
        let mut f3 = std::fs::OpenOptions::new().read(true).write(true).truncate(true).create(true).open("f3.txt").unwrap(); // $ Alert[rust/summary/taint-sources]
        let mut buffer = [0u8; 1024];
        let _bytes = f3.read(&mut buffer)?;
        sink(&buffer); // $ hasTaintFlow="f3.txt"
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

    // --- OpenOptions ---

    {
        let mut f1 = tokio::fs::OpenOptions::new().open("f1.txt").await?; // $ Alert[rust/summary/taint-sources]
        let mut buffer = [0u8; 1024];
        let _bytes = f1.read(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="f1.txt"
    }

    // --- misc operations ---

    {
        let mut buffer = String::new();
        let file1 = tokio::fs::File::open("file.txt").await?; // $ Alert[rust/summary/taint-sources]
        let file2 = tokio::fs::File::open("another_file.txt").await?; // $ Alert[rust/summary/taint-sources]
        let mut reader = file1.chain(file2);
        reader.read_to_string(&mut buffer).await?;
        sink(&buffer); // $ MISSING: hasTaintFlow="file.txt" hasTaintFlow="another_file.txt"
    }

    {
        let mut buffer = String::new();
        let file1 = tokio::fs::File::open("file.txt").await?; // $ Alert[rust/summary/taint-sources]
        let mut reader = file1.take(100);
        reader.read_to_string(&mut buffer).await?;
        sink(&buffer); // $ MISSING: hasTaintFlow="file.txt"
    }

    Ok(())
}

async fn test_async_std_file() -> std::io::Result<()> {
    // --- file ---

    let mut file = async_std::fs::File::open("file.txt").await?; // $ Alert[rust/summary/taint-sources]

    {
        let mut buffer = [0u8; 100];
        let _bytes = file.read(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="file.txt"
    }

    // --- OpenOptions ---

    {
        let mut f1 = async_std::fs::OpenOptions::new().open("f1.txt").await?; // $ Alert[rust/summary/taint-sources]
        let mut buffer = [0u8; 1024];
        let _bytes = f1.read(&mut buffer).await?;
        sink(&buffer); // $ hasTaintFlow="f1.txt"
    }

    Ok(())
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
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

    println!("test_async_std_file...");
    match futures::executor::block_on(test_async_std_file()) {
        Ok(_) => println!("complete"),
        Err(e) => println!("error: {}", e),
    }

    Ok(())
}
