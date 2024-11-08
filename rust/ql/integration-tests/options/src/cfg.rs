#[cfg(cfg_flag)]
fn cfg_flag() {}

#[cfg(cfg_key = "value")]
fn cfg_key() {}

#[cfg(not(cfg_flag))]
fn cfg_no_flag() {}

#[cfg(not(cfg_key = "value"))]
fn cfg_no_key() {}

#[cfg(not(test))]
fn no_test() {}
