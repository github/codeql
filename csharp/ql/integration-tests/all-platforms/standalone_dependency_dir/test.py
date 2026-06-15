import os
import shutil

def test(codeql, csharp, cwd):
    path = os.path.join(cwd, "dependencies")
    os.environ["CODEQL_EXTRACTOR_CSHARP_OPTION_BUILDLESS_DEPENDENCY_DIR"] = path
    # The Assemblies.ql query shows that the Newtonsoft assembly is found in the
    # dependency directory set above.
    codeql.database.create(source_root="proj", build_mode="none")

    # Check that the packages directory has been created in the dependencies folder.
    packages_dir = os.path.join(path, "packages")
    assert os.path.isdir(packages_dir), "The packages directory was not created in the specified dependency directory."
    shutil.rmtree(path)
