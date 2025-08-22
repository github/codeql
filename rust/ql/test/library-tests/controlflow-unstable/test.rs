// TODO: Move these tests into `controlflow` when they become stable features

mod if_expression {

    fn test_and_if_let(a: bool, b: Option<bool>, c: bool) -> bool {
        if a && let Some(d) = b {
            d
        } else {
            false
        }
    }

    fn test_and_if_let2(a: bool, b: i64, c: bool) -> bool {
        if a && let d = b
            && c
        {
            d > 0
        } else {
            false
        }
    }
}
