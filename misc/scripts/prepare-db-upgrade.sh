#!/bin/sh
#
# Prepare the upgrade and downgrade script directories for a DB Schema upgrade.

set -e
set -u

app_name="$(basename "$0")"
app_dir="$(dirname "$0")"

usage()
{
  exit_code="$1"
  shift

  cat >&2 <<EOF
${app_name}: $@
${app_name}: Generate skeleton upgrade script.
Usage: ${app_name} --lang <LANG> [--prev_hash <COMMITISH>]"

--lang <LANG>
        Language to update the schema for.

--prev-hash <COMMITISH>
        Hash/branch to use to get SHA1 for previous DB scheme.
        Default: origin/main

Must be run within the git repo needing an update.
EOF
  exit "${exit_code}"
}

# default for prev_hash: the main branch of the remote for 'github/codeql'.
# This works out as a dynamic lookup of the hash of the file in the main branch
# of the repo.
prev_hash=$(git remote -v | grep 'github/codeql\.git (fetch)$' | cut -f1)/main

while [ $# -gt 0 ]; do
  case "$1" in
    -x)
      set -x
      ;;
    -h | --help)
      usage 0
      ;;
    --prev-hash)
      if [ $# -eq 1 ]; then
        usage 2 "--prev-hash requires Commit/Branch option"
      fi
      shift
      prev_hash="$1"
      ;;
    --lang)
      if [ $# -eq 1 ]; then
        usage 2 "--lang requires a language option"
      fi
      shift
      lang="$1"
      ;;
    --)
      shift
      break
      ;;
    -*)
      usage 2 "Unrecognised option: $1"
      ;;
    *)
      break
      ;;
  esac
  shift
done

if [ $# -gt 0 ]; then
  usage 2 "Unrecognised operand: $1"
fi

if [ -z ${lang+x} ]; then
  usage 2 "No language specified"
fi

case "${lang}" in
  java)
    scheme_file="${lang}/ql/lib/config/semmlecode.dbscheme"
    ;;
  csharp | cpp | javascript | python)
    scheme_file="${lang}/ql/lib/semmlecode.${lang}.dbscheme"
    ;;
  go | ruby | swift)
    scheme_file="${lang}/ql/lib/${lang}.dbscheme"
    ;;
  *)
    usage 2 "Unrecognised language: ${lang}"
    ;;
esac

cd ${app_dir}
qldir="$(git rev-parse --show-toplevel)"

if [ "x${qldir}" = "x" ]; then
  usage 2 "Script not in a code repository."
fi

upgrade_root="${qldir}/${lang}/ql/lib/upgrades"
downgrade_root="${qldir}/${lang}/downgrades"

check_hash_valid()
{
  if [ ${#2} -ne 40 ]; then
    echo "Did not get expected $1 hash: $2" >&2
    exit 2
  fi
}

# Get the hash of the previous and current DB Schema files
cd "${qldir}"
prev_hash="$(git show "${prev_hash}:${scheme_file}" | git hash-object --stdin)"
check_hash_valid previous "${prev_hash}"
current_hash="$(git hash-object "${scheme_file}")"
check_hash_valid current "${current_hash}"
if [ "${current_hash}" = "${prev_hash}" ]; then
  echo "No work to be done."
  exit
fi

create_upgrade_properties()
{
  cat <<EOF > "$1/upgrade.properties"
description: <INSERT DESCRIPTION HERE>
compatibility: full|backwards|partial|breaking
EOF
}

# Copy current and new dbscheme into the upgrade dir
upgradedir="${upgrade_root}/${prev_hash}"
mkdir -p "${upgradedir}"

cp "${scheme_file}" "${upgradedir}"
git cat-file blob "${prev_hash}" > "${upgradedir}/old.dbscheme"

create_upgrade_properties "${upgradedir}"

# Copy current and new dbscheme into the downgrade dir
downgradedir="${downgrade_root}/${current_hash}"
mkdir -p "${downgradedir}"

cp "${scheme_file}" "${downgradedir}/old.dbscheme"
git cat-file blob "${prev_hash}" > "${downgradedir}/$(basename "${scheme_file}")"

create_upgrade_properties "${downgradedir}"

# Tell user what we've done
cat <<EOF
Created upgrade directory here:
  ${upgradedir}
Created downgrade directory here:
  ${downgradedir}

Please update:
  ${upgradedir}/upgrade.properties
  ${downgradedir}/upgrade.properties
with appropriate instructions
EOF
