import os

def test(codeql, csharp, cwd):
    path = os.path.join(cwd, "dependencies")
    os.environ["CODEQL_EXTRACTOR_CSHARP_OPTION_BUILDLESS_DEPENDENCY_DIR"] = path
    # The Assemblies.ql query shows that the Newtonsoft assembly is found in the
    # dependency directory set above.
    codeql.database.create(source_root="proj", build_mode="none")
