def test(codeql, java, ecj):
    codeql.database.create(
        command=f"java -cp {ecj} org.eclipse.jdt.internal.compiler.batch.Main Test.java"
    )
