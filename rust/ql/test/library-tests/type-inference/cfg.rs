pub fn expressions() {
    let unix = cfg!(unix); // $ certainType=unix:bool
    let windows = cfg!(target_os = "windows"); // $ certainType=windows:bool
    let either = cfg!(any(unix, target_os = "windows")); // $ certainType=either:bool
    let always = cfg!(all()); // $ certainType=always:bool
    let never = cfg!(any()); // $ certainType=never:bool
}

pub fn patterns() {
    let value = Default::default(); // $ target=default type=value:bool
    match value {
        cfg!(unix) => (),
        cfg!(target_os = "windows") => (),
        cfg!(any(unix, target_os = "windows")) => (),
        _ => (),
    }
}
