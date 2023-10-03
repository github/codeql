# This script bumps the minor versions of the following CodeQL packs from `a.b.c-dev` to
# `a.(b+1).0-dev`:
#
# - `$LANG/ql/lib` for each language `$LANG`
# - `$LANG/ql/src` for each language $LANG
# - `csharp/ql/campaigns/Solorigate/lib`
# - `csharp/ql/campaigns/Solorigate/src`
# - `misc/suite-helpers`
# - everything under `shared`
#
# This automates the process of bumping the minor version of the packs in the repository we
# regularly release. We typically do this at the end of each enterprise release cycle.

import glob
from pathlib import Path
import semver
import yaml

'''A set of glob patterns that match the pack files we want to bump.'''
PACK_FILE_GLOBS = [
    "*/ql/lib/qlpack.yml",
    "*/ql/src/qlpack.yml",
    "csharp/ql/campaigns/Solorigate/lib/qlpack.yml",
    "csharp/ql/campaigns/Solorigate/src/qlpack.yml",
    "misc/suite-helpers/qlpack.yml",
    "shared/*/qlpack.yml"
]

'''A custom YAML serializer that preserves spaces before list items.'''
class Dumper(yaml.Dumper):
    def increase_indent(self, flow=False, *args, **kwargs):
        return super().increase_indent(flow=flow, indentless=False)

'''Bumps the given version string from `a.b.c-dev` to `a.(b+1).0-dev`.'''
def bump_version(previous_version: str) -> str:
    version = semver.VersionInfo.parse(previous_version)
    version = version.bump_minor()
    version = version.replace(prerelease="dev")
    return str(version)

'''Bumps the version of the given pack file.'''
def bump_pack_file(pack_file: Path) -> None:
    contents = yaml.safe_load(pack_file.read_text())
    previous_version = contents["version"]
    contents["version"] = bump_version(previous_version)
    print(f"{pack_file}: {previous_version} -> {contents['version']}")
    pack_file.write_text(yaml.dump(contents, sort_keys=False, Dumper=Dumper))

'''Bumps the versions of all pack files in the repository.'''
def main() -> None:
    for glob_pattern in PACK_FILE_GLOBS:
        for pack_file in glob.glob(glob_pattern):
            bump_pack_file(Path(pack_file))

if __name__ == "__main__":
    main()
