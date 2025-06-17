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
fn tainted_path_handler_good(Query(file_name): Query<String>) -> Result<String> { // $ SPURIOUS: Source=remote2
    // GOOD: ensure that the filename has no path separators or parent directory references
    if file_name.contains("..") || file_name.contains("/") || file_name.contains("\\") {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    let file_path = PathBuf::from(file_name);
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink SPURIOUS: Alert[rust/path-injection]=remote2
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
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink
}

//#[handler]
fn tainted_path_handler_folder_almost_good1(
    Query(file_path): Query<String>, // $ Source=remote4
) -> Result<String> {
    let public_path = PathBuf::from("/var/www/public_html");
    let file_path = public_path.join(PathBuf::from(file_path));
    // BAD: the path could still contain `..` and escape the public folder
    if !file_path.starts_with(public_path) {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink Alert[rust/path-injection]=remote4
}

//#[handler]
fn tainted_path_handler_folder_almost_good2(
    Query(file_path): Query<String>, // $ Source=remote5
) -> Result<String> {
    let public_path = PathBuf::from("/var/www/public_html");
    let file_path = public_path.join(PathBuf::from(file_path));
    let file_path = file_path.canonicalize().unwrap();
    // BAD: the check to ensure that the path stays within the public folder is wrong
    if file_path.starts_with(public_path) {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    fs::read_to_string(file_path).map_err(InternalServerError) // $ path-injection-sink Alert[rust/path-injection]=remote5
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
    let _ = std::fs::DirBuilder::new().create(path1); // $ path-injection-sink
    let _ = std::fs::File::create(path1); // $ path-injection-sink
    let _ = std::fs::File::create_buffered(path1); // $ path-injection-sink
    let _ = std::fs::File::create_new(path1); // $ path-injection-sink
    let _ = std::fs::File::open(path1); // $ path-injection-sink
    let _ = std::fs::File::open_buffered(path1); // $ path-injection-sink
}

fn main() {}
