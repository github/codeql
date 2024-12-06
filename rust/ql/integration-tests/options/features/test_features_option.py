import pytest

def test_default(codeql, rust):
    codeql.database.create()

@pytest.mark.parametrize("features",
                         [
                             pytest.param(p,
                                          marks=pytest.mark.ql_test(expected=f".{e}.expected"))
                             for p, e in (
                                 ("foo", "foo"),
                                 ("bar", "bar"),
                                 ("*", "all"),
                                 ("foo,bar", "all"))
                         ])
def test_features(codeql, rust, features):
    codeql.database.create(extractor_option=f"cargo_features={features}")
