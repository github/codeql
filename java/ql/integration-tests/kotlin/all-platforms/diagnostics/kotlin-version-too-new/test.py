import commands
import pathlib


def test(codeql, java_full):
    fake_kotlin_classes = pathlib.Path("fake-kotlinc-classes")
    fake_kotlin_classes.mkdir()
    for source_file in pathlib.Path("fake-kotlinc-source").rglob("*.java"):
        commands.run(
            f"javac {source_file.relative_to("fake-kotlinc-source")} -d {fake_kotlin_classes.absolute()}",
            _cwd="fake-kotlinc-source",
        )
    codeql.database.create(
        command=[f"java -cp {fake_kotlin_classes} driver.Main"], _assert_failure=True
    )
