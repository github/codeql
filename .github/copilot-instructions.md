When reviewing code:
* do not review changes in files with `.expected` extension (they are automatically ensured to be correct).
* in `.ql` and `.qll` files, do not try to review the code itself as you don't understand the programming language
  well enough to make comments in these languages. You can still check for typos or comment improvements.

When editing `.ql` and `.qll` files:
* All edited `.ql` and `.qll` files should be autoformatted afterwards using the CodeQL CLI.
* To install and use the CodeQL CLI autoformatter:
  1. Download and extract CodeQL CLI: `cd /tmp && curl -L -o codeql-linux64.zip https://github.com/github/codeql-cli-binaries/releases/latest/download/codeql-linux64.zip && unzip -q codeql-linux64.zip`
  2. Add to PATH: `export PATH="/tmp/codeql:$PATH"`
  3. Run autoformatter: `codeql query format [file] --in-place`
