// A manually modeled source
fn known_source(n: i64) -> i64 {
    n
}

// source=test::sources::derived_source;ReturnValue;test-source;df-generated
// summary=test::sources::derived_source;Argument[1];ReturnValue;value;dfc-generated
pub fn derived_source(c: bool, n: i64) -> i64 {
    if c {
        known_source(n)
    } else {
        0
    }
}
