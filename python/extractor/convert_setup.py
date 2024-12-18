#!/usr/bin/env python

import os.path
import imp
import sys
import traceback
import re

SETUP_TAG = "LGTM_PYTHON_SETUP_SETUP_PY"

setup_file_path = "<default value>"
requirements_file_path = "<default value>"

if sys.version_info >= (3,):
    basestring = str

def setup_interceptor(**args):
    requirements = make_requirements(**args)
    write_requirements_file(requirements)

def make_requirements(requires=(), install_requires=(), extras_require={}, dependency_links=[], **other_args):
    # Install main requirements.
    requirements = list(requires) + list(install_requires)
    # Install requirements for all features.
    for feature, feature_requirements in extras_require.items():
        if isinstance(feature_requirements, basestring):
            requirements += [feature_requirements]
        else:
            requirements += list(feature_requirements)

    # Attempt to use dependency_links to find requirements first.
    for link in dependency_links:
        split_link = link.rsplit("#egg=", 1)
        if len(split_link) != 2:
            print("Invalid dependency link \"%s\" was ignored." % link)
            continue
        if not link.startswith("http"):
            print("Dependency link \"%s\" is not an HTTP link so is being ignored." % link)
            continue
        package_name = split_link[1].rsplit("-", 1)[0]
        for index, requirement in enumerate(requirements):
            if requirement_name(requirement) == package_name:
                print("Using %s to install %s." % (link, requirement))
                requirements[index] = package_name + " @ " + link

    print("Creating %s file from %s." % (requirements_file_path, setup_file_path))
    requirements = [requirement.encode("ascii", "ignore").strip().decode("ascii") for requirement in requirements]
    print("Requirements extracted from setup.py: %s" % requirements)
    return requirements

REQUIREMENT = re.compile(r"^([\w-]+)")

def requirement_name(req_string):
    req_string = req_string.strip()
    if req_string[0] == '#':
        return None
    match = REQUIREMENT.match(req_string)
    if match:
        return match.group(1)
    return None


def write_requirements_file(requirements):
    if os.path.exists(requirements_file_path):
        # Only overwrite the existing requirements if the new requirements are not empty.
        if requirements:
            print("%s already exists. It will be overwritten." % requirements_file_path)
        else:
            print("%s already exists and it will not be overwritten because the new requirements list is empty." % requirements_file_path)
            return
    elif not requirements:
        print("%s will not be written because the new requirements list is empty." % requirements_file_path)
        return
    with open(requirements_file_path, "w") as requirements_file:
        for requirement in requirements:
            requirements_file.write(requirement + "\n")
    print("Requirements have been written to " + requirements_file_path)

def convert_setup_to_requirements(root):
    global setup_file_path
    if SETUP_TAG in os.environ:
        setup_file_path = os.environ[SETUP_TAG]
        if setup_file_path == "false":
            print("setup.py explicitly ignored")
            return 0
    else:
        setup_file_path = os.path.join(root, "setup.py")
    if not os.path.exists(setup_file_path):
        print("%s does not exist. Not generating requirements.txt." % setup_file_path)
        return 0
    # Override the setuptools and distutils.core implementation of setup with our own.
    import setuptools
    setattr(setuptools, "setup", setup_interceptor)
    import distutils.core
    setattr(distutils.core, "setup", setup_interceptor)

    # TODO: WHY are we inserting at index 1?
    # >>> l = [1,2,3]; l.insert(1, 'x'); print(l)
    # [1, 'x', 2, 3]

    # Ensure the current directory is on path since setup.py might try and include some files in it.
    sys.path.insert(1, root)

    # Modify the arguments since the setup file sometimes checks them.
    sys.argv = [setup_file_path, "build"]

    # Run the setup.py file.
    try:
        imp.load_source("__main__", setup_file_path)
    except BaseException as ex:
        # We don't really care about errors so long as a requirements.txt exists in the next build step.
        print("Running %s failed." % setup_file_path)
        traceback.print_exc(file=sys.stdout)
        if not os.path.exists(requirements_file_path):
            print("%s failed, and a %s file does not exist. Exiting with error." % (setup_file_path, requirements_file_path))
            return 1
    return 0

def main():
    global requirements_file_path
    requirements_file_path = sys.argv[2]
    sys.path.extend(sys.argv[3:])
    sys.exit(convert_setup_to_requirements(sys.argv[1]))

if __name__ == "__main__":
    main()
