# when updating this list, `bazel mod tidy` should be run from `codeql` to update `MODULE.bazel`
VERSIONS = [
    "1.4.32",
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
    "2.0.0-Beta4",
    "2.0.255-SNAPSHOT",
]

DEFAULT_FALLBACK_VERSION = "1.9.0-Beta"

def _version_to_tuple(v):
    v, _, tail = v.partition("-")
    v = tuple([int(x) for x in v.split(".")])
    return v + (tail,)

def _tuple_to_version(t):
    ret = ".".join([str(x) for x in t[:3]])
    if t[3]:
        ret += "-" + t[3]
    return ret

def version_less(lhs, rhs):
    return _version_to_tuple(lhs) < _version_to_tuple(rhs)

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
