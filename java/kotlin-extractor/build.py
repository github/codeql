#!/usr/bin/env python3

import kotlin_plugin_versions
import glob
import re
import subprocess
import shutil
import os
import os.path
import sys
import shlex

kotlinc = 'kotlinc'
javac = 'javac'

kotlin_dependency_folder = '../../../resources/kotlin-dependencies'
if (len(sys.argv) > 1):
    kotlin_dependency_folder = sys.argv[1]


def run_process(cmd):
    try:
        # print("Running command: " + shlex.join(cmd))
        return subprocess.run(cmd, check=True, capture_output=True)
    except subprocess.CalledProcessError as e:
        print("Command failed: " + shlex.join(cmd), file=sys.stderr)
        print("Output: " + e.stderr.decode(encoding='UTF-8',
              errors='strict'), file=sys.stderr)
        raise e


def compile_to_dir(srcs, classpath, java_classpath, output):
    # Use kotlinc to compile .kt files:
    run_process([kotlinc,
                 # kotlinc can default to 256M, which isn't enough when we are extracting the build
                 '-J-Xmx2G',
                 '-d', output,
                 '-module-name', 'codeql-kotlin-extractor',
                 '-no-reflect', '-no-stdlib',
                 '-jvm-target', '1.8',
                 '-classpath', classpath] + srcs)

    # Use javac to compile .java files, referencing the Kotlin class files:
    run_process([javac,
                 '-d', output,
                 '-source', '8', '-target', '8',
                 '-classpath', "%s:%s:%s" % (output, classpath, java_classpath)] + [s for s in srcs if s.endswith(".java")])


def compile_to_jar(srcs, classpath, java_classpath, output):
    builddir = 'build/classes'

    try:
        if os.path.exists(builddir):
            shutil.rmtree(builddir)
        os.makedirs(builddir)

        compile_to_dir(srcs, classpath, java_classpath, builddir)

        run_process(['jar', '-c', '-f', output,
                     '-C', builddir, '.',
                     '-C', 'src/main/resources', 'META-INF'])
    finally:
        if os.path.exists(builddir):
            shutil.rmtree(builddir)


def find_sources(path):
    return glob.glob(path + '/**/*.kt', recursive=True) + glob.glob(path + '/**/*.java', recursive=True)


def get_kotlin_lib_folder():
    x = run_process([kotlinc, '-version', '-verbose'])
    output = x.stderr.decode(encoding='UTF-8', errors='strict')
    m = re.match(
        r'.*\nlogging: using Kotlin home directory ([^\n]+)\n.*', output)
    if m is None:
        raise Exception('Cannot determine kotlinc home directory')
    kotlin_home = m.group(1)
    print("Kotlin home directory: " + kotlin_home)
    return kotlin_home + '/lib'


def get_gradle_lib_folder():
    x = run_process(['gradle', 'getHomeDir'])
    output = x.stdout.decode(encoding='UTF-8', errors='strict')
    m = re.search(r'(?m)^> Task :getHomeDir\n([^\n]+)$', output)
    if m is None:
        print("gradle getHomeDir output:\n" + output, file=sys.stderr)
        raise Exception('Cannot determine gradle home directory')
    gradle_home = m.group(1)
    print("Gradle home directory: " + gradle_home)
    return gradle_home + '/lib'


def find_jar(path, pattern):
    result = glob.glob(path + '/' + pattern + '*.jar')
    if len(result) == 0:
        raise Exception('Cannot find jar file %s under path %s' %
                        (pattern, path))
    return result


def patterns_to_classpath(path, patterns):
    result = []
    for pattern in patterns:
        result += find_jar(path, pattern)
    return ':'.join(result)


def transform_to_embeddable(srcs):
    # replace imports in files:
    for src in srcs:
        with open(src, 'r') as f:
            content = f.read()
        content = content.replace('import com.intellij',
                                  'import org.jetbrains.kotlin.com.intellij')
        with open(src, 'w') as f:
            f.write(content)


def compile(jars, java_jars, dependency_folder, transform_to_embeddable, output, tmp_dir):
    classpath = patterns_to_classpath(dependency_folder, jars)
    java_classpath = patterns_to_classpath(dependency_folder, java_jars)

    try:
        if os.path.exists(tmp_dir):
            shutil.rmtree(tmp_dir)
        shutil.copytree('src', tmp_dir)
        srcs = find_sources(tmp_dir)

        transform_to_embeddable(srcs)

        compile_to_jar(srcs, classpath, java_classpath, output)
    finally:
        if os.path.exists(tmp_dir):
            shutil.rmtree(tmp_dir)


def compile_embeddable(version):
    compile(['kotlin-stdlib-' + version, 'kotlin-compiler-embeddable-' + version],
            ['kotlin-stdlib-' + version],
            kotlin_dependency_folder,
            transform_to_embeddable,
            'codeql-extractor-kotlin-embeddable-%s.jar' % (version),
            'build/temp_src')


def compile_standalone(version):
    compile(['kotlin-stdlib-' + version, 'kotlin-compiler-' + version],
            ['kotlin-stdlib-' + version],
            kotlin_dependency_folder,
            lambda srcs: None,
            'codeql-extractor-kotlin-standalone-%s.jar' % (version),
            'build/temp_src')


for version in kotlin_plugin_versions.versions:
    compile_standalone(version)
    compile_embeddable(version)
