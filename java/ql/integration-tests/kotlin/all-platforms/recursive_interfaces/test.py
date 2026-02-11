import commands

def test(codeql, java_full):
    codeql.database.create(
        command=["kotlinc somepkg/IfaceA.java somepkg/IfaceB.java somepkg/IfaceC.java somepkg/IfaceZ.java test.kt"]
    )
