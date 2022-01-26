#!/usr/bin/python3

# Tool to regenerate existing framework CSV models.

from pathlib import Path
import json
import os
import requests
import shutil
import subprocess
import tempfile
import sys


lgtmSlugToModelFile = {
    # "apache/commons-beanutils": "java/ql/lib/semmle/code/java/frameworks/apache/BeanUtilsGenerated.qll",
    # "apache/commons-codec": "java/ql/lib/semmle/code/java/frameworks/apache/CodecGenerated.qll",
    # "apache/commons-lang": "java/ql/lib/semmle/code/java/frameworks/apache/Lang3Generated.qll",
    "apache/commons-io": "java/ql/lib/semmle/code/java/frameworks/apache/IOGenerated.qll",
}


def findGitRoot():
    return subprocess.check_output(
        ["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()


def regenerateModel(lgtmSlug, extractedDb):
    tmpDir = tempfile.mkdtemp()
    print("============================================================")
    print("Generating models for " + lgtmSlug)
    print("============================================================")
    modelFile = lgtmSlugToModelFile[lgtmSlug]
    codeQlRoot = findGitRoot()
    targetModel = codeQlRoot + "/" + modelFile
    subprocess.check_call([codeQlRoot + "/java/ql/src/utils/model-generator/GenerateFlowModel.py", extractedDb,
                           targetModel])
    print("Regenerated " + targetModel)
    shutil.rmtree(tmpDir)


if len(sys.argv) == 3:
    lgtmSlug = sys.argv[1]
    db = sys.argv[2]
    regenerateModel(lgtmSlug, db)
else:
    print('error')
