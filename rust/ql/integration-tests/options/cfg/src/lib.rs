#[cfg(cfg_flag)]
fn cfg_flag() {}

#[cfg(cfg_key = "value")]
fn cfg_key() {}

#[cfg(not(cfg_flag))]
fn cfg_no_flag() {}

#[cfg(not(cfg_key = "value"))]
fn cfg_no_key() {}

#[cfg(test)]
mod tests {
    #[test]
    fn test() {}
}

#[cfg(target_pointer_width = "64")]
fn pointer_width_64() {}

#[cfg(target_pointer_width = "32")]
fn pointer_width_32() {}
