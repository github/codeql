#!/usr/bin/env python3

import glob
import re
import subprocess
import shutil
import os
import os.path
import sys

kotlinc = 'kotlinc'
javac = 'javac'


def compile_to_dir(srcs, classpath, java_classpath, output):
    # Use kotlinc to compile .kt files:
    subprocess.run([kotlinc,
                    '-d', output,
                    '-module-name', 'codeql-kotlin-extractor',
                    '-no-reflect',
                    '-jvm-target', '1.8',
                    '-classpath', classpath] + srcs, check=True)
    # Use javac to compile .java files, referencing the Kotlin class files:
    subprocess.run([javac,
                    '-d', output,
                    '-source', '8', '-target', '8',
                    '-classpath', "%s:%s:%s" % (output, classpath, java_classpath)] + [s for s in srcs if s.endswith(".java")], check=True)


def compile_to_jar(srcs, classpath, java_classpath, output):
    builddir = 'build/classes'

    try:
        if os.path.exists(builddir):
            shutil.rmtree(builddir)
        os.makedirs(builddir)

        compile_to_dir(srcs, classpath, java_classpath, builddir)

        subprocess.run(['jar', '-c', '-f', output,
                        '-C', builddir, '.',
                        '-C', 'src/main/resources', 'META-INF'], check=True)
    finally:
        if os.path.exists(builddir):
            shutil.rmtree(builddir)


def find_sources(path):
    return glob.glob(path + '/**/*.kt', recursive=True) + glob.glob(path + '/**/*.java', recursive=True)


def jarnames_to_classpath(path, jars):
    return ":".join(os.path.join(path, jar) + ".jar" for jar in jars)


def compile_standalone():
    srcs = find_sources("src")
    jars = ['kotlin-compiler']
    java_jars = ['kotlin-stdlib']

    x = subprocess.run([kotlinc, '-version', '-verbose'],
                       check=True, capture_output=True)
    output = x.stderr.decode(encoding='UTF-8', errors='strict')
    m = re.match(
        r'.*\nlogging: using Kotlin home directory ([^\n]+)\n.*', output)
    if m is None:
        raise Exception('Cannot determine kotlinc home directory')
    kotlin_home = m.group(1)
    kotlin_lib = kotlin_home + '/lib'
    classpath = jarnames_to_classpath(kotlin_lib, jars)
    java_classpath = jarnames_to_classpath(kotlin_lib, java_jars)

    compile_to_jar(srcs, classpath, java_classpath, 'codeql-extractor-kotlin-standalone.jar')


def find_jar(path, pattern):
    result = glob.glob(path + '/' + pattern + '*.jar')
    if len(result) == 0:
        raise Exception('Cannot find jar file %s under path %s' % (pattern, path))
    return result


def patterns_to_classpath(path, patterns):
    result = []
    for pattern in patterns:
        result += find_jar(path, pattern)
    return ':'.join(result)


def compile_embeddable():
    x = subprocess.run(['gradle', 'getHomeDir'],
                       check=True, capture_output=True)
    output = x.stdout.decode(encoding='UTF-8', errors='strict')
    m = re.search(r'(?m)^> Task :getHomeDir\n([^\n]+)$', output)
    if m is None:
        print("gradle getHomeDir output:\n" + output, file = sys.stderr)
        raise Exception('Cannot determine gradle home directory')
    gradle_home = m.group(1)

    gradle_lib = gradle_home + '/lib'
    jar_patterns = ['kotlin-compiler-embeddable']
    java_jar_patterns = ['kotlin-stdlib']
    classpath = patterns_to_classpath(gradle_lib, jar_patterns)
    java_classpath = patterns_to_classpath(gradle_lib, java_jar_patterns)

    try:
        if os.path.exists('build/temp_src'):
            shutil.rmtree('build/temp_src')
        shutil.copytree('src', 'build/temp_src')
        srcs = find_sources('build/temp_src')

        # replace imports in files:
        for src in srcs:
            with open(src, 'r') as f:
                content = f.read()
            content = content.replace('import com.intellij',
                                      'import org.jetbrains.kotlin.com.intellij')
            with open(src, 'w') as f:
                f.write(content)

        compile_to_jar(srcs, classpath, java_classpath, 'codeql-extractor-kotlin-embeddable.jar')
    finally:
        if os.path.exists('build/temp_src'):
            shutil.rmtree('build/temp_src')


compile_standalone()
compile_embeddable()
