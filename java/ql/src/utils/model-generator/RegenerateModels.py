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


defaultModelPath = "java/ql/lib/semmle/code/java/frameworks"
lgtmSlugToModelFile = {
    # "apache/commons-beanutils": "apache/BeanUtilsGenerated.qll",
    # "apache/commons-codec": "apache/CodecGenerated.qll",
    # "apache/commons-lang": "apache/Lang3Generated.qll",
    "apache/commons-io": "apache/IOGenerated.qll",
}


def findGitRoot():
    return subprocess.check_output(
        ["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()


def regenerateModel(lgtmSlug, extractedDb):
    tmpDir = tempfile.mkdtemp()
    print("============================================================")
    print("Generating models for " + lgtmSlug)
    print("============================================================")
    # check if lgtmSlug exists as key
    if lgtmSlug not in lgtmSlugToModelFile:
        print("ERROR: slug " + lgtmSlug +
              " is not mapped to a model file in script " + sys.argv[0])
        sys.exit(1)
    modelFile = defaultModelPath + "/" + lgtmSlugToModelFile[lgtmSlug]
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
