pub fn cfg_expr() -> bool {
    cfg!(unix)
}

pub fn cfg_pat(value: bool) -> bool {
    match value {
        cfg!(unix) => true,
        _ => false,
    }
}
