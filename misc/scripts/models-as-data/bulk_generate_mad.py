#!/usr/bin/env python3
"""
Experimental script for bulk generation of MaD models based on a list of projects.

Note: This file must be formatted using the Black Python formatter.
"""

import os.path
import subprocess
import sys
from typing import Required, TypedDict, List, Callable, Optional
from concurrent.futures import ThreadPoolExecutor, as_completed
import time
import argparse
import zipfile
import tarfile
import shutil


def missing_module(module_name: str) -> None:
    print(
        f"ERROR: {module_name} is not installed. Please install it with 'pip install {module_name}'."
    )
    sys.exit(1)


try:
    import yaml
except ImportError:
    missing_module("pyyaml")

try:
    import requests
except ImportError:
    missing_module("requests")

import generate_mad as mad

gitroot = (
    subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
    .decode("utf-8")
    .strip()
)
build_dir = os.path.join(gitroot, "mad-generation-build")


# A project to generate models for
Project = TypedDict(
    "Project",
    {
        "name": Required[str],
        "git-repo": str,
        "git-tag": str,
        "with-sinks": bool,
        "with-sources": bool,
        "with-summaries": bool,
    },
    total=False,
)


def should_generate_sinks(project: Project) -> bool:
    return project.get("with-sinks", True)


def should_generate_sources(project: Project) -> bool:
    return project.get("with-sources", True)


def should_generate_summaries(project: Project) -> bool:
    return project.get("with-summaries", True)


def clone_project(project: Project) -> str:
    """
    Shallow clone a project into the build directory.

    Args:
        project: A dictionary containing project information with 'name', 'git-repo', and optional 'git-tag' keys.

    Returns:
        The path to the cloned project directory.
    """
    name = project["name"]
    repo_url = project["git-repo"]
    git_tag = project.get("git-tag")

    # Determine target directory
    target_dir = os.path.join(build_dir, name)

    # Clone only if directory doesn't already exist
    if not os.path.exists(target_dir):
        if git_tag:
            print(f"Cloning {name} from {repo_url} at tag {git_tag}")
        else:
            print(f"Cloning {name} from {repo_url}")

        subprocess.check_call(
            [
                "git",
                "clone",
                "--quiet",
                "--depth",
                "1",  # Shallow clone
                *(
                    ["--branch", git_tag] if git_tag else []
                ),  # Add branch if tag is provided
                repo_url,
                target_dir,
            ]
        )
        print(f"Completed cloning {name}")
    else:
        print(f"Skipping cloning {name} as it already exists at {target_dir}")

    return target_dir


def run_in_parallel[T, U](
    func: Callable[[T], U],
    items: List[T],
    *,
    on_error=lambda item, exc: None,
    error_summary=lambda failures: None,
    max_workers=8,
) -> List[Optional[U]]:
    if not items:
        return []
    max_workers = min(max_workers, len(items))
    results = [None for _ in range(len(items))]
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        # Start cloning tasks and keep track of them
        futures = {
            executor.submit(func, item): index for index, item in enumerate(items)
        }
        # Process results as they complete
        for future in as_completed(futures):
            index = futures[future]
            try:
                results[index] = future.result()
            except Exception as e:
                on_error(items[index], e)
    failed = [item for item, result in zip(items, results) if result is None]
    if failed:
        error_summary(failed)
        sys.exit(1)
    return results


def clone_projects(projects: List[Project]) -> List[tuple[Project, str]]:
    """
    Clone all projects in parallel.

    Args:
        projects: List of projects to clone

    Returns:
        List of (project, project_dir) pairs in the same order as the input projects
    """
    start_time = time.time()
    dirs = run_in_parallel(
        clone_project,
        projects,
        on_error=lambda project, exc: print(
            f"ERROR: Failed to clone project {project['name']}: {exc}"
        ),
        error_summary=lambda failures: print(
            f"ERROR: Failed to clone {len(failures)} projects: {', '.join(p['name'] for p in failures)}"
        ),
    )
    clone_time = time.time() - start_time
    print(f"Cloning completed in {clone_time:.2f} seconds")
    return list(zip(projects, dirs))


