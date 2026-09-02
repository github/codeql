def test_actions_lock(codeql, actions, javascript):
    codeql.database.create(source_root="src", language="actions")
    output = codeql.query.run("query/actions.ql", database="test-db", _capture=True)
    assert "actions.lock" in output
