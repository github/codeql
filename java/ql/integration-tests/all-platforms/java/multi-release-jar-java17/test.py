import commands


def test(codeql, java):
    commands.run(
        "javac mod1/module-info.java mod1/mod1pkg/Mod1Class.java -d mod1obj",
        "jar -c -f mod1.jar -C mod1obj mod1pkg/Mod1Class.class --release 9 -C mod1obj module-info.class",
    )
    codeql.database.create(
        command="javac mod2/mod2pkg/User.java mod2/module-info.java -d mod2obj -p mod1.jar"
    )
