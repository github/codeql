#!/usr/bin/env python3

import glob
import re
import subprocess
import shutil

kotlinc = 'kotlinc'


def compile(srcs, classpath, output):
    subprocess.run([kotlinc,
                    '-d', output,
                    '-module-name', 'codeql-kotlin-extractor',
                    '-no-reflect',
                    '-jvm-target', '1.8',
                    '-classpath', classpath] + srcs, check=True)
    subprocess.run(['jar', '-u', '-f', output,
                    '-C', 'src/main/resources', 'META-INF'], check=True)


def compile_standalone():
    srcs = glob.glob('src/**/*.kt', recursive=True)
    jars = ['kotlin-compiler']

    x = subprocess.run([kotlinc, '-version', '-verbose'],
                       check=True, capture_output=True)
    output = x.stderr.decode(encoding='UTF-8', errors='strict')
    m = re.match(
        r'.*\nlogging: using Kotlin home directory ([^\n]+)\n.*', output)
    if m is None:
        raise Exception('Cannot determine kotlinc home directory')
    kotlin_home = m.group(1)
    kotlin_lib = kotlin_home + '/lib'
    classpath = ':'.join(map(lambda j: kotlin_lib + '/' + j + '.jar', jars))

    compile(srcs, classpath, 'codeql-extractor-kotlin-standalone.jar')


def compile_embeddable():
    x = subprocess.run(['gradle', 'getHomeDir'],
                       check=True, capture_output=True)
    output = x.stdout.decode(encoding='UTF-8', errors='strict')
    m = re.match(
        r'.*\n> Task :getHomeDir\n([^\n]+)\n.*', output)
    if m is None:
        raise Exception('Cannot determine gradle home directory')
    gradle_home = m.group(1)

    gradle_lib = gradle_home + '/lib'
    jar_patterns = ['kotlin-compiler-embeddable']
    jar_files = []
    for pattern in jar_patterns:
        jar_files += glob.glob(gradle_lib + '/' + pattern + '*.jar')
        if len(jar_files) == 0:
            raise Exception('Cannot find gradle jar files')
    classpath = ':'.join(jar_files)

    try:
        shutil.copytree('src', 'build/temp_src')
        srcs = glob.glob('build/temp_src/**/*.kt', recursive=True)

        # replace imports in files:
        for src in srcs:
            with open(src, 'r') as f:
                content = f.read()
            content = content.replace('import com.intellij',
                                      'import org.jetbrains.kotlin.com.intellij')
            with open(src, 'w') as f:
                f.write(content)

        compile(srcs, classpath, 'codeql-extractor-kotlin-embeddable.jar')
    finally:
        shutil.rmtree('build/temp_src')


compile_standalone()
compile_embeddable()
