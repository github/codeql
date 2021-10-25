#!/usr/bin/python

import glob
import re
import subprocess

kotlinc = 'kotlinc'
srcs = glob.glob('src/**/*.kt', recursive=True)
jars = ['kotlin-compiler']

x = subprocess.run([kotlinc, '-version', '-verbose'], check=True, capture_output=True)
output = x.stderr.decode(encoding = 'UTF-8',errors = 'strict')
m = re.match(r'.*\nlogging: using Kotlin home directory ([^\n]+)\n.*', output)
if m is None:
    raise Exception('Cannot determine kotlinc home directory')
kotlin_home = m.group(1)
kotlin_lib = kotlin_home + '/lib'
classpath = ':'.join(map(lambda j: kotlin_lib + '/' + j + '.jar', jars))

subprocess.run([kotlinc,
                '-d', 'codeql-extractor-kotlin.jar',
                '-module-name', 'codeql-kotlin-extractor',
                '-no-reflect',
                '-jvm-target', '1.8',
                '-classpath', classpath] + srcs , check=True)
subprocess.run(['jar', '-u', '-f', 'codeql-extractor-kotlin.jar', '-C', 'src/main/resources', 'META-INF'], check=True)

