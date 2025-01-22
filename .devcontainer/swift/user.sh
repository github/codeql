set -xe

# add the workspace to the codeql search path
mkdir -p /home/vscode/.config/codeql
echo "--search-path /workspaces/codeql" > /home/vscode/.config/codeql/config

# create a swift extractor pack with the current state
cd /workspaces/codeql
bazel run swift/create-extractor-pack

#install and set up pre-commit
python3 -m pip install pre-commit --no-warn-script-location
$HOME/.local/bin/pre-commit install
