# Extractor Python CodeQL CLI integration tests

To ensure that the two work together as intended, and as an easy way to set up realistic test-cases.


### Adding a new test case

Add a new folder, place a file called `test.sh` in it, which should start with the code below. The script should exit with failure code to fail the test.

```bash
#!/bin/bash

set -Eeuo pipefail # see https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

set -x

CODEQL=${CODEQL:-codeql}

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPTDIR"
```
