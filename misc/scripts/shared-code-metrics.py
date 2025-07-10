#!/bin/env python3
# Generates a report on the amount of code sharing in this repo
#
# The purpose of this is
# a) To be able to understand the structure and dependencies
# b) To provide a metric that measures the amount of shared vs non-shared code

import datetime
from pathlib import Path
import json
import yaml

# To add more languages, add them to this list:
languages = ['cpp', 'csharp', 'go', 'java', 'javascript', 'python', 'ql', 'ruby', 'swift']

repo_location = Path(__file__).parent.parent.parent

# Gets the total number of lines in a file
def linecount(file):
    with open(file, 'r') as fp: return len(fp.readlines())

# Gets the language name from the path
def get_language(path):
    return path.parts[len(repo_location.parts)]

# Is this path a CodeQL query file
def is_query(path):
    return path.suffix == '.ql'

# Is this path a CodeQL library file
def is_library(path):
    return path.suffix == '.qll'

# Is this path a relevant CodeQL file
def is_ql(path):
    return is_query(path) or is_library(path)

# Is this file a CodeQL package file
def is_package(path):
    return path.name == 'qlpack.yml'

# A CodeQL source file
class QlFile:
    def __init__(self, path):
        self.path = path
        self.lines = linecount(path)
    shared = False

    def language(self):
        return get_language(self.path)

    def query(self):
        return is_query(self.path)

    def library(self):
        return is_library(self.path)

    # Returns if this qlfile is not shared, and is in a pack that is only in one language
    def isOnlyInLanguage(self, language):
        return not self.shared and (self.package is None or self.package.languages == {language}) and self.language() == language

# Represents a language folder
class Language:
    def __init__(self, name):
        self.name = name
        self.packs = []
        self.nonshared_files = 0
        self.nonshared_lines = 0
        self.imported_files = 0
        self.imported_lines = 0

    def addQlFile(self, qlfile):
        if not qlfile.shared:
            self.nonshared_files += 1
            self.nonshared_lines += qlfile.lines

    def addSharedAsset(self, package):
        self.imported_files += package.files
        self.imported_lines += package.lines

# A shared package or file
class SharedAsset:
    def __init__(self, name):
        self.name = name

# A file shared using identical-files.json
class IdenticalFileSet(SharedAsset):
    def __init__(self, name, ql_files):
        self.name = name
        self.languages = set()
        self.files = 0
        self.lines = 0
        for file in ql_files:
            file.package = self
            file.shared = True
            self.files = 1
            self.lines = file.lines
            self.languages.add(file.language())

    # Gets a pretty-printed markdown link
    def link(self):
        return self.name

# Represents all files shared in `identical-files.json`
# Reads the file and builds a list of assets
class IdenticalFiles:
    def __init__(self, repo_location, ql_file_index):
        identical_files = repo_location/'config'/'identical-files.json'
        with open(identical_files, "r") as fp:
            identical_files_json = json.load(fp)
        # Create a list of assets
        self.assets = []
        for group in identical_files_json:
            paths = []
            for file in identical_files_json[group]:
                path = repo_location / file
                if is_ql(path):
                    ql_file_index[path].shared = True
                    paths.append(ql_file_index[path])
            self.assets.append(IdenticalFileSet(group, paths))

# A package created from a `qlpack.yml`` file
class Package(SharedAsset):
    def __init__(self, path, ql_file_index):
        self.path = path
        self.language = get_language(path)
        self.lines = 0
        self.files = 0
        self.languages = set()
        self.languages.add(self.language)
        self.identical_files_dependencies = set()
        with open(path, 'r') as fp:
            y = yaml.safe_load(fp)
            if 'name' in y:
                self.name = y['name']
            else:
                self.name = path.parent.name
            if 'dependencies' in y:
                self.deps = y['dependencies']
                if self.deps is None:
                    self.deps = {}
            else:
                self.deps = {}
        # Mark all relevant files with their package
        for file in ql_file_index:
            if self.containsDirectory(file):
                file = ql_file_index[file]
                if not file.shared:
                    file.package = self
                    self.lines += file.lines
                    self.files += 1
                else:
                    self.identical_files_dependencies.add(file.package)
        self.url = "https://github.com/github/codeql/blob/main/" + str(path.relative_to(repo_location))

    # Gets a pretty-printed markdown link
    def link(self):
        return '[' + self.name + '](' + self.url + ')'

    def containsDirectory(self, dir):
        return self.path.parent.parts == dir.parts[:len(self.path.parent.parts)]
        # dir.startsWith(self.path.parent)

    # Constructs a list of transitive depedencies of this package.
    def calculateDependencies(self, packageNameMap):
        self.transitive_dependencies = set(self.deps)
        queue = list(self.deps)
        while len(queue):
            item = queue.pop()
            for dep2 in packageNameMap[item].deps:
                if dep2 not in self.transitive_dependencies:
                    self.transitive_dependencies.add(dep2)
                    queue.append(dep2)
        # Calculate the amount of imported code
        self.total_imported_files = 0
        self.total_imported_lines = 0
        self.all_dependencies = set(self.identical_files_dependencies)
        for dep in self.transitive_dependencies:
            self.all_dependencies.add(packageNameMap[dep])
        for dep in self.all_dependencies:
            self.total_imported_files += dep.files
            self.total_imported_lines += dep.lines
            dep.languages.add(self.language)

