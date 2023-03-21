#!/usr/bin/env python3

import argparse
import kotlin_plugin_versions
import glob
import platform
import re
import subprocess
import shutil
import os
import os.path
import sys
import shlex
import distutils
from distutils import dir_util


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--dependencies', default='../../../resources/kotlin-dependencies',
                        help='Folder containing the dependencies')
    parser.add_argument('--many', action='store_true',
                        help='Build for all versions/kinds')
    parser.add_argument('--single', action='store_false',
                        dest='many', help='Build for a single version/kind')
    parser.add_argument('--single-version',
                        help='Build for a specific version/kind')
    parser.add_argument('--single-version-embeddable', action='store_true',
                        help='When building a single version, build an embeddable extractor (default is standalone)')
    return parser.parse_args()


args = parse_args()


def is_windows():
    '''Whether we appear to be running on Windows'''
    if platform.system() == 'Windows':
        return True
    if platform.system().startswith('CYGWIN'):
        return True
    return False


# kotlinc might be kotlinc.bat or kotlinc.cmd on Windows, so we use `which` to find out what it is
kotlinc = shutil.which('kotlinc')
if kotlinc is None:
    print("Cannot build the Kotlin extractor: no kotlinc found on your PATH", file=sys.stderr)
    sys.exit(1)

javac = 'javac'
kotlin_dependency_folder = args.dependencies


def quote_for_batch(arg):
    if ';' in arg or '=' in arg:
        if '"' in arg:
            raise Exception('Need to quote something containing a quote')
        return '"' + arg + '"'
    else:
        return arg


def run_process(cmd, capture_output=False):
    print("Running command: " + shlex.join(cmd))
    if is_windows():
        cmd = ' '.join(map(quote_for_batch, cmd))
        print("Converted to Windows command: " + cmd)
    try:
        if capture_output:
            return subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        else:
            return subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        print("In: " + os.getcwd(), file=sys.stderr)
        shell_cmd = cmd if is_windows() else shlex.join(cmd)
        print("Command failed: " + shell_cmd, file=sys.stderr)
        if capture_output:
            print("stdout output:\n" + e.stdout.decode(encoding='UTF-8',
                  errors='replace'), file=sys.stderr)
            print("stderr output:\n" + e.stderr.decode(encoding='UTF-8',
                  errors='replace'), file=sys.stderr)
        raise e


def compile_to_dir(srcs, classpath, java_classpath, output):
    # Use kotlinc to compile .kt files:
    run_process([kotlinc,
                 # kotlinc can default to 256M, which isn't enough when we are extracting the build
                 '-J-Xmx2G',
                 '-Werror',
                 '-opt-in=kotlin.RequiresOptIn',
                 '-d', output,
                 '-module-name', 'codeql-kotlin-extractor',
                 '-no-reflect', '-no-stdlib',
                 '-jvm-target', '1.8',
                 '-classpath', classpath] + srcs)

    # Use javac to compile .java files, referencing the Kotlin class files:
    run_process([javac,
                 '-d', output,
                 '-source', '8', '-target', '8',
                 '-classpath', os.path.pathsep.join([output, classpath, java_classpath])] + [s for s in srcs if s.endswith(".java")])


def compile_to_jar(build_dir, tmp_src_dir, srcs, classpath, java_classpath, output):
    class_dir = build_dir + '/classes'

    if os.path.exists(class_dir):
        shutil.rmtree(class_dir)
    os.makedirs(class_dir)

    compile_to_dir(srcs, classpath, java_classpath, class_dir)

    run_process(['jar', 'cf', output,
                 '-C', class_dir, '.',
                 '-C', tmp_src_dir + '/main/resources', 'META-INF',
                 '-C', tmp_src_dir + '/main/resources', 'com/github/codeql/extractor.name'])
    shutil.rmtree(class_dir)


def find_sources(path):
    return glob.glob(path + '/**/*.kt', recursive=True) + glob.glob(path + '/**/*.java', recursive=True)


def get_kotlin_lib_folder():
    x = run_process([kotlinc, '-version', '-verbose'], capture_output=True)
    output = x.stderr.decode(encoding='UTF-8', errors='strict')
    m = re.match(
        r'.*\nlogging: using Kotlin home directory ([^\n]+)\n.*', output)
    if m is None:
        raise Exception('Cannot determine kotlinc home directory')
    kotlin_home = m.group(1)
    print("Kotlin home directory: " + kotlin_home)
    return kotlin_home + '/lib'


