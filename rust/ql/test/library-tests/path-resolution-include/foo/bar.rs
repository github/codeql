pub mod directory;
#[path = "sibling.rs"]
pub mod renamed;
pub mod sibling;

pub mod inline {
    pub mod child;
}

include!("nested/more.rs"); // $ item=include
