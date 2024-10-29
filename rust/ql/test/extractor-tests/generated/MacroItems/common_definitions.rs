use std::path::Path;

fn get_parent(path: &Path) -> &Path {
    path.parent().unwrap()
}