def get_gradle_lib_folder():
    x = run_process(['gradle', 'getHomeDir'], capture_output=True)
    output = x.stdout.decode(encoding='UTF-8', errors='strict')
    m = re.search(r'(?m)^> Task :getHomeDir\n([^\n]+)$', output)
    if m is None:
        print("gradle getHomeDir output:\n" + output, file=sys.stderr)
        raise Exception('Cannot determine gradle home directory')
    gradle_home = m.group(1)
    print("Gradle home directory: " + gradle_home)
    return gradle_home + '/lib'


def find_jar(path, base):
    fn = path + '/' + base + '.jar'
    if not os.path.isfile(fn):
        raise Exception('Cannot find jar file at %s' % fn)
    return fn


def bases_to_classpath(path, bases):
    result = []
    for base in bases:
        result.append(find_jar(path, base))
    return os.path.pathsep.join(result)


def transform_to_embeddable(srcs):
    # replace imports in files:
    for src in srcs:
        with open(src, 'r') as f:
            content = f.read()
        content = content.replace('import com.intellij',
                                  'import org.jetbrains.kotlin.com.intellij')
        with open(src, 'w') as f:
            f.write(content)


def compile(jars, java_jars, dependency_folder, transform_to_embeddable, output, build_dir, current_version):
    classpath = bases_to_classpath(dependency_folder, jars)
    java_classpath = bases_to_classpath(dependency_folder, java_jars)

    tmp_src_dir = build_dir + '/temp_src'

    if os.path.exists(tmp_src_dir):
        shutil.rmtree(tmp_src_dir)
    shutil.copytree('src', tmp_src_dir)

    include_version_folder = tmp_src_dir + '/main/kotlin/utils/versions/to_include'
    os.makedirs(include_version_folder)

    resource_dir = tmp_src_dir + '/main/resources/com/github/codeql'
    os.makedirs(resource_dir)
    with open(resource_dir + '/extractor.name', 'w') as f:
        f.write(output)

    parsed_current_version = kotlin_plugin_versions.version_string_to_tuple(
        current_version)

    for version in kotlin_plugin_versions.many_versions:
        parsed_version = kotlin_plugin_versions.version_string_to_tuple(
            version)
        if parsed_version[0] < parsed_current_version[0] or \
            (parsed_version[0] == parsed_current_version[0] and parsed_version[1] < parsed_current_version[1]) or \
                (parsed_version[0] == parsed_current_version[0] and parsed_version[1] == parsed_current_version[1] and parsed_version[2] <= parsed_current_version[2]):
            d = tmp_src_dir + '/main/kotlin/utils/versions/v_' + \
                version.replace('.', '_')
            if os.path.exists(d):
                # copy and overwrite files from the version folder to the include folder
                distutils.dir_util.copy_tree(d, include_version_folder)

    # remove all version folders:
    for version in kotlin_plugin_versions.many_versions:
        d = tmp_src_dir + '/main/kotlin/utils/versions/v_' + \
            version.replace('.', '_')
        if os.path.exists(d):
            shutil.rmtree(d)

    srcs = find_sources(tmp_src_dir)

    transform_to_embeddable(srcs)

    compile_to_jar(build_dir, tmp_src_dir, srcs, classpath, java_classpath, output)

    shutil.rmtree(tmp_src_dir)


def compile_embeddable(version):
    compile(['kotlin-stdlib-' + version, 'kotlin-compiler-embeddable-' + version],
            ['kotlin-stdlib-' + version],
            kotlin_dependency_folder,
            transform_to_embeddable,
            'codeql-extractor-kotlin-embeddable-%s.jar' % (version),
            'build_embeddable_' + version,
            version)


def compile_standalone(version):
    compile(['kotlin-stdlib-' + version, 'kotlin-compiler-' + version],
            ['kotlin-stdlib-' + version],
            kotlin_dependency_folder,
            lambda srcs: None,
            'codeql-extractor-kotlin-standalone-%s.jar' % (version),
            'build_standalone_' + version,
            version)


if args.single_version:
    if args.single_version_embeddable == True:
        compile_embeddable(args.single_version)
    else:
        compile_standalone(args.single_version)
elif args.single_version_embeddable == True:
    print("--single-version-embeddable requires --single-version", file=sys.stderr)
    sys.exit(1)
elif args.many:
    for version in kotlin_plugin_versions.many_versions:
        compile_standalone(version)
        compile_embeddable(version)
else:
    compile_standalone(kotlin_plugin_versions.get_single_version())
