# when updating this list, `bazel mod tidy` should be run from `codeql` to update `MODULE.bazel`
# when adding a new version, start out with {}, then run `bazel fetch //java/kotlin-extractor:all`
# (`bazel fetch @codeql//java/kotlin-extractor:all` from `semmle-code`).
# Repeat while it will fail printing what to add here.
# Alternatively, run `sha256sum` on the files to get what to write here.
VERSIONS = {
    "1.5.0": {
        "compiler": "f6e4a2c4394e77f937fcffda0036531604f25cc7c8de8daea098e1aa31f1d248",
        "compiler-embeddable": "d7b85448039e468daf3b9462a172244477fa3eb890f199ec77703992f36ade44",
        "stdlib": "52283996fe4067cd7330288b96ae67ecd463614dc741172c54d9d349ab6a9cd7",
    },
    "1.5.10": {
        "compiler": "dfefb1aa8bec81256617c8ceb577373e44078b7e21024625da50e376037e9ae5",
        "compiler-embeddable": "b9965f7c958efb17f2a90a19b5e60325d4f4e644d2833dbfb4a11edd8dddf244",
        "stdlib": "ca87c454cd3f2e60931f1803c59699d510d3b4b959cd7119296fb947581d722d",
    },
    "1.5.20": {
        "compiler": "a0ae437d1b670a5ba6da7893b7023df649c4ab2e6c19d5e9b4eee5332e1cde1f",
        "compiler-embeddable": "11d51087eb70b5abbad6fbf459a4349a0335916588000b5ecd990f01482e38ff",
        "stdlib": "80cd79c26aac46d72d782de1ecb326061e93c6e688d994b48627ffd668ba63a8",
    },
    "1.5.30": {
        "compiler": "487d8ff9766a6ba570cd15c5225c1600654e7cf1b6ef2b92ed6905528a3e838a",
        "compiler-embeddable": "b5051dc92725b099c41710bd3f213cd0c1d6f25056d31b2e8cae30903873b741",
        "stdlib": "c55608e9eb6df7327e74b21e271d324dc523cef31587b8d6d2393db08d6e000c",
    },
    "1.6.0": {
        "compiler": "4bd7a92568fd89c23b7f9f36d4380886beed18d3d54ea6adf49bebae627db805",
        "compiler-embeddable": "0366843cd2defdd583c6b16b10bc32b85f28c5bf9510f10e44c886f5bd24c388",
        "stdlib": "115daea30b0d484afcf2360237b9d9537f48a4a2f03f3cc2a16577dfc6e90342",
    },
    "1.6.20": {
        "compiler": "90567c5cf297985d028fa39aa3a7904dc8096173e1c7f3d3f35fe7074581098e",
        "compiler-embeddable": "be634faaafb56816b6ef6d583e57ab33e4d6e5180cde2f505ccf7d45dc738ef8",
        "stdlib": "eeb51c2b67b26233fd81d0bc4f8044ec849718890905763ceffd84a31e2cb799",
    },
    "1.7.0": {
        "compiler": "ce85fafb3e24712d62a0d02d277c2d56197d74afdd4f5ca995eaf33d2c504663",
        "compiler-embeddable": "573935b492e65b93a792eaa6270295532f580cd4f26f9f6eb105ecbafcd182d4",
        "stdlib": "aa88e9625577957f3249a46cb6e166ee09b369e600f7a11d148d16b0a6d87f05",
    },
    "1.7.20": {
        "compiler": "0e36d98c56f7c9685ab9d9e1fac9be36a5214939adb3f905b93c62de76023618",
        "compiler-embeddable": "5ec2be1872dc47b9dcb466f1781eded6c59d9eee18657d4b0f1148e619caea36",
        "stdlib": "7779ec96b9acbf92ca023858ac04543f9d2c3bdf1722425fff42f25ff3acfc9b",
    },
    "1.8.0": {
        "compiler": "1f19f247d337387cbdd75d54e10a6865857c28a533fced50c0c5c9482b3ab9af",
        "compiler-embeddable": "e9b3a56dbbfdf1e0328d4731b7d7ca789ce0f1f263372ad88dd8decbd1602858",
        "stdlib": "c77bef8774640b9fb9d6e217459ff220dae59878beb7d2e4b430506feffc654e",
    },
    "1.9.0-Beta": {
        "compiler": "4c7e3972e0ce0be8aa5c8ceeb8eb795f6345685bb57c6f59b649ed70c6051581",
        "compiler-embeddable": "7429076f8dd2ccd1cce48d7e5bf5b9fadde8afab110f9f4cfe0912756f16d770",
        "stdlib": "af458cc55cf69e966668e6010c7ccee4a50d553b3504a2e8311dd0c76242d881",
    },
    "1.9.20-Beta": {
        "compiler": "b90980de3a16858e6e1957236d7bb9a729fcd0587a98fb64668866e1975aaa6f",
        "compiler-embeddable": "5c9de79f0f8d97f2aa4d877449063b1cc2828c17f25a119fc32c776401f058de",
        "stdlib": "788e48813dd76ad598fff7bef3b1e038d7291741810bd04c6c57037c4d75dac2",
    },
    "2.0.0-RC1": {
        "compiler": "60e31163aa7348166d708cdc9cb47d616b0222e5b11173f35f1adfb61bc3690a",
        "compiler-embeddable": "12d330c6e98ba42840f1d10e2752a9c53099d4dfa855bc4526d23fe1a1af9634",
        "stdlib": "bbb2c9b813e6196f9afa9f9add8b395ee384ab1763a0880e084d2942214f1c30",
    },
}

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
