import pytest


@pytest.mark.parametrize("option",
                         [
                             pytest.param(p,
                                          marks=pytest.mark.ql_test(expected=f".{e}.expected"))
                             for p, e in (
                                 (None, "default"),
                                 ("cargo_features=foo", "foo"),
                                 ("cargo_features=bar", "bar"),
                                 ("cargo_features=*", "all"),
                                 ("cargo_features=foo,bar", "all"))
                         ])
def test_features(codeql, rust, option):
    codeql.database.create(extractor_option=option)
