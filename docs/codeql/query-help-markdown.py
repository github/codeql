import re
import subprocess
import json
import csv
import sys
import os

"""
This script collects CodeQL queries that are part of code scanning query packs,
renders the accompanying query help as markdown, inserts some useful metadata
into the help, and adds a link to the query in the CodeQL repo.

This script requires that 'git' and 'codeql' commands
are on the PATH. It'll try to automatically set the CodeQL search path correctly,
as long as you run the script from one of the following locations:
 - anywhere from within a clone of the CodeQL Git repo
 - from the parent directory of a clone of the CodeQL Git repo (assuming 'codeql' 
   and 'codeql-go' directories both exist)
"""

# Define which languages and query packs to consider
languages = [ "cpp", "csharp", "go", "java", "javascript", "python"]

# Query suites to generate help for - lgtm suite should cover the queries that users are interested in
packs = ["lgtm"]

def prefix_repo_nwo(filename):
    """
    Replaces an absolute path prefix with a GitHub repository name with owner (NWO).
    This function relies on `git` being available.
    For example:
        /home/alice/git/ql/java/ql/src/MyQuery.ql  
    becomes:
        github/codeql/java/ql/src/MyQuery.ql

    If we can't detect a known NWO (e.g. github/codeql, github/codeql-go), the
    path will be truncated to the root of the git repo:
        ql/java/ql/src/MyQuery.ql

    If the filename is not part of a Git repo, the return value is the
    same as the input value: the whole path.
    """
    dirname = os.path.dirname(filename)

    try:
        git_toplevel_dir_subp = subprocess_run(
            ["git", "-C", dirname, "rev-parse", "--show-toplevel"])
    except:
        # Not a Git repo
        return filename

    git_toplevel_dir = git_toplevel_dir_subp.stdout.strip()

    # Detect 'github/codeql' and 'github/codeql-go' repositories by checking the remote (it's a bit
    # of a hack but will work in most cases, as long as the remotes have 'codeql' and 'codeql-go'
    # in the URL
    git_remotes = subprocess_run(
        ["git", "-C", dirname, "remote", "-v"]).stdout.strip()

    if "codeql-go" in git_remotes:
        prefix = "github/codeql-go"
    elif "codeql" in git_remotes:
        prefix = "github/codeql"
    else:
        prefix = os.path.basename(git_toplevel_dir)

    return os.path.join(prefix, filename[len(git_toplevel_dir)+1:])


def single_spaces(input):
    """
    Workaround for https://github.com/github/codeql-coreql-team/issues/470 which causes
    some metadata strings to contain newlines and spaces without a good reason.
    """
    return " ".join(input.split())


def get_query_metadata(key, metadata, queryfile):
    """Returns query metadata or prints a warning to stderr if a particular piece of metadata is not available."""
    if key in metadata:
        return single_spaces(metadata[key])
    query_id = metadata['id'] if 'id' in metadata else 'unknown'
    print("Warning: no '%s' metadata for query with ID '%s' (%s)" %
          (key, query_id, queryfile), file=sys.stderr)
    return ""


def subprocess_run(cmd):
    """Runs a command through subprocess.run, with a few tweaks. Raises an Exception if exit code != 0."""
    return subprocess.run(cmd, capture_output=True, text=True, env=os.environ.copy(), check=True)


try:  # Check for `git` on path
    subprocess_run(["git", "--version"])
except Exception as e:
    print("Error: couldn't invoke 'git'. Is it on the path? Aborting.", file=sys.stderr)
    raise e

try:  # Check for `codeql` on path
    subprocess_run(["codeql", "--version"])
except Exception as e:
    print("Error: couldn't invoke CodeQL CLI 'codeql'. Is it on the path? Aborting.", file=sys.stderr)
    raise e

# Define CodeQL search path so it'll find the CodeQL repositories:
#  - anywhere in the current Git clone (including current working directory)
#  - the 'codeql' subdirectory of the cwd
#
# (and assumes the codeql-go repo is in a similar location)

codeql_search_path = "./codeql:./codeql-go"  # will be extended further down
# Extend CodeQL search path by detecting root of the current Git repo (if any). This means that you
# can run this script from any location within the CodeQL git repository.
try:
    git_toplevel_dir = subprocess_run(["git", "rev-parse", "--show-toplevel"])

    # Current working directory is in a Git repo. Add it to the search path, just in case it's the CodeQL repo
    #git_toplevel_dir = git_toplevel_dir.stdout.strip()
    codeql_search_path += ":" + git_toplevel_dir + ":" + git_toplevel_dir + "/../codeql-go"
    codeql_search_path = git_toplevel_dir = git_toplevel_dir.stdout.strip()
except:
    # git rev-parse --show-toplevel exited with non-zero exit code. We're not in a Git repo
    pass

