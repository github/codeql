use poem::{error::InternalServerError, handler, http::StatusCode, web::Query, Error, Result};
use std::{env::home_dir, fs, path::PathBuf};

#[handler]
fn tainted_path_handler(Query(file_path): Query<String>) -> Result<String, Error> {
    let public_path = home_dir().unwrap().join("public");
    let file_path = public_path.join(PathBuf::from(file_path));
    let file_path = file_path.canonicalize().unwrap();
    // GOOD: ensure that the path stays within the public folder
    if !file_path.starts_with(public_path) {
        return Err(Error::from_status(StatusCode::BAD_REQUEST));
    }
    fs::read_to_string(file_path).map_err(InternalServerError)
}