# Create a big index of all files and their line counts.

# Map from path to line count
ql_file_index = {}
package_files = []

# Queue of directories to read
directories_to_scan = [repo_location]

while len(directories_to_scan)!=0:
    dir = directories_to_scan.pop()
    for p in dir.iterdir():
        if p.is_dir():
            directories_to_scan.append(p)
        elif is_ql(p):
            ql_file_index[p] = QlFile(p)
        elif is_package(p):
            package_files.append(p)

# Create identical_files_json
identical_files = IdenticalFiles(repo_location, ql_file_index)

# Create packages
# Do this after identical_files so that we can figure out the package sizes
# Do this after getting the ql_file_index fully built
packages = []
for file in package_files:
    packages.append(Package(file, ql_file_index))

# List all shared assets
shared_assets = packages + identical_files.assets

# Construct statistics for each language
language_info = {}
for l in languages:
    language_info[l] = Language(l)

for qlfile in ql_file_index.values():
    lang = qlfile.language()
    if lang in language_info:
        info = language_info[lang]
        if qlfile.isOnlyInLanguage(lang):
            info.addQlFile(qlfile)

# Determine all package dependencies

packageNameMap = {}

for package in packages:
    packageNameMap[package.name] = package

for package in packages:
    package.calculateDependencies(packageNameMap)

for asset in shared_assets:
    if len(asset.languages)>1:
        for lang in asset.languages:
            if lang in language_info:
                language_info[lang].addSharedAsset(asset)


# Functions to output the results

def list_assets(shared_assets, language_info):
    print('| Asset | Files | Lines |', end='')
    for lang in language_info:
        print('', lang, '|', end='')
    print()
    print('| ----- | ----- | ----- |', end='')
    for lang in language_info:
        print(' ---- |', end='')
    print()
    for asset in shared_assets:
        print('|', asset.link(), '|', asset.files ,'|', asset.lines, '|', end=' ')
        for lang in language_info:
            if lang in asset.languages:
                print('yes |', end=' ')
            else:
                print('    |', end=' ');
        print()
    print()

def list_package_dependencies(package):
    print("Package", package.path, package.name, package.files, package.lines, package.total_imported_files, package.total_imported_lines)
    for dep in package.all_dependencies:
        print("  ", dep.name, dep.files, dep.lines)

def print_package_dependencies(packages):
    print('| Package name | Non-shared files | Non-shared lines of code | Imported files | Imported lines of code | Shared code % |')
    print('| ------------ | ---------------- | ------------------------ | -------------- | ---------------------- | ------------- |')
    for package in packages:
        nlines = package.lines + package.total_imported_lines
        shared_percentage = 100 * package.total_imported_lines / nlines if nlines>0 else 0
        print('|', package.link(), '|', package.files, '|', package.lines, '|', package.total_imported_files, '|', package.total_imported_lines, '|',
            # ','.join([p.name for p in package.all_dependencies]),
            "%.2f" % shared_percentage, '|')
    print()

def print_language_dependencies(packages):
    print_package_dependencies([p for p in packages if p.name.endswith('-all') and p.name.count('-')==1])

def list_shared_code_by_language(language_info):
    # For each language directory, list the files that are (1) inside the directory and not shared,
    # (2) packages from outside the directory, plus identical files
    print('| Language | Non-shared files | Non-shared lines of code | Imported files | Imported lines of code | Shared code % |')
    print('| -------- | ---------------- | ------------------------ | -------------- | ---------------------- | ------------- |')
    for lang in language_info:
        info = language_info[lang]
        total = info.imported_lines + info.nonshared_lines
        shared_percentage = 100 * info.imported_lines / total if total>0 else 0
        print('|', lang, '|', info.nonshared_files, '|', info.nonshared_lines, '|', info.imported_files, '|', info.imported_lines, '|', "%.2f" % shared_percentage, '|')
    print()


# Output reports

print('# Report on CodeQL code sharing\n')
print('Generated on', datetime.datetime.now())
print()

print('## Shared code by language\n')

list_shared_code_by_language(language_info)

print('''
* *Non-shared files*: The number of CodeQL files  (`.ql`/`.qll`) that are only used within this language folder. Excludes `identical-files.json` that are shared between multiple languages.
* *Non-shared lines of code*: The number of lines of code in the non-shared files.
* *Imported files*: All CodeQL files (`.ql`/`.qll`) files that are transitively used in this language folder, either via packages or `identical-files.json`
* *Imported lines of code*: The number of lines of code in the imported files
* *Shared code %*: The proportion of imported lines / total lines (nonshared + imported).

## Shared packages use by language

A package is *used* if it is a direct or indirect dependency, or a file shared via `identical-files.json`.

''')

list_assets(shared_assets, language_info)

print('## Shared code by language pack\n')

print_language_dependencies(packages)

print('## Shared code by package\n')

print_package_dependencies(packages)
