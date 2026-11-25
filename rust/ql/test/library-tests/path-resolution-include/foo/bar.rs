pub mod sibling;
pub mod directory;

pub mod inline {
    pub mod child;
}

include!("nested/more.rs"); // $ item=include
