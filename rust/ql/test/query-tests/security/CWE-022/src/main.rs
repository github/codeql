#![feature(file_buffered)]
use poem::{error::InternalServerError, handler, http::StatusCode, web::Query, Error, Result};
use std::{fs, path::Path, path::PathBuf};

//#[handler]
fn tainted_path_handler_bad(
    Query(file_name): Query<String>, // $ Source=remote1
) -> Result<String> {
    let file_path = PathBuf::from(file_name);
    // BAD: This could read any file on the filesystem.
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink Alert[rust/path-injection]=remote1
}

//#[handler]
fn tainted_path_handler_good(Query(file_name): Query<String>) -> Result<String> {
    // GOOD: ensure that the filename has no path separators or parent directory references
    if file_name.contains("..") || file_name.contains("/") || file_name.contains("\\") { // $ path-injection-barrier
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    let file_path = PathBuf::from(file_name); // $ path-injection-barrier (following the last `.contains` check)
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink
}

//#[handler]
fn tainted_path_handler_folder_good(Query(file_path): Query<String>) -> Result<String> {
    let public_path = PathBuf::from("/var/www/public_html");
    let file_path = public_path.join(PathBuf::from(file_path));
    let file_path = file_path.canonicalize().unwrap();
    // GOOD: ensure that the path stays within the public folder
    if !file_path.starts_with(public_path) {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink MISSING: path-injection-checked
}

//#[handler]
fn tainted_path_handler_folder_almost_good1(
    Query(file_path): Query<String>, // $ MISSING: Source=remote2
) -> Result<String> {
    let public_path = PathBuf::from("/var/www/public_html");
    let file_path = public_path.join(PathBuf::from(file_path));
    // BAD: the path could still contain `..` and escape the public folder
    if !file_path.starts_with(public_path) {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink MISSING: path-injection-checked Alert[rust/path-injection]=remote2 -- we cannot resolve the `join` call above, because it needs a `PathBuf -> Path` `Deref`
}

//#[handler]
fn tainted_path_handler_folder_good_simpler(Query(file_path): Query<String>) -> Result<String> { // $ Source=remote6
    let public_path = "/var/www/public_html";
    let file_path = Path::new(&file_path);
    let file_path = file_path.canonicalize().unwrap();
    // GOOD: ensure that the path stays within the public folder
    if !file_path.starts_with(public_path) {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink MISSING: path-injection-checked SPURIOUS: Alert[rust/path-injection]=remote6
}

//#[handler]
fn tainted_path_handler_folder_almost_good1_simpler(
    Query(file_path): Query<String>, // $ Source=remote3
) -> Result<String> {
    let public_path = "/var/www/public_html";
    let file_path = Path::new(&file_path);
    // BAD: the path could still contain `..` and escape the public folder
    if !file_path.starts_with(public_path) {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-checked path-injection-sink Alert[rust/path-injection]=remote3
}

//#[handler]
fn tainted_path_handler_folder_almost_good2(
    Query(file_path): Query<String>, // $ MISSING: Source=remote4
) -> Result<String> {
    let public_path = PathBuf::from("/var/www/public_html");
    let file_path = public_path.join(PathBuf::from(file_path));
    let file_path = file_path.canonicalize().unwrap();
    // BAD: the check to ensure that the path stays within the public folder is wrong
    if file_path.starts_with(public_path) {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink MISSING: path-injection-checked Alert[rust/path-injection]=remote4 -- we cannot resolve the `join` call above, because it needs a `PathBuf -> Path` `Deref`
}

//#[handler]
fn tainted_path_handler_folder_almost_good3(
    Query(file_path): Query<String>, // $ Source=remote5
) -> Result<String> {
    let public_path = "/var/www/public_html";
    let file_path = Path::new(&file_path);
    // BAD: the starts_with check is ineffective before canonicalization, the path could still contain `..`
    if !file_path.starts_with(public_path) {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    let file_path = file_path.canonicalize().unwrap(); // $ path-injection-checked
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink Alert[rust/path-injection]=remote5
}

async fn more_simple_cases() {
    let path1 = std::env::args().nth(1).unwrap(); // $ Source=arg1
    let _ = std::fs::File::open(path1.clone()); // $ path-injection-sink Alert[rust/path-injection]=arg1

    let path2 = std::fs::canonicalize(path1.clone()).unwrap();
    let _ = std::fs::File::open(path2); // $ path-injection-sink Alert[rust/path-injection]=arg1

    let path3 = tokio::fs::canonicalize(path1.clone()).await.unwrap();
    let _ = tokio::fs::File::open(path3); // $ path-injection-sink Alert[rust/path-injection]=arg1

    let path4 = async_std::fs::canonicalize(path1.clone()).await.unwrap();
    let _ = async_std::fs::File::open(path4); // $ path-injection-sink Alert[rust/path-injection]=arg1

    let path5 = std::path::Path::new(&path1);
    let _ = std::fs::File::open(path5); // $ path-injection-sink Alert[rust/path-injection]=arg1

    let path6 = path5.canonicalize().unwrap();
    let _ = std::fs::File::open(path6); // $ path-injection-sink Alert[rust/path-injection]=arg1

    let harmless = "";
    let _ = std::fs::copy(path1.clone(), harmless); // $ path-injection-sink Alert[rust/path-injection]=arg1
    let _ = std::fs::copy(harmless, path1.clone()); // $ path-injection-sink Alert[rust/path-injection]=arg1
}

fn sinks(path1: &Path, path2: &Path) {
    let _ = std::fs::copy(path1, path2); // $ path-injection-sink
    let _ = std::fs::create_dir(path1); // $ path-injection-sink
    let _ = std::fs::create_dir_all(path1); // $ path-injection-sink
    let _ = std::fs::hard_link(path1, path2); // $ path-injection-sink
    let _ = std::fs::metadata(path1); // $ path-injection-sink
    let _ = std::fs::read(path1); // $ path-injection-sink
    let _ = std::fs::read_dir(path1); // $ path-injection-sink
    let _ = std::fs::read_link(path1); // $ path-injection-sink
    let _ = std::fs::read_to_string(path1); // $ path-injection-sink
    let _ = std::fs::remove_dir(path1); // $ path-injection-sink
    let _ = std::fs::remove_dir_all(path1); // $ path-injection-sink
    let _ = std::fs::remove_file(path1); // $ path-injection-sink
    let _ = std::fs::rename(path1, path2); // $ path-injection-sink
    let _ = std::fs::set_permissions(path1, std::os::unix::fs::PermissionsExt::from_mode(7)); // $ path-injection-sink
    let _ = std::fs::soft_link(path1, path2); // $ path-injection-sink
    let _ = std::fs::symlink_metadata(path1); // $ path-injection-sink
    let _ = std::fs::write(path1, "contents"); // $ path-injection-sink
    let _ = std::fs::File::create(path1); // $ path-injection-sink
    let _ = std::fs::File::create_buffered(path1); // $ path-injection-sink
    let _ = std::fs::File::create_new(path1); // $ path-injection-sink
    let _ = std::fs::File::open(path1); // $ path-injection-sink
    let _ = std::fs::File::open_buffered(path1); // $ path-injection-sink
    let _ = std::fs::DirBuilder::new().create(path1); // $ path-injection-sink
    let _ = std::fs::DirBuilder::new().recursive(true).create(path1); // $ path-injection-sink
    let _ = std::fs::OpenOptions::new().open(path1); // $ path-injection-sink

    let _ = tokio::fs::read(path1); // $ path-injection-sink
    let _ = tokio::fs::read_to_string(path1); // $ path-injection-sink
    let _ = tokio::fs::remove_file(path1); // $ path-injection-sink
    let _ = tokio::fs::DirBuilder::new().create(path1); // $ path-injection-sink
    let _ = tokio::fs::DirBuilder::new().recursive(true).create(path1); // $ path-injection-sink
    let _ = tokio::fs::OpenOptions::new().open(path1); // $ path-injection-sink

    let _ = async_std::fs::read(path1); // $ path-injection-sink
    let _ = async_std::fs::read_to_string(path1); // $ path-injection-sink
    let _ = async_std::fs::remove_file(path1); // $ path-injection-sink
    let _ = async_std::fs::DirBuilder::new().create(path1); // $ path-injection-sink
    let _ = async_std::fs::DirBuilder::new().recursive(true).create(path1); // $ path-injection-sink
    let _ = async_std::fs::OpenOptions::new().open(path1); // $ path-injection-sink
}

use std::fs::File;

fn my_function(path_str: &str) -> Result<(), std::io::Error> {
    // somewhat realistic example
    let path = Path::new(path_str);
    if path.exists() { // $ path-injection-sink Alert[rust/path-injection]=arg2
        let mut file1 = File::open(path_str)?; // $ path-injection-sink Alert[rust/path-injection]=arg2
        // ...

        let mut file2 = File::open(path)?; // $ path-injection-sink Alert[rust/path-injection]=arg2
        // ...
    }

    Ok(())
}

fn main() {
    let path1 = std::env::args().nth(1).unwrap(); // $ Source=arg2
    my_function(&path1);
}
