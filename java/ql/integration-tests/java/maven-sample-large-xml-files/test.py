def test(codeql, java):
    # Test that a build with 60 ~1MB XML docs extracts does not extract them, but we fall back to by-name mode instead:
    for i in range(60):
        with open(f"generated-{i}.xml", "w") as f:
            f.write("<xml>" + ("a" * 1000000) + "</xml>")
    codeql.database.create()