def build_database(
    language: str, extractor_options, project: Project, project_dir: str
) -> str | None:
    """
    Build a CodeQL database for a project.

    Args:
        language: The language for which to build the database (e.g., "rust").
        extractor_options: Additional options for the extractor.
        project: A dictionary containing project information with 'name' and 'git-repo' keys.
        project_dir: Path to the CodeQL database.

    Returns:
        The path to the created database directory.
    """
    name = project["name"]

    # Create database directory path
    database_dir = os.path.join(build_dir, f"{name}-db")

    # Only build the database if it doesn't already exist
    if not os.path.exists(database_dir):
        print(f"Building CodeQL database for {name}...")
        extractor_options = [option for x in extractor_options for option in ("-O", x)]
        try:
            subprocess.check_call(
                [
                    "codeql",
                    "database",
                    "create",
                    f"--language={language}",
                    "--source-root=" + project_dir,
                    "--overwrite",
                    *extractor_options,
                    "--",
                    database_dir,
                ]
            )
            print(f"Successfully created database at {database_dir}")
        except subprocess.CalledProcessError as e:
            print(f"Failed to create database for {name}: {e}")
            return None
    else:
        print(
            f"Skipping database creation for {name} as it already exists at {database_dir}"
        )

    return database_dir


def generate_models(config, args, project: Project, database_dir: str) -> None:
    """
    Generate models for a project.

    Args:
        args: Command line arguments passed to this script.
        name: The name of the project.
        database_dir: Path to the CodeQL database.
    """
    name = project["name"]
    language = config["language"]

    generator = mad.Generator(language)
    # Note: The argument parser converts with-sinks to with_sinks, etc.
    generator.generateSinks = should_generate_sinks(project)
    generator.generateSources = should_generate_sources(project)
    generator.generateSummaries = should_generate_summaries(project)
    generator.threads = args.codeql_threads
    generator.ram = args.codeql_ram
    generator.setenvironment(database=database_dir, folder=name)
    generator.run()


def build_databases_from_projects(
    language: str, extractor_options, projects: List[Project]
) -> List[tuple[Project, str | None]]:
    """
    Build databases for all projects in parallel.

    Args:
        language: The language for which to build the databases (e.g., "rust").
        extractor_options: Additional options for the extractor.
        projects: List of projects to build databases for.

    Returns:
        List of (project_name, database_dir) pairs, where database_dir is None if the build failed.
    """
    # Clone projects in parallel
    print("=== Cloning projects ===")
    project_dirs = clone_projects(projects)

    # Build databases for all projects
    print("\n=== Building databases ===")
    database_results = [
        (
            project,
            build_database(language, extractor_options, project, project_dir),
        )
        for project, project_dir in project_dirs
    ]
    return database_results


def get_json_from_github(
    url: str, pat: str, extra_headers: dict[str, str] = {}
) -> dict:
    """
    Download a JSON file from GitHub using a personal access token (PAT).
    Args:
        url: The URL to download the JSON file from.
        pat: Personal Access Token for GitHub API authentication.
        extra_headers: Additional headers to include in the request.
    Returns:
        The JSON response as a dictionary.
    """
    headers = {"Authorization": f"token {pat}"} | extra_headers
    response = requests.get(url, headers=headers)
    if response.status_code != 200:
        print(f"Failed to download JSON: {response.status_code} {response.text}")
        sys.exit(1)
    else:
        return response.json()


