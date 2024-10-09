use codeql_extractor::generator::ql::Expression;

mod common;

#[test]
fn test_gen_string() {
    let string = Expression::String("foo");
    assert_eq!(string.to_string(), "\"foo\"");

    let string_dquote = Expression::String("foo\"bar");
    assert_eq!(string_dquote.to_string(), "\"foo\"bar\"");
    let string_squote = Expression::String("foo'bar");
    assert_eq!(string_squote.to_string(), "\"foo\'bar\"");
}
