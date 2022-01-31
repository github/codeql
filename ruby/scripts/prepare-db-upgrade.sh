#!/bin/sh
#
# Prepare the upgrade script directory for a Ruby database schema upgrade.

set -e
set -u

app_name="$(basename "$0")"

usage()
{
  exit_code="$1"
  shift

  cat >&2 <<EOF
${app_name}: $@
${app_name}: Generate skeleton upgrade script.
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

scheme_file="ql/lib/ruby.dbscheme"
upgrade_root="ql/lib/upgrades"

check_hash_valid()
{
  if [ ${#2} -ne 40 ]; then
    echo "Did not get expected $1 hash: $2" >&2
    exit 2
  fi
}

# Get the hash of the previous and current DB Schema files
prev_hash="$(git show "${prev_hash}:ruby/${scheme_file}" | git hash-object --stdin)"
check_hash_valid previous "${prev_hash}"
current_hash="$(git hash-object "${scheme_file}")"
check_hash_valid current "${current_hash}"
if [ "${current_hash}" = "${prev_hash}" ]; then
  echo "No work to be done."
  exit
fi

# Copy current and new dbscheme into the upgrade dir
upgradedir="${upgrade_root}/${prev_hash}"
mkdir -p "${upgradedir}"

cp "${scheme_file}" "${upgradedir}"
git cat-file blob "${prev_hash}" > "${upgradedir}/old.dbscheme"

# Create the template upgrade.properties file.
cat <<EOF > "${upgradedir}/upgrade.properties"
description: <INSERT DESCRIPTION HERE>
compatibility: full|backwards|partial|breaking
EOF

# Tell user what we've done
cat <<EOF
Created upgrade directory here:
  ${upgradedir}

Please update:
  ${upgradedir}/upgrade.properties
with appropriate upgrade instructions
EOF
