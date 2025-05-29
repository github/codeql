"""
Experimental script for bulk generation of MaD models based on a list of projects.

Currently the script only targets Rust.
"""

import os.path
import subprocess
import sys
from typing import NotRequired, TypedDict, List
from concurrent.futures import ThreadPoolExecutor, as_completed
import time
import argparse
import json
import requests
import zipfile
import tarfile
from functools import cmp_to_key

import generate_mad as mad

gitroot = (
    subprocess.check_output(["git", "rev-parse", "--show-toplevel"])
    .decode("utf-8")
    .strip()
)
build_dir = os.path.join(gitroot, "mad-generation-build")

# A project to generate models for
class Project(TypedDict):
    """
    Type definition for projects (acquired via a GitHub repo) to model.

    Attributes:
        name: The name of the project
        git_repo: URL to the git repository
        git_tag: Optional Git tag to check out
    """

    name: str
    git_repo: str
    git_tag: NotRequired[str]


def clone_project(project: Project) -> str:
    """
    Shallow clone a project into the build directory.

    Args:
        project: A dictionary containing project information with 'name', 'git_repo', and optional 'git_tag' keys.

    Returns:
        The path to the cloned project directory.
    """
    name = project["name"]
    repo_url = project["git_repo"]
    git_tag = project.get("git_tag")

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


def clone_projects(projects: List[Project]) -> List[tuple[Project, str]]:
    """
    Clone all projects in parallel.

    Args:
        projects: List of projects to clone

    Returns:
        List of (project, project_dir) pairs in the same order as the input projects
    """
    start_time = time.time()
    max_workers = min(8, len(projects))  # Use at most 8 threads
    project_dirs_map = {}  # Map to store results by project name

    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        # Start cloning tasks and keep track of them
        future_to_project = {
            executor.submit(clone_project, project): project for project in projects
        }

        # Process results as they complete
        for future in as_completed(future_to_project):
            project = future_to_project[future]
            try:
                project_dir = future.result()
                project_dirs_map[project["name"]] = (project, project_dir)
            except Exception as e:
                print(f"ERROR: Failed to clone {project['name']}: {e}")

    if len(project_dirs_map) != len(projects):
        failed_projects = [
            project["name"]
            for project in projects
            if project["name"] not in project_dirs_map
        ]
        print(
            f"ERROR: Only {len(project_dirs_map)} out of {len(projects)} projects were cloned successfully. Failed projects: {', '.join(failed_projects)}"
        )
        sys.exit(1)

    project_dirs = [project_dirs_map[project["name"]] for project in projects]

    clone_time = time.time() - start_time
    print(f"Cloning completed in {clone_time:.2f} seconds")
    return project_dirs


def build_database(language: str, extractor_options, project: Project, project_dir: str) -> str | None:
    """
    Build a CodeQL database for a project.

    Args:
        language: The language for which to build the database (e.g., "rust").
        extractor_options: Additional options for the extractor.
        project: A dictionary containing project information with 'name' and 'git_repo' keys.
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

def generate_models(args, name: str, database_dir: str) -> None:
    """
    Generate models for a project.

    Args:
        args: Command line arguments passed to this script.
        name: The name of the project.
        database_dir: Path to the CodeQL database.
    """

    generator = mad.Generator(args.lang)
    generator.generateSinks = args.with_sinks
    generator.generateSources = args.with_sources
    generator.generateSummaries = args.with_summaries
    generator.setenvironment(database=database_dir, folder=name)
    generator.run()

def build_databases_from_projects(language: str, extractor_options, projects: List[Project]) -> List[tuple[str, str | None]]:
    """
    Build databases for all projects in parallel.

    Args:
        language: The language for which to build the databases (e.g., "rust").
        extractor_options: Additional options for the extractor.
        projects: List of projects to build databases for.

    Returns:
        List of (project_name, database_dir) pairs, where database_dir is None if the build failed.
    """
    # Phase 1: Clone projects in parallel
    print("=== Phase 1: Cloning projects ===")
    project_dirs = clone_projects(projects)

    # Phase 2: Build databases for all projects
    print("\n=== Phase 2: Building databases ===")
    database_results = [
        (project["name"], build_database(language, extractor_options, project, project_dir))
        for project, project_dir in project_dirs
    ]
    return database_results
      
def get_destination_for_project(config, name: str) -> str:
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
    destination = config["destination"]
    language = args.lang

    # Create build directory if it doesn't exist
    if not os.path.exists(build_dir):
        os.makedirs(build_dir)

    # Check if any of the MaD directories contain working directory changes in git
    for project in projects:
        mad_dir = get_destination_for_project(config, project["name"])
        if os.path.exists(mad_dir):
            git_status_output = subprocess.check_output(
                ["git", "status", "-s", mad_dir], text=True
            ).strip()
            if git_status_output:
                print(
                    f"""ERROR: Working directory changes detected in {mad_dir}.

Before generating new models, the existing models are deleted.

To avoid loss of data, please commit your changes."""
                )
                sys.exit(1)

    database_results = []
    match get_strategy(config):
        case "repo":
            extractor_options = config.get("extractor_options", [])
            database_results = build_databases_from_projects(language, extractor_options, projects)

    # Phase 3: Generate models for all projects
    print("\n=== Phase 3: Generating models ===")

    failed_builds = [
        project for project, db_dir in database_results if db_dir is None
    ]
    if failed_builds:
        print(
            f"ERROR: {len(failed_builds)} database builds failed: {', '.join(failed_builds)}"
        )
        sys.exit(1)

    # Delete the MaD directory for each project
    for project, database_dir in database_results:
        mad_dir = get_destination_for_project(config, project)
        if os.path.exists(mad_dir):
            print(f"Deleting existing MaD directory at {mad_dir}")
            subprocess.check_call(["rm", "-rf", mad_dir])

    for project, database_dir in database_results:
        if database_dir is not None:
            generate_models(args, project, database_dir)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", type=str, help="Path to the configuration file.", required=True)
    parser.add_argument("--lang", type=str, help="The language to generate models for", required=True)
    parser.add_argument("--with-sources", action="store_true", help="Generate sources", required=False)
    parser.add_argument("--with-sinks", action="store_true", help="Generate sinks", required=False)
    parser.add_argument("--with-summaries", action="store_true", help="Generate sinks", required=False)
    args = parser.parse_args()

    # Load config file
    config = {}
    if not os.path.exists(args.config):
        print(f"ERROR: Config file '{args.config}' does not exist.")
        sys.exit(1)
    try:
        with open(args.config, "r") as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        print(f"ERROR: Failed to parse JSON file {args.config}: {e}")
        sys.exit(1)

    main(config, args)
