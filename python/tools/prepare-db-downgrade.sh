#!/bin/sh
#
# Prepare the downgrade script directory for a Python database schema downgrade.

set -e
set -u

app_name="$(basename "$0")"

usage()
{
  exit_code="$1"
  shift

  cat >&2 <<EOF
${app_name}: $@
${app_name}: Generate skeleton downgrade script.
Usage: ${app_name} [--prev_hash <COMMITISH>]"

--prev-hash <COMMITISH>
        Hash/branch to use to get SHA1 for previous DB scheme.
        Default: origin/main

Must be run within the git repo needing an update.
EOF
  exit "${exit_code}"
}

prev_hash="origin/main"

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

scheme_file_name="semmlecode.python.dbscheme"
scheme_file="ql/lib/${scheme_file_name}"
downgrade_root="ql/downgrades"

check_hash_valid()
{
  if [ ${#2} -ne 40 ]; then
    echo "Did not get expected $1 hash: $2" >&2
    exit 2
  fi
}

# Get the hash of the previous and current DB Schema files
prev_hash="$(git show "${prev_hash}:python/${scheme_file}" | git hash-object --stdin)"
check_hash_valid previous "${prev_hash}"
current_hash="$(git hash-object "${scheme_file}")"
check_hash_valid current "${current_hash}"
if [ "${current_hash}" = "${prev_hash}" ]; then
  echo "No work to be done."
  exit
fi

# Copy current and new dbscheme into the downgrade dir
downgradedir="${downgrade_root}/${current_hash}"
mkdir -p "${downgradedir}"

cp "${scheme_file}" "${downgradedir}/old.dbscheme"
git cat-file blob "${prev_hash}" > "${downgradedir}/${scheme_file_name}"

# Create the template downgrade.properties file.
cat <<EOF > "${downgradedir}/downgrade.properties"
description: <INSERT DESCRIPTION HERE>
compatibility: full|backwards|partial|breaking
EOF

# Tell user what we've done
cat <<EOF
Created downgrade directory here:
  ${downgradedir}

Please update:
  ${downgradedir}/downgrade.properties
with appropriate downgrade instructions
EOF
