#!/bin/sh
#
# Prepare the upgrade script directory for a Ruby database schema upgrade. Now
# just forwards to the language-independent script.

set -eu
app_dir="$(dirname "$0")"
"${app_dir}/../../misc/scripts/prepare-db-upgrade.sh" --lang ruby "$@"
