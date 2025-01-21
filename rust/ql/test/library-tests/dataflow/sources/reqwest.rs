
// --- stubs for the "reqwest" library ---

/*
 --- we don't seem to have a way to use this, hence we currently test against the real reqwest library
#[derive(Debug)]
pub struct Error { }

pub mod blocking {
    pub struct Response { }
    impl Response {
        pub fn text(self) -> Result<String, super::Error> {
            Ok("".to_string())
        }
    }

    pub fn get<T>(url: T) -> Result<Response, super::Error> {
        let _url = url;

        Ok(Response {})
    }
}

pub struct Response { }
impl Response {
    pub async fn text(self) -> Result<String, Error> {
        Ok("".to_string())
    }
}

pub async fn get<T>(url: T) -> Result<Response, Error> {
    let _url = url;

    Ok(Response {})
}
*/
