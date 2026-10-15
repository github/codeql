pub fn expressions() {
    let unix = cfg!(unix); // $ MISSING: certainType=unix:bool
    let windows = cfg!(target_os = "windows"); // $ MISSING: certainType=windows:bool
    let either = cfg!(any(unix, target_os = "windows")); // $ MISSING: certainType=either:bool
    let always = cfg!(all()); // $ MISSING: certainType=always:bool
    let never = cfg!(any()); // $ MISSING: certainType=never:bool
}

pub fn patterns() {
    let value = Default::default(); // $ MISSING: target=default type=value:bool
    match value {
        cfg!(unix) => (),
        cfg!(target_os = "windows") => (),
        cfg!(any(unix, target_os = "windows")) => (),
        _ => (),
    }
}
