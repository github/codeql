import os
import glob

thisdir = os.path.dirname(os.path.realpath(__file__))

toupdate = dict()

startstr = "// BEGIN ALIASES.QLL"
endstr = "// END ALIASES.QLL"

somelibcontentf = None
somelibcontent = None

for f in glob.glob(os.path.join(thisdir, "*.ql")):
  with open(f, "r") as fp:
    content = fp.read()
  idx = content.index(startstr)
  if idx != 0 and idx != -1:
    raise Exception("Expected file %s that contains aliases.qll to start with it (found it at offset %d)" % (f, idx))
  if idx == 0:
    endidx = content.index(endstr)
    if endidx == -1:
      raise Exception("Expected file %s that contains aliases.qll to contain the end-of-library token %s" % (f, endstr))
    libcontent = content[idx : endidx + len(endstr)]
    toupdate[f] = (content, libcontent)
    somelibcontentf = f
    somelibcontent = libcontent

for (f, (content, libcontent)) in toupdate.items():
  if libcontent != somelibcontent:
    raise Exception("Files that include aliases.qll disagree about its content (e.g., files %s and %s)" % (somelibcontentf, f))

print("Updating %d files that include aliases.qll" % len(toupdate))

with open(os.path.join(thisdir, "aliases.qll"), "r") as fp:
  newlibcontent = fp.read().strip()

for (f, (content, _)) in toupdate.items():
  with open(f, "w") as fp:
    fp.write(newlibcontent + content[len(somelibcontent):])
