#!/usr/bin/python3

import sys
import subprocess
import os
import shutil

gitroot = subprocess.check_output(['git', 'rev-parse', '--show-toplevel']).decode('utf-8').strip()
minJdk = 7
maxJdk = 18

dbRootPath = str(sys.argv[1])

def generateSinkModels():
    for i in range(minJdk, maxJdk + 1):
        db = f'{dbRootPath}jdk{i}'
        output = f'jdk/jdk{i}.generated.notincluded.yml'
        print(f'Generating {output} from {db}')
        subprocess.call([f'{gitroot}/java/ql/src/utils/model-generator/GenerateFlowModel.py', db, output, f'Java JDK {i}', '--with-sinks'])


def generateDiffs():
    for i in range(minJdk, maxJdk):
        diff = subprocess.check_output(
            f'diff -u {gitroot}/java/ql/lib/ext/generated/jdk/jdk{i}.generated.notincluded.yml {gitroot}/java/ql/lib/ext/generated/jdk/jdk{i + 1}.generated.notincluded.yml | grep -E "^\+" | cut -c 2- | tail +3', shell=True) \
                .decode('utf-8') \
                .rstrip() \
                .rstrip(',')
        path = f'{gitroot}/java/ql/lib/ext/generated/jdk/jdk{i + 1}.diff.model.yml'
        if diff:
            print(f'Generating diff for JDK {i + 1}')
            with open(path, "w") as diffQll:
                diffQll.write(f'''# THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
# Definitions of taint steps in the Java JDK {i + 1} framework.

extensions:
  - addsTo:
      pack: codeql/java-all
      extensible: extSinkModel
    data:
{diff}
''')
        else:
            print(f'No diff for JDK {i + 1}')
            if os.path.isfile(path):
                os.remove(path)


def copyInitial():
    src = f'{gitroot}/java/ql/lib/ext/generated/jdk/jdk{minJdk}.generated.notincluded.yml'
    dst = f'{gitroot}/java/ql/lib/ext/generated/jdk/jdk{minJdk}.generated.model.yml'
    shutil.copyfile(src, dst)


def cleanup():
    path = f'{gitroot}/java/ql/lib/ext/generated/jdk/jdk{minJdk}.generated.model.yml'
    if os.path.isfile(path):
        os.remove(path)
    for i in range(minJdk, maxJdk + 1):
        path = f'{gitroot}/java/ql/lib/ext/generated/jdk/jdk{i}.generated.notincluded.yml'
        if os.path.isfile(path):
            os.remove(path)
        path = f'{gitroot}/java/ql/lib/ext/generated/jdk/jdk{i}.diff.model.yml'
        if os.path.isfile(path):
            os.remove(path)


# cleanup()
# run these a couple of times, until no more changes are made:
for _ in range(3):
    generateSinkModels()
    generateDiffs()
    copyInitial()
