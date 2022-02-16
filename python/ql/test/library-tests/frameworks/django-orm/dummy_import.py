# to force extractor to see files. since we use `--max-import-depth=1`, we use this
# "fake" import that doesn't actually work, but tricks the python extractor to look at
# all the files

from testapp import *
