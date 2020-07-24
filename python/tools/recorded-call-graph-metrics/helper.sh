#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECTS_FILE="$SCRIPTDIR/projects.json"

METRICS_QUERY="ql/query/Metrics.ql"

PROJECTS_BASE_DIR="$SCRIPTDIR/projects"

repo_dir() {
    echo "$PROJECTS_BASE_DIR/$1/repo"
}

venv_dir() {
    echo "$PROJECTS_BASE_DIR/$1/venv"
}

trace_dir() {
    echo "$PROJECTS_BASE_DIR/$1/traces"
}

db_path() {
    echo "$PROJECTS_BASE_DIR/$1/$1-db"
}

query_result_base_path() {
    echo "$PROJECTS_BASE_DIR/$1/$2"
}

help() {
    echo -n """\
$0 help                 This message
$0 projects             List projects
$0 repo <projects>      Fetch repo for projects
$0 setup <projects>     Perform setup steps for projects (install dependencies)
$0 trace <projects>     Trace projects
$0 db <projects>        Build databases for projects
$0 metrics <projects>   Run $METRICS_QUERY on projects
$0 all <projects>       Perform all the above steps for projects
"""
}

projects() {
    jq -r 'keys[]' "$PROJECTS_FILE"
}

check_project_exists() {
    if ! jq -e ".\"$1\"" "$PROJECTS_FILE" &>/dev/null; then
        echo "ERROR: '$1' not a known project, see '$0 projects'"
        exit 1
    fi
}

repo() {
    for project in $@; do
        check_project_exists $project

        echo "Cloning repo for '$project'"

        REPO_DIR=$(repo_dir $project)

        if [[ -d "$REPO_DIR" ]]; then
            echo "Repo already cloned in $REPO_DIR"
            continue;
        fi

        REPO_URL=$(jq -e -r ".\"$project\".repo" "$PROJECTS_FILE")
        SHA=$(jq -e -r ".\"$project\".sha" "$PROJECTS_FILE")

        mkdir -p "$REPO_DIR"
        cd "$REPO_DIR"
        git init
        git remote add origin $REPO_URL
        git fetch --depth 1 origin $SHA
        git -c advice.detachedHead=False checkout FETCH_HEAD
    done
}

setup() {
    for project in $@; do
        check_project_exists $project

        echo "Setting up '$project'"

        python3 -m venv $(venv_dir $project)
        source $(venv_dir $project)/bin/activate

        cd $(repo_dir $project)
        pip install -e "$SCRIPTDIR"

        IFS=$'\n'
        setup_commands=($(jq -r ".\"$project\".setup[]" $PROJECTS_FILE))
        unset IFS
        for setup_command in "${setup_commands[@]}"; do
            echo "Running '$setup_command'"
            $setup_command
        done

        # deactivate venv again
        deactivate
    done
}

trace() {
    for project in $@; do
        check_project_exists $project

        echo "Tracing '$project'"

        source $(venv_dir $project)/bin/activate

        REPO_DIR=$(repo_dir $project)
        cd "$REPO_DIR"

        rm -rf $(trace_dir $project)
        mkdir -p $(trace_dir $project)

        MODULE_COMMAND=$(jq -r ".\"$project\".module_command" $PROJECTS_FILE)

        cg-trace --xml $(trace_dir $project)/trace.xml --module $MODULE_COMMAND

        # deactivate venv again
        deactivate
    done
}

db() {
    for project in $@; do
        check_project_exists $project

        echo "Creating CodeQL database for '$project'"

        DB=$(db_path $project)
        SRC=$(repo_dir $project)
        PYTHON_EXTRACTOR=$(codeql resolve extractor --language=python)

        # Source venv so we can extract dependencies
        source $(venv_dir $project)/bin/activate

        rm -rf "$DB"

        codeql database init --source-root="$SRC" --language=python "$DB"
        codeql database trace-command --working-dir="$SRC" "$DB" "$PYTHON_EXTRACTOR/tools/autobuild.sh"
        codeql database index-files --language xml --include-extension .xml --working-dir="$(trace_dir $project)" "$DB"
        codeql database finalize "$DB"

        echo "Created database in '$DB'"

        # deactivate venv again
        deactivate
    done
}

metrics() {
    for project in $@; do
        check_project_exists $project

        echo "Running $METRICS_QUERY on '$project'"

        RESULTS_BASE=$(query_result_base_path $project Metrics)
        DB=$(db_path $project)

        codeql query run "$SCRIPTDIR/$METRICS_QUERY" --database "$DB" --output "${RESULTS_BASE}.bqrs"
        codeql bqrs decode "${RESULTS_BASE}.bqrs" --format text --output "${RESULTS_BASE}.txt"

        echo "Results available in '${RESULTS_BASE}.txt'"
    done
}

all() {
    for project in $@; do
        check_project_exists $project

        repo $project
        setup $project
        trace $project
        db $project
        metrics $project
    done
}


COMMAND=${1:-"help"}

if [[ $# -ge 2 ]]; then
    shift
fi

$COMMAND $@
