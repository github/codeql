def root_source_dir():
    """ get absolute path to the root source directory

        This can break hermeticity if used in a build step"""
    return '{root}'

def current_source_dir():
    """ get absolute path to the source directory of this bazel package

        This can break hermeticity if used in a build step"""
    return root_source_dir() + '/' + native.package_name()