# Iterate over all languages and packs, and resolve which queries are part of those packs
for lang in languages:

    code_scanning_queries = subprocess_run(
                ["codeql", "resolve", "queries", "--search-path", codeql_search_path, "%s-code-scanning.qls" % (lang)]).stdout.strip()
    security_extended_queries = subprocess_run(
                ["codeql", "resolve", "queries", "--search-path", codeql_search_path, "%s-security-extended.qls" % (lang)]).stdout.strip()
    security_and_quality_queries = subprocess_run(
                ["codeql", "resolve", "queries", "--search-path", codeql_search_path, "%s-security-and-quality.qls" % (lang)]).stdout.strip()
    # Define empty dictionary to store @name:filename pairs to generate alphabetically sorted Sphinx toctree
    index_file_dictionary = {}
    for pack in packs:
        # Get absolute paths to queries in this pack by using 'codeql resolve queries'
        try:
            
            queries_subp = subprocess_run(
                ["codeql", "resolve", "queries", "--search-path", codeql_search_path, "%s-%s.qls" % (lang, pack)])
        except Exception as e:
            # Resolving queries might go wrong if the github/codeql and github/codeql-go repositories are not
            # on the search path.
            print(
                "Warning: couldn't find query pack '%s' for language '%s'. Do you have the right repositories in the right places (search path: '%s')?" % (
                    pack, lang, codeql_search_path),
                file=sys.stderr
            )
            continue

        # Define empty dictionary to store @name:filename pairs to generate alphabetically sorted Sphinx toctree later
        index_file_dictionary = {}

        # Investigate metadata for every query by using 'codeql resolve metadata'
        for queryfile in queries_subp.stdout.strip().split("\n"):
            query_metadata_json = subprocess_run(
                ["codeql", "resolve", "metadata", queryfile]).stdout.strip()
            meta = json.loads(query_metadata_json)

            # Turn an absolute path to a query file into an nwo-prefixed path (e.g. github/codeql/java/ql/src/....)
            queryfile_nwo = prefix_repo_nwo(queryfile)

            # Generate the query help for each query
            try:
                query_help = subprocess_run(
                    ["codeql", "generate", "query-help", "--format=markdown", "--warnings=error", queryfile]).stdout.strip()
            except:
                # Print a message if generate query help fails
                print("Failed to generate query help for '%s'" % (queryfile_nwo))
                continue

            # Pull out relevant query metadata properties that we want to display in the query help
            query_name_meta = get_query_metadata('name', meta, queryfile)
            query_description = get_query_metadata(
                'description', meta, queryfile)
            query_id = "ID: " + \
                get_query_metadata('id', meta, queryfile) + "\n"
            query_kind = "Kind: " + \
                get_query_metadata('kind', meta, queryfile) + "\n"
            query_severity = "Severity: " + \
                get_query_metadata('problem.severity', meta, queryfile) + "\n"
            query_precision = "Precision: " + \
                get_query_metadata('precision', meta, queryfile) + "\n"
            query_tags = "Tags:\n   - " + \
                get_query_metadata('tags', meta, queryfile).replace(" ", "\n   - ") + "\n"

            # Build a link to the query source file for display in the query help
            if "go" in prefix_repo_nwo(queryfile):
                transform_link = prefix_repo_nwo(queryfile).replace(
                    "codeql-go", "codeql-go/blob/main").replace(" ", "%20").replace("\\", "/")
            else:
                transform_link = prefix_repo_nwo(queryfile).replace(
                    "codeql", "codeql/blob/main").replace(" ", "%20").replace("\\", "/")
            query_link = "[Click to see the query in the CodeQL repository](https://github.com/" + \
                transform_link + ")\n"
            
            if queryfile in code_scanning_queries:
                cs_suites = '   - ' + lang +'-code-scanning.qls\n'
            else:
                cs_suites = ""
            if queryfile in security_extended_queries:
                se_suites = '   - ' + lang + '-security-extended.qls\n'
            else:
                se_suites = ""
            if queryfile in security_and_quality_queries:
                sq_suites = '   - ' +lang + '-security-and-quality.qls\n'
            else:
                sq_Suites = ""

            if queryfile in code_scanning_queries or queryfile in security_extended_queries or queryfile in security_and_quality_queries:
                suites_list = "Query suites:\n" + cs_suites + se_suites + sq_suites
            else:
                suites_list = ""

            # Join metadata into a literal block and add query link below
            meta_string = "\n"*2 + "```\n" + query_id + query_kind + query_severity + \
                query_precision + query_tags + suites_list + "```\n\n" + query_link + "\n"

            # Insert metadata block into query help directly under title
            full_help = query_help.replace("\n", meta_string, 1)

            # Use id property to make name for markdown file, replacing any "/" characters with "-"
            query_name = query_id[4:-1].replace("/", "-")

            # Populate index_file_dictionary with @name extracted from metadata and corresponding query filename
            index_file_dictionary[query_name_meta] = lang + "/" + query_name

            # Make paths for output of the form: query-help-markdown/<lang>/<queryfile>.md
            docs_dir = 'query-help'
            md_dir_path = os.path.join(docs_dir, lang)
            md_file_path = os.path.join(md_dir_path, query_name + ".md")

            # Make directories for output paths they don't already exist
            if not os.path.isdir(md_dir_path):
                os.makedirs(md_dir_path)

            # Generate query help at chosen path if output file doesn't already exist
            if not os.path.exists(md_file_path):
                file = open(md_file_path, "x")
                file.write(full_help)
                file.close()

    # Sort index_file_dictionary alphabetically by @name key, and create column of filename values
    sorted_index = dict(sorted(index_file_dictionary.items()))
    sorted_index = ("\n" + "   ").join(sorted_index.values())

    # Add directives to make sorted_index a valid toctree for sphinx source files
    toc_directive = ".. toctree::\n   :titlesonly:\n\n   "
    toc_include = toc_directive + sorted_index

    # Write toctree to rst
    toc_file = os.path.join(docs_dir, "toc-" + lang + ".rst")
    file = open(toc_file, "x")
    file.write(toc_include)
    file.close()
