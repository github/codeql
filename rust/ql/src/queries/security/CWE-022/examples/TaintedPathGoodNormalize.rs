use poem::{error::InternalServerError, handler, http::StatusCode, web::Query, Error, Result};
use std::{fs, path::PathBuf};

#[handler]
fn tainted_path_handler(Query(file_name): Query<String>) -> Result<String> {
    // GOOD: ensure that the filename has no path separators or parent directory references
    if file_name.contains("..") || file_name.contains("/") || file_name.contains("\\") {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    let file_path = PathBuf::from(file_name);
    fs::read_to_string(file_path).map_err(InternalServerError)
}
