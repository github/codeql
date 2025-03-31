use poem::{error::InternalServerError, handler, web::Query, Result};
use std::{fs, path::PathBuf};

#[handler]
fn tainted_path_handler(Query(file_name): Query<String>) -> Result<String> {
    let file_path = PathBuf::from(file_name);
    // BAD: This could read any file on the filesystem.
    fs::read_to_string(file_path).map_err(InternalServerError)
}
