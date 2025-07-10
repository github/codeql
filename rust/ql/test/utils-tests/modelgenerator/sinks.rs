// A manually modeled sink
fn known_sink(n: i64) {
    ()
}

// sink=repo::test;crate::sinks::derived_sink;Argument[1];test-sink;df-generated
pub fn derived_sink(c: bool, n: i64) -> i64 {
    if c {
        known_sink(n);
        1
    } else {
        0
    }
}
