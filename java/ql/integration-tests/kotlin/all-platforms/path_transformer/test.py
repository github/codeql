import os


def test(codeql, java_full):
    path_transformer_file = "path_transformer"
    root = os.getcwd().replace("\\", "/")
    with open(path_transformer_file, "w") as f:
        f.write("#/src\n" + root + "//\n")
    os.environ["SEMMLE_PATH_TRANSFORMER"] = root + "/" + path_transformer_file

    codeql.database.create(command=["kotlinc kotlin_source.kt"])
    files = ["test-db/trap/java/src/kotlin_source.kt.trap.gz", "test-db/src/src/kotlin_source.kt"]
    for file in files:
        assert os.path.exists(file)
