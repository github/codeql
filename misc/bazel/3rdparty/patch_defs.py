import sys
import re
import pathlib

# Problem number 1:
# https://github.com/bazelbuild/rules_rust/issues/3255
# `crates_vendor` generates broken labels in `defs.bzl`: instead of
#     "anyhow": Label("@vendor__anyhow-1.0.44//:anyhow")
# it produces
#     "anyhow": Label("@vendor//:anyhow-1.0.44")
# which results in: ERROR: no such package '@@[unknown repo 'vendor' requested from @@]//'
#
# Problem number 2:
# Semver versions can contain `+` for build metadata (e.g., `0.9.11+spec-1.1.0`).
# Bazel repo names use `-` instead of `+`, so `vendor_ts__toml-0.9.11+spec-1.1.0`
# becomes `vendor_ts__toml-0.9.11-spec-1.1.0`. The generated labels reference the
# `+` version which doesn't exist, causing:
#     ERROR: no such package '@@[unknown repo 'vendor_ts__toml-0.9.11+spec-1.1.0'
#     requested from @@ (did you mean 'vendor_ts__toml-0.9.11-spec-1.1.0'?)]//

label_re = re.compile(r'"@(vendor.*)//:([^+]+)-([\d.]+(?:\+.*)?)"')

file = pathlib.Path(sys.argv[1])
temp = file.with_suffix(f'{file.suffix}.tmp')


with open(file) as input, open(temp, "w") as output:
    for line in input:
        line = label_re.sub(lambda m: f'"@{m[1]}__{m[2]}-{m[3].replace("+", "-")}//:{m[2].replace("-", "_")}"', line)
        output.write(line)

temp.rename(file)
