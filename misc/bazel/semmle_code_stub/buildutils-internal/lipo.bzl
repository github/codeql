# we only need to build universal binaries when building releases from the internal repo
# when building from the codeql repo, we can stub this rule with an alias

def universal_binary(*, name, dep, **kwargs):
    native.alias(name = name, actual = dep, **kwargs)
