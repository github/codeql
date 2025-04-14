# when updating this list, `bazel mod tidy` should be run from `codeql` to update `MODULE.bazel`
VERSIONS = [
    "1.5.0",
    "1.5.10",
    "1.5.20",
    "1.5.30",
    "1.6.0",
    "1.6.20",
    "1.7.0",
    "1.7.20",
    "1.8.0",
    "1.9.0-Beta",
    "1.9.20-Beta",
    "2.0.0-RC1",
    "2.0.20-Beta2",
    "2.1.0-Beta1",
    "2.1.20-Beta1",
]

def _version_to_tuple(v):
    # we ignore the tag when comparing versions, for example 1.9.0-Beta <= 1.9.0
    v, _, ignored_tag = v.partition("-")
    return tuple([int(x) for x in v.split(".")])

def version_less(lhs, rhs):
    return _version_to_tuple(lhs) < _version_to_tuple(rhs)

def get_language_version(version):
    major, minor, _ = _version_to_tuple(version)
    return "%s.%s" % (major, minor)

def _basename(path):
    if "/" not in path:
        return path
    return path[path.rindex("/") + 1:]

def get_compatilibity_sources(version, dir):
    prefix = "%s/v_" % dir
    available = native.glob(["%s*" % prefix], exclude_directories = 0)

    # we want files with the same base name to replace ones for previous versions, hence the map
    srcs = {}
    for d in available:
        compat_version = d[len(prefix):].replace("_", ".")
        if version_less(version, compat_version):
            break
        files = native.glob(["%s/*.kt" % d])
        srcs |= {_basename(f): f for f in files}
    return srcs.values()
