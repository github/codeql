import pytest

@pytest.mark.ql_test(expected=".all.expected")
def test_default(codeql, rust):
    codeql.database.create()

@pytest.mark.parametrize("features",
                         [
                             pytest.param(p,
                                          marks=pytest.mark.ql_test(expected=f".{e}.expected"))
                             for p, e in (
                                 ("default", "none"),
                                 ("foo", "foo"),
                                 ("bar", "bar"),
                                 ("*", "all"),
                                 ("foo,bar", "all"),
                                 ("default,foo", "foo"),
                                 ("default,bar", "bar"),
                             )
                         ])
def test_features(codeql, rust, features):
    codeql.database.create(extractor_option=f"cargo_features={features}")

@pytest.mark.parametrize("features",
                         [
                             pytest.param(p,
                                          marks=pytest.mark.ql_test(expected=f".{e}.expected"))
                             for p, e in (
                                 ("default", "foo"),
                                 ("foo", "foo"),
                                 ("bar", "bar"),
                                 ("*", "all"),
                                 ("foo,bar", "all"),
                                 ("default,foo", "foo"),
                                 ("default,bar", "all"),
                             )
                         ])
def test_features_with_default(codeql, rust, features):
    with open("Cargo.toml", "a") as f:
        print('default = ["foo"]', file=f)
    codeql.database.create(extractor_option=f"cargo_features={features}")
