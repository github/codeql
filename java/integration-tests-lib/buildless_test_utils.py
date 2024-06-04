import sys
import os.path
import glob

def extract_fetched_jar_path(l):
  if not l.startswith("["):
    # Line continuation
    return None
  bits = l.split(" ", 3) # date time processid logline
  if len(bits) >= 4 and bits[3].startswith("Fetch "):
    return bits[3][6:].strip()
  else:
    return None

def read_fetched_jars(fname):
  with open(fname, "r") as f:
    lines = [l for l in f]
    return [l for l in map(extract_fetched_jar_path, lines) if l is not None]

def check_buildless_fetches():

  extractor_logs = glob.glob(os.path.join("test-db", "log", "javac-extractor-*.log"))
  fetched_jars = map(read_fetched_jars, extractor_logs)
  all_fetched_jars = tuple(sorted([item for sublist in fetched_jars for item in sublist]))

  try:
    with open("buildless-fetches.expected", "r") as f:  
      expected_jar_fetches = tuple(l.strip() for l in f)
  except FileNotFoundError:
    expected_jar_fetches = tuple()

  if all_fetched_jars != expected_jar_fetches:
    print("Expected jar fetch mismatch. Expected:\n%s\n\nActual:\n%s" % ("\n".join(expected_jar_fetches), "\n".join(all_fetched_jars)), file = sys.stderr)
    with open("buildless-fetches.actual", "w") as f:
      for j in all_fetched_jars:
        f.write(j + "\n")
    sys.exit(1)
