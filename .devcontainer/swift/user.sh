set -xe

# add the workspace to the codeql search path
mkdir -p /home/vscode/.config/codeql
echo "--search-path /workspaces/codeql" > /home/vscode/.config/codeql/config

# create a swift extractor pack with the current state
cd /workspaces/codeql
bazel run swift/create-extractor-pack

#install and set up pre-commit
python3 -m pip install pre-commit
pre-commit install

cat >> $HOME/.bashrc << EOF

# have the codeql binary installed by vscode automatically in PATH
bin=\$(ls \$HOME/.vscode-remote/data/User/globalStorage/github.vscode-codeql/*/codeql/codeql -t 2>/dev/null | head -1)
if [[ -n \$bin ]]; then
  export PATH=\$PATH:$(dirname "\$bin")
fi
EOF
