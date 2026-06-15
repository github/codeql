def test(codeql, java):
    # Test that a build with 5 ~1MB XML docs extracts them:
    for i in range(5):
        with open(f"generated-{i}.xml", "w") as f:
            f.write("<xml>" + ("a" * 1000000) + "</xml>")
    codeql.database.create()