def download_artifact(url: str, artifact_name: str, pat: str) -> str:
    """
    Download a GitHub Actions artifact from a given URL.
    Args:
        url: The URL to download the artifact from.
        artifact_name: The name of the artifact (used for naming the downloaded file).
        pat: Personal Access Token for GitHub API authentication.
    Returns:
        The path to the downloaded artifact file.
    """
    headers = {"Authorization": f"token {pat}", "Accept": "application/vnd.github+json"}
    response = requests.get(url, stream=True, headers=headers)
    zipName = artifact_name + ".zip"
    if response.status_code != 200:
        print(f"Failed to download file. Status code: {response.status_code}")
        sys.exit(1)
    target_zip = os.path.join(build_dir, zipName)
    with open(target_zip, "wb") as file:
        for chunk in response.iter_content(chunk_size=8192):
            file.write(chunk)
    print(f"Download complete: {target_zip}")
    return target_zip


def remove_extension(filename: str) -> str:
    while "." in filename:
        filename, _ = os.path.splitext(filename)
    return filename


def pretty_name_from_artifact_name(artifact_name: str) -> str:
    return artifact_name.split("___")[1]


def download_dca_databases(
    language: str,
    experiment_names: list[str],
    pat: str,
    projects: List[Project],
) -> List[tuple[Project, str | None]]:
    """
    Download databases from a DCA experiment.
    Args:
        experiment_names: The names of the DCA experiments to download databases from.
        pat: Personal Access Token for GitHub API authentication.
        projects: List of projects to download databases for.
    Returns:
        List of (project_name, database_dir) pairs, where database_dir is None if the download failed.
    """
    print("\n=== Finding projects ===")
    project_map = {project["name"]: project for project in projects}
    analyzed_databases = {}
    for experiment_name in experiment_names:
        response = get_json_from_github(
            f"https://raw.githubusercontent.com/github/codeql-dca-main/data/{experiment_name}/reports/downloads.json",
            pat,
        )
        targets = response["targets"]
        for data in targets.values():
            downloads = data["downloads"]
            analyzed_database = downloads["analyzed_database"]
            artifact_name = analyzed_database["artifact_name"]
            pretty_name = pretty_name_from_artifact_name(artifact_name)

            if not pretty_name in project_map:
                print(f"Skipping {pretty_name} as it is not in the list of projects")
                continue

            if pretty_name in analyzed_databases:
                print(
                    f"Skipping previous database {analyzed_databases[pretty_name]['artifact_name']} for {pretty_name}"
                )

            analyzed_databases[pretty_name] = analyzed_database

    def download_and_decompress(analyzed_database: dict) -> str:
        artifact_name = analyzed_database["artifact_name"]
        repository = analyzed_database["repository"]
        run_id = analyzed_database["run_id"]
        print(f"=== Finding artifact: {artifact_name} ===")
        response = get_json_from_github(
            f"https://api.github.com/repos/{repository}/actions/runs/{run_id}/artifacts",
            pat,
            {"Accept": "application/vnd.github+json"},
        )
        artifacts = response["artifacts"]
        artifact_map = {artifact["name"]: artifact for artifact in artifacts}
        print(f"=== Downloading artifact: {artifact_name} ===")
        archive_download_url = artifact_map[artifact_name]["archive_download_url"]
        artifact_zip_location = download_artifact(
            archive_download_url, artifact_name, pat
        )
        print(f"=== Decompressing artifact: {artifact_name} ===")
        # The database is in a zip file, which contains a tar.gz file with the DB
        # First we open the zip file
        with zipfile.ZipFile(artifact_zip_location, "r") as zip_ref:
            artifact_unzipped_location = os.path.join(build_dir, artifact_name)
            # clean up any remnants of previous runs
            shutil.rmtree(artifact_unzipped_location, ignore_errors=True)
            # And then we extract it to build_dir/artifact_name
            zip_ref.extractall(artifact_unzipped_location)
            # And then we extract the language tar.gz file inside it
            artifact_tar_location = os.path.join(
                artifact_unzipped_location, f"{language}.tar.gz"
            )
            with tarfile.open(artifact_tar_location, "r:gz") as tar_ref:
                # And we just untar it to the same directory as the zip file
                tar_ref.extractall(artifact_unzipped_location)
        ret = os.path.join(artifact_unzipped_location, language)
        print(f"Decompression complete: {ret}")
        return ret

    results = run_in_parallel(
        download_and_decompress,
        list(analyzed_databases.values()),
        on_error=lambda db, exc: print(
            f"ERROR: Failed to download and decompress {db["artifact_name"]}: {exc}"
        ),
        error_summary=lambda failures: print(
            f"ERROR: Failed to download {len(failures)} databases: {', '.join(item[0] for item in failures)}"
        ),
    )

    print(f"\n=== Fetched {len(results)} databases ===")

    return [(project_map[n], r) for n, r in zip(analyzed_databases, results)]


