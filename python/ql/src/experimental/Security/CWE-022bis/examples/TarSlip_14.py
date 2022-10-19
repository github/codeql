# https://github.com/tensorflow/tensor2tensor
import tarfile
import os.path
import sys

# provie the malign archive
filename = sys.argv[1]
tmp_dir = "/tmp/"

read_type = "r:gz" if filename.endswith("tgz") else "r"
with tarfile.open(filename, read_type) as corpus_tar:
    # Create a subset of files that don't already exist.
    #   tarfile.extractall errors when encountering an existing file
    #   and tarfile.extract is extremely slow
    members = []
    for f in corpus_tar:
        if not os.path.isfile(os.path.join(tmp_dir, f.name)):
            members.append(f)
    corpus_tar.extractall(tmp_dir, members=members)
