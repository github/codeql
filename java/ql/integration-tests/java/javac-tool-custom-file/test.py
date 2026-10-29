import commands

def test(codeql, java):
    commands.run("javac Compiler.java")
    codeql.database.create(command = "java Compiler")
