import os
import os.path
import commands
import runs_on


@runs_on.posix
def test(codeql, java_full):
    # Build a family of dependencies outside tracing, then refer to them from a traced build:

    older_datetime = "202201010101"
    newer_datetime = "202202020202"

    classpath_entries = dict()

    extraction_orders = ["JavaSeesFirst", "KotlinSeesFirst"]
    jar_states = ["NoJar", "JarMtimesEqual", "JavaJarNewer", "KotlinJarNewer"]
    class_file_states = ["ClassFileMtimesEqual", "JavaClassFileNewer", "KotlinClassFileNewer"]

    # Create test classes for each combination of which extractor will see the file first, the relative timestamps of the jar files seen by each, and the relative timestamps of the class file inside:

    jobs = []

    for first_extraction in extraction_orders:
        for jar_state in jar_states:
            for class_file_state in class_file_states:
                dep_dir = os.path.join(first_extraction, jar_state, class_file_state)
                dep_classname = "Dep___%s___%s___%s" % (
                    first_extraction,
                    jar_state,
                    class_file_state,
                )
                dep_seen_by_java_dir = os.path.join(dep_dir, "seen_by_java")
                dep_seen_by_kotlin_dir = os.path.join(dep_dir, "seen_by_kotlin")
                os.makedirs(dep_seen_by_java_dir)
                os.makedirs(dep_seen_by_kotlin_dir)
                dep_seen_by_java_sourcefile = os.path.join(
                    dep_seen_by_java_dir, dep_classname + ".java"
                )
                dep_seen_by_kotlin_sourcefile = os.path.join(
                    dep_seen_by_kotlin_dir, dep_classname + ".java"
                )
                with open(dep_seen_by_java_sourcefile, "w") as f:
                    f.write("public class %s { }" % dep_classname)
                with open(dep_seen_by_kotlin_sourcefile, "w") as f:
                    f.write("public class %s { void memberOnlySeenByKotlin() { } }" % dep_classname)
                jobs.append(
                    {
                        "first_extraction": first_extraction,
                        "jar_state": jar_state,
                        "class_file_state": class_file_state,
                        "dep_dir": dep_dir,
                        "dep_classname": dep_classname,
                        "dep_seen_by_java_dir": dep_seen_by_java_dir,
                        "dep_seen_by_kotlin_dir": dep_seen_by_kotlin_dir,
                        "dep_seen_by_java_sourcefile": dep_seen_by_java_sourcefile,
                        "dep_seen_by_kotlin_sourcefile": dep_seen_by_kotlin_sourcefile,
                    }
                )

    # Compile all the test classes we just generated, in two commands (since javac objects to seeing the same class file twice in one run)

    commands.run(["javac"] + [j["dep_seen_by_java_sourcefile"] for j in jobs])
    commands.run(["javac"] + [j["dep_seen_by_kotlin_sourcefile"] for j in jobs])

    # Create jar files and set class and jar files' relative timestamps for each dependency the two extractors will see:

    for j in jobs:
        os.remove(j["dep_seen_by_java_sourcefile"])
        os.remove(j["dep_seen_by_kotlin_sourcefile"])
        dep_seen_by_java_classfile = j["dep_seen_by_java_sourcefile"].replace(".java", ".class")
        dep_seen_by_kotlin_classfile = j["dep_seen_by_kotlin_sourcefile"].replace(".java", ".class")

        commands.run(
            [
                "touch",
                "-t",
                newer_datetime if j["class_file_state"] == "JavaClassFileNewer" else older_datetime,
                dep_seen_by_java_classfile,
            ]
        )
        commands.run(
            [
                "touch",
                "-t",
                (
                    newer_datetime
                    if j["class_file_state"] == "KotlinClassFileNewer"
                    else older_datetime
                ),
                dep_seen_by_kotlin_classfile,
            ]
        )

        if j["jar_state"] != "NoJar":
            classfile_name = os.path.basename(dep_seen_by_java_classfile)
            jar_command = ["jar", "cf", "dep.jar", classfile_name]
            commands.run(jar_command, _cwd=j["dep_seen_by_java_dir"])
            commands.run(jar_command, _cwd=j["dep_seen_by_kotlin_dir"])
            jar_seen_by_java = os.path.join(j["dep_seen_by_java_dir"], "dep.jar")
            jar_seen_by_kotlin = os.path.join(j["dep_seen_by_kotlin_dir"], "dep.jar")
            commands.run(
                [
                    "touch",
                    "-t",
                    newer_datetime if j["jar_state"] == "JavaJarNewer" else older_datetime,
                    jar_seen_by_java,
                ]
            )
            commands.run(
                [
                    "touch",
                    "-t",
                    newer_datetime if j["jar_state"] == "KotlinJarNewer" else older_datetime,
                    jar_seen_by_kotlin,
                ]
            )
            j["javac_classpath_entry"] = jar_seen_by_java
            j["kotlinc_classpath_entry"] = jar_seen_by_kotlin
        else:
            # No jar file involved, just add the dependency build directory to the classpath:
            j["javac_classpath_entry"] = j["dep_seen_by_java_dir"]
            j["kotlinc_classpath_entry"] = j["dep_seen_by_kotlin_dir"]

    # Create source files that instantiate each dependency type:

    kotlin_first_jobs = [j for j in jobs if j["first_extraction"] == "KotlinSeesFirst"]
    java_first_jobs = [j for j in jobs if j["first_extraction"] == "JavaSeesFirst"]
    kotlin_first_classes = [j["dep_classname"] for j in kotlin_first_jobs]
    java_first_classes = [j["dep_classname"] for j in java_first_jobs]

    kotlin_first_user = "kotlinFirstUser.kt"
    kotlin_second_user = "kotlinSecondUser.kt"
    java_first_user = "JavaFirstUser.java"
    java_second_user = "JavaSecondUser.java"

    def kotlin_instantiate_classes(classes):
        return "; ".join(["noop(%s())" % c for c in classes])

    def make_kotlin_user(user_filename, classes):
        with open(user_filename, "w") as f:
            f.write("fun noop(x: Any) { } fun user() { %s }" % kotlin_instantiate_classes(classes))

    make_kotlin_user(kotlin_first_user, kotlin_first_classes)
    make_kotlin_user(kotlin_second_user, java_first_classes)

    def java_instantiate_classes(classes):
        return " ".join(["noop(new %s());" % c for c in classes])

    def make_java_user(user_filename, classes):
        with open(user_filename, "w") as f:
            f.write(
                "public class %s { private static void noop(Object x) { } public static void user() { %s } }"
                % (user_filename.replace(".java", ""), java_instantiate_classes(classes))
            )

    make_java_user(java_first_user, java_first_classes)
    make_java_user(java_second_user, kotlin_first_classes)

    # Now finally make a database, including classes where Java sees them first followed by Kotlin and vice versa.
    # In all cases the Kotlin extraction should take precedence.

    def make_classpath(jobs, entry_name):
        return ":".join([j[entry_name] for j in jobs])

    kotlin_first_classpath = make_classpath(kotlin_first_jobs, "kotlinc_classpath_entry")
    java_first_classpath = make_classpath(java_first_jobs, "javac_classpath_entry")
    kotlin_second_classpath = make_classpath(java_first_jobs, "kotlinc_classpath_entry")
    java_second_classpath = make_classpath(kotlin_first_jobs, "javac_classpath_entry")

    codeql.database.create(
        command=[
            "kotlinc -cp %s %s" % (kotlin_first_classpath, kotlin_first_user),
            "javac -cp %s %s" % (java_first_classpath, java_first_user),
            "kotlinc -cp %s %s" % (kotlin_second_classpath, kotlin_second_user),
            "javac -cp %s %s" % (java_second_classpath, java_second_user),
        ]
    )
