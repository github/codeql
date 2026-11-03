#!/usr/bin/env python3

import argparse
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path, PurePosixPath


QUERY_KIND = re.compile(r"^\s*\*\s*@kind\s+\S+", re.MULTILINE)
PACK_NAME = re.compile(r"^\s*name:\s*([^#\s]+)\s*(?:#.*)?$", re.MULTILINE)
DEPENDENCY = re.compile(r"^\s+([^#\s][^:]*):")
IMPORT = re.compile(r"^\s*(?:private\s+)?import\s+(.+?)\s*$")


@dataclass(frozen=True)
class Pack:
    name: str
    root: Path
    dependencies: frozenset[str]


@dataclass(frozen=True)
class Test:
    path: Path
    query: Path


def git_changed_files(repository: Path, base: str, head: str) -> list[Path]:
    result = subprocess.run(
        [
            "git",
            "diff",
            "--name-only",
            "--diff-filter=AMR",
            "-z",
            f"{base}...{head}",
        ],
        cwd=repository,
        check=True,
        capture_output=True,
    )
    return [
        repository / Path(PurePosixPath(path.decode("utf-8")))
        for path in result.stdout.split(b"\0")
        if path
    ]


def nearest_pack(path: Path, repository: Path) -> Path | None:
    for parent in path.parents:
        pack = parent / "qlpack.yml"
        if pack.is_file():
            return pack
        if parent == repository:
            break
    return None


def pack_name(pack: Path) -> str | None:
    match = PACK_NAME.search(pack.read_text(encoding="utf-8"))
    return match.group(1).strip("\"'") if match else None


def pack_dependencies(pack: Path) -> set[str]:
    dependencies: set[str] = set()
    in_dependencies = False
    for line in pack.read_text(encoding="utf-8").splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if not line[0].isspace():
            key, _, value = line.partition(":")
            in_dependencies = key in {"dependencies", "libraryPathDependencies"}
            if key == "libraryPathDependencies" and value.strip():
                dependencies.add(value.strip().strip("\"'"))
            continue
        if in_dependencies and (match := DEPENDENCY.match(line)):
            dependencies.add(match.group(1).strip("\"'"))
    return dependencies


def workspace_packs(repository: Path) -> dict[str, Pack]:
    packs = {}
    for manifest in repository.rglob("qlpack.yml"):
        if (name := pack_name(manifest)) is not None:
            packs.setdefault(
                name, Pack(name, manifest.parent, frozenset(pack_dependencies(manifest)))
            )
    return packs


def visible_roots(pack: Pack, packs: dict[str, Pack]) -> tuple[Path, ...]:
    roots = []
    visited = set()

    def visit(current: Pack) -> None:
        if current.name in visited:
            return
        visited.add(current.name)
        roots.append(current.root)
        for dependency in current.dependencies:
            if dependency in packs:
                visit(packs[dependency])

    visit(pack)
    return tuple(roots)


def query_reference(qlref: Path) -> str | None:
    lines = [
        line.strip()
        for line in qlref.read_text(encoding="utf-8-sig").splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    ]
    if not lines:
        return None
    if lines[0].startswith("query:"):
        return lines[0].partition(":")[2].strip().strip("\"'")
    if ":" not in lines[0]:
        return lines[0].strip("\"'")
    return None


def resolve_test_query(
    qlref: Path, reference: str, packs: dict[str, Pack], repository: Path
) -> Path | None:
    relative = Path(PurePosixPath(reference))
    local_query = qlref.parent / relative
    if local_query.is_file():
        return local_query.resolve()

    manifest = nearest_pack(qlref, repository)
    packs_by_root = {pack.root: pack for pack in packs.values()}
    if manifest is None or manifest.parent not in packs_by_root:
        return None
    for root in visible_roots(packs_by_root[manifest.parent], packs):
        candidate = root / relative
        if candidate.is_file():
            return candidate.resolve()
    return None


def unit_tests(repository: Path, packs: dict[str, Pack]) -> list[Test]:
    tests = set()
    for qlref in repository.rglob("*.qlref"):
        if (reference := query_reference(qlref)) is not None:
            if (query := resolve_test_query(qlref, reference, packs, repository)) is not None:
                tests.add(Test(qlref.resolve(), query))
    for expected in repository.rglob("*.expected"):
        query = expected.with_suffix(".ql")
        if query.is_file() and nearest_pack(query, repository) is not None:
            tests.add(Test(query.resolve(), query.resolve()))
    return sorted(tests, key=lambda test: str(test.path))


def changed_queries(repository: Path, changed_files: list[Path]) -> list[Path]:
    queries = []
    for path in changed_files:
        if path.suffix != ".ql" or not path.is_file():
            continue
        if not QUERY_KIND.search(path.read_text(encoding="utf-8")):
            continue
        pack = nearest_pack(path, repository)
        if pack is None or pack_name(pack) is None:
            print(f"warning: could not determine the query pack for {path.relative_to(repository)}")
            continue
        queries.append(path.resolve())
    return queries