def get_mad_destination_for_project(config, name: str) -> str:
    return os.path.join(config["destination"], name)


def get_strategy(config) -> str:
    return config["strategy"].lower()


def main(config, args) -> None:
    """
    Main function to handle the bulk generation of MaD models.
    Args:
        config: Configuration dictionary containing project details and other settings.
        args: Command line arguments passed to this script.
    """

    projects = config["targets"]
    if not "language" in config:
        print("ERROR: 'language' key is missing in the configuration file.")
        sys.exit(1)
    language = config["language"]

    # Create build directory if it doesn't exist
    if not os.path.exists(build_dir):
        os.makedirs(build_dir)

    database_results = []
    match get_strategy(config):
        case "repo":
            extractor_options = config.get("extractor_options", [])
            database_results = build_databases_from_projects(
                language,
                extractor_options,
                projects,
            )
        case "dca":
            experiment_names = args.dca
            if experiment_names is None:
                print("ERROR: --dca argument is required for DCA strategy")
                sys.exit(1)

            if args.pat is None:
                print("ERROR: --pat argument is required for DCA strategy")
                sys.exit(1)
            if not os.path.exists(args.pat):
                print(f"ERROR: Personal Access Token file '{pat}' does not exist.")
                sys.exit(1)
            with open(args.pat, "r") as f:
                pat = f.read().strip()
                database_results = download_dca_databases(
                    language,
                    experiment_names,
                    pat,
                    projects,
                )

    # Generate models for all projects
    print("\n=== Generating models ===")

    failed_builds = [
        project["name"] for project, db_dir in database_results if db_dir is None
    ]
    if failed_builds:
        print(
            f"ERROR: {len(failed_builds)} database builds failed: {', '.join(failed_builds)}"
        )
        sys.exit(1)

    # Delete the MaD directory for each project
    for project, database_dir in database_results:
        mad_dir = get_mad_destination_for_project(config, project["name"])
        if os.path.exists(mad_dir):
            print(f"Deleting existing MaD directory at {mad_dir}")
            subprocess.check_call(["rm", "-rf", mad_dir])

    for project, database_dir in database_results:
        if database_dir is not None:
            generate_models(config, args, project, database_dir)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--config", type=str, help="Path to the configuration file.", required=True
    )
    parser.add_argument(
        "--dca",
        type=str,
        help="Name of a DCA run that built all the projects. Can be repeated, with sources taken from all provided runs, "
        "the last provided ones having priority",
        action="append",
    )
    parser.add_argument(
        "--pat",
        type=str,
        help="Path to a file containing the PAT token required to grab DCA databases (the same as the one you use for DCA)",
    )
    parser.add_argument(
        "--codeql-ram",
        type=int,
        help="What `--ram` value to pass to `codeql` while generating models (by default 2048 MB per thread)",
        default=None,
    )
    parser.add_argument(
        "--codeql-threads",
        type=int,
        help="What `--threads` value to pass to `codeql` (default %(default)s)",
        default=0,
    )
    args = parser.parse_args()

    # Load config file
    config = {}
    if not os.path.exists(args.config):
        print(f"ERROR: Config file '{args.config}' does not exist.")
        sys.exit(1)
    try:
        with open(args.config, "r") as f:
            config = yaml.safe_load(f)
    except yaml.YAMLError as e:
        print(f"ERROR: Failed to parse YAML file {args.config}: {e}")
        sys.exit(1)

    main(config, args)
