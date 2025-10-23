# Test for the package exclusion bug fix.
#
# This test reproduces the scenario where a dependency package in a separate module
# was incorrectly excluded due to relative paths containing ".." when checked against
# wantedRoots from the main module.
#
# Structure:
# - configmodule/config/ (separate module with config package)
# - mainmodule/app/jobs/worker/ (main package that depends on config)
#
# Bug scenario (old code):
# When building just mainmodule packages, wantedRoots contains mainmodule directories
# but NOT configmodule's ModDir. Checking config against mainmodule/app/jobs/worker
# produces ../../configmodule/config (contains ".."), causing incorrect exclusion.
#
# Fix: Adds all dependency ModDirs to wantedRoots and prioritizes checking them first.
def test(codeql, go):
    codeql.database.create(source_root="src")