def import_name(import_text: str) -> str | None:
    module = (
        import_text.split(" as ", 1)[0]
        .split("::", 1)[0]
        .split("<", 1)[0]
        .strip()
    )
    return module if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_.]*", module) else None


def imported_module(importer: Path, module: str, roots: tuple[Path, ...]) -> Path | None:
    if (module := import_name(module)) is None:
        return None
    relative = Path(*module.split(".")).with_suffix(".qll")
    for candidate in (importer.parent / relative, *(root / relative for root in roots)):
        if candidate.is_file():
            return candidate.resolve()
    return None


def import_index(repository: Path) -> dict[str, set[Path]]:
    index: dict[str, set[Path]] = {}
    for importer in (*repository.rglob("*.ql"), *repository.rglob("*.qll")):
        for line in importer.read_text(encoding="utf-8-sig").splitlines():
            match = IMPORT.match(line.partition("//")[0])
            if match is not None and (module := import_name(match.group(1))) is not None:
                index.setdefault(module, set()).add(importer.resolve())
    return index


def possible_import_names(library: Path, pack_root: Path) -> set[str]:
    parts = library.relative_to(pack_root).with_suffix("").parts
    return {".".join(parts[index:]) for index in range(len(parts))}


def affected_queries(
    repository: Path, libraries: list[Path], packs: dict[str, Pack]
) -> set[Path]:
    index = import_index(repository)
    packs_by_root = {pack.root: pack for pack in packs.values()}
    roots_cache: dict[Path, tuple[Path, ...]] = {}
    affected = set()
    pending = [library.resolve() for library in libraries]
    visited = set(pending)
    while pending:
        library = pending.pop()
        manifest = nearest_pack(library, repository)
        if manifest is None:
            continue
        for module in possible_import_names(library, manifest.parent):
            for importer in index.get(module, set()):
                importer_manifest = nearest_pack(importer, repository)
                if (
                    importer_manifest is None
                    or importer_manifest.parent not in packs_by_root
                ):
                    continue
                if importer_manifest not in roots_cache:
                    roots_cache[importer_manifest] = visible_roots(
                        packs_by_root[importer_manifest.parent], packs
                    )
                if imported_module(
                    importer, module, roots_cache[importer_manifest]
                ) != library:
                    continue
                if importer.suffix == ".ql":
                    affected.add(importer)
                elif importer not in visited:
                    visited.add(importer)
                    pending.append(importer)
    return affected


def corresponding_tests(
    repository: Path,
    queries: list[Path],
    libraries: list[Path],
    tests: list[Test],
    packs: dict[str, Pack],
) -> tuple[list[Path], list[Path]]:
    selected = {test.path for test in tests if test.query in queries}
    if libraries:
        imported_by_affected_queries = affected_queries(repository, libraries, packs)
        selected.update(
            test.path for test in tests if test.query in imported_by_affected_queries
        )

    tested_queries = {test.query for test in tests}
    untested = []
    for query in queries:
        if query not in tested_queries:
            untested.append(query)
    return sorted(selected), untested


def changed_libraries(changed_files: list[Path]) -> list[Path]:
    libraries = []
    for path in changed_files:
        if path.suffix != ".qll" or not path.is_file():
            continue
        libraries.append(path.resolve())
    return libraries


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Find unit tests corresponding to added or modified CodeQL queries."
    )
    parser.add_argument("--base", help="Base commit for the pull request diff.")
    parser.add_argument("--head", help="Head commit for the pull request diff.")
    parser.add_argument(
        "--changed-file",
        action="append",
        default=[],
        help="Use an explicit changed file instead of a Git diff. May be repeated.",
    )
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()

    repository = Path.cwd().resolve()
    if args.changed_file:
        changed_files = [repository / Path(PurePosixPath(path)) for path in args.changed_file]
    elif args.base and args.head:
        changed_files = git_changed_files(repository, args.base, args.head)
    else:
        parser.error("provide either --changed-file or both --base and --head")

    packs = workspace_packs(repository)
    queries = changed_queries(repository, changed_files)
    libraries = changed_libraries(changed_files)
    tests, untested = corresponding_tests(
        repository, queries, libraries, unit_tests(repository, packs), packs
    )
    args.output.write_text(
        "".join(f"{test.relative_to(repository).as_posix()}\n" for test in tests),
        encoding="utf-8",
    )

    if not queries and not libraries:
        print("No added or modified CodeQL queries or libraries found.")
        return 0

    if queries:
        print("Added or modified CodeQL queries:")
        for query in queries:
            print(f"  {query.relative_to(repository).as_posix()}")
    if libraries:
        print("Added or modified CodeQL libraries:")
        for library in libraries:
            print(f"  {library.relative_to(repository).as_posix()}")
    if tests:
        print("Corresponding unit tests:")
        for test in tests:
            print(f"  {test.relative_to(repository).as_posix()}")
    if untested:
        print("Queries without a corresponding unit test:")
        for query in untested:
            print(f"  {query.relative_to(repository).as_posix()}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
