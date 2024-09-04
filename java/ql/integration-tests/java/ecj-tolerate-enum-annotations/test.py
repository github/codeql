def test(codeql, java, ecj):
    # This tests the case where ECJ emits a RuntimeIn/VisibleAnnotations attribute that isn't the same size as the corresponding method argument list, in particular due to forgetting to include the synthetic parameters added to explicit enumeration constructors.
    codeql.database.create(
        command=[
            f"java -cp {ecj} org.eclipse.jdt.internal.compiler.batch.Main Test.java -d out -source 8",
            f"java -cp {ecj} org.eclipse.jdt.internal.compiler.batch.Main Test2.java -cp out -source 8",
        ]
    )
