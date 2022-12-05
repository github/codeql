#!/usr/bin/python3

import sys
import subprocess
import os

gitroot = subprocess.check_output(['git', 'rev-parse', '--show-toplevel']).decode('utf-8').strip()
minJdk = 7
maxJdk = 18

dbRootPath = str(sys.argv[1])

def generateSinkModels():
    for i in range(minJdk, maxJdk + 1):
        db = f'{dbRootPath}jdk{i}'
        output = f'jdk/Jdk{i}Generated.qll'
        print(f'Generating {output} from {db}')
        subprocess.call([f'{gitroot}/java/ql/src/utils/model-generator/GenerateFlowModel.py', db, output, f'Java JDK {i}', '--with-sinks'])


def generateDiffs():
    for i in range(minJdk, maxJdk):
        diff = subprocess.check_output(
            f'diff -u {gitroot}/java/ql/lib/semmle/code/java/frameworks/jdk/Jdk{i}Generated.qll {gitroot}/java/ql/lib/semmle/code/java/frameworks/jdk/Jdk{i + 1}Generated.qll | grep -E "^\+" | cut -c 2- | tail +4', shell=True) \
                .decode('utf-8') \
                .rstrip() \
                .rstrip(',')
        path = f'{gitroot}/java/ql/lib/semmle/code/java/frameworks/jdk/Jdk{i + 1}Diff.qll'
        if diff:
            print(f'Generating diff for JDK {i + 1}')
            with open(path, "w") as diffQll:
                diffQll.write(f'''import java
private import semmle.code.java.dataflow.ExternalFlow

private class Jdk{i + 1}DiffSinksCsv extends SinkModelCsv {{
  override predicate row(string row) {{
    row =
      [
{diff}
      ]
  }}
}}
''')
        else:
            print(f'No diff for JDK {i + 1}')
            if os.path.isfile(path):
                os.remove(path)

def generateMain():
    imports = ''
    if (os.path.isfile(f'{gitroot}/java/ql/lib/semmle/code/java/frameworks/jdk/Jdk{minJdk}Generated.qll')):
         imports += f'private import Jdk{minJdk}Generated\n'

    for i in range(minJdk + 1, maxJdk +1):
        if (os.path.isfile(f'{gitroot}/java/ql/lib/semmle/code/java/frameworks/jdk/Jdk{i}Diff.qll')):
            imports += f'private import Jdk{i}Diff\n'

    with open(f'{gitroot}/java/ql/lib/semmle/code/java/frameworks/jdk/Generated.qll', "w") as mainQll:
        mainQll.write(f'''/**
 * This file references the JDK sink models.
 * JDK {minJdk} was generated and not modified. The other referenced files are only diffs between the generated ones.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow
{imports}''')

def cleanup():
    for i in range(minJdk, maxJdk + 1):
        path = f'{gitroot}/java/ql/lib/semmle/code/java/frameworks/jdk/Jdk{i}Generated.qll'
        if os.path.isfile(path):
            os.remove(path)
        path = f'{gitroot}/java/ql/lib/semmle/code/java/frameworks/jdk/Jdk{i}Diff.qll'
        if os.path.isfile(path):
            os.remove(path)
    generateMain()

#cleanup()
# run these a couple of times, until no more changes are made:
generateSinkModels()
generateDiffs()
generateMain()