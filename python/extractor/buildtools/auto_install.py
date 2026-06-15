#!/usr/bin/python3

import sys
import logging
import os
import os.path
import re

from packaging.specifiers import SpecifierSet
from packaging.version import Version

import buildtools.semmle.requirements as requirements

logging.basicConfig(level=logging.WARNING)


def pip_install(req, venv, dependencies=True, wheel=True):
    venv.upgrade_pip()
    tmp = requirements.save_to_file([req])
    #Install the requirements using the venv python
    args = [ "install", "-r", tmp]
    if dependencies:
        print("Installing %s with dependencies." % req)
    elif wheel:
        print("Installing %s without dependencies." % req)
        args += [ "--no-deps"]
    else:
        print("Installing %s without dependencies or wheel." % req)
        args += [ "--no-deps", "--no-binary", ":all:"]
    print("Calling " + " ".join(args))
    venv.pip(args)
    os.remove(tmp)

def restrict_django(reqs):
    for req in reqs:
        if sys.version_info[0] < 3 and req.name.lower() == "django":
            if Version("2") in req.specifier:
                req.specifier = SpecifierSet("<2")
    return reqs

ignored_packages = [
    "pyobjc-.*",
    "pypiwin32",
    "frida",
    "pyopenssl", # Installed by pip. Don't mess with its version.
    "wxpython", # Takes forever to compile all the C code.
    "cryptography", #Installed by pyOpenSSL and thus by pip. Don't mess with its version.
    "psycopg2", #psycopg2 version 2.6 fails to install.
]

if os.name != "nt":
    ignored_packages.append("pywin32") #Only works on Windows

ignored_package_regex = re.compile("|".join(ignored_packages))

def non_ignored(reqs):
    filtered_reqs = []
    for req in reqs:
        if ignored_package_regex.match(req.name.lower()) is not None:
            logging.info("Package %s is ignored. Skipping." % req.name)
        else:
            filtered_reqs += [req]
    return filtered_reqs

def try_install_with_deps(req, venv):
    try:
        pip_install(req, venv, dependencies=True)
    except Exception as ex:
        logging.warn("Failed to install all dependencies for " + req.name)
        logging.info(ex)
        try:
            pip_install(req, venv, dependencies = False)
        except Exception:
            pip_install(req, venv, dependencies = False, wheel = False)

def install(reqs, venv):
    '''Attempt to install a sufficient and stable set of dependencies from the requirements.txt file.
        First of all we 'clean' the requirements, removing contradictory version numbers.
        Then we attempt to install the restricted version of each dependency, and , should that fail,
        we install the unrestricted version. If that fails, the whole installation fails.
        Once the immediate dependencies are installed, we then (attempt to ) install the dependencies.
        Returns True if installation was successful. False otherwise.

        `reqs` should be a string containing all requirements separated by newlines or a list of
        strings with each string being a requirement.
    '''
    if isinstance(reqs, str):
        reqs = reqs.split("\n")
    reqs = requirements.parse(reqs)
    reqs = restrict_django(reqs)
    reqs = non_ignored(reqs)
    cleaned = requirements.clean(reqs)
    restricted = requirements.restrict(reqs)
    for i, req in enumerate(restricted):
        try:
            try_install_with_deps(req, venv)
        except Exception as ex1:
            try:
                try_install_with_deps(cleaned[i], venv)
            except Exception as ex2:
                logging.error("Failed to install " + req.name)
                logging.warning(ex2)
                return False
            logging.info("Failed to install restricted form of " + req.name)
            logging.info(ex1)
    return True
