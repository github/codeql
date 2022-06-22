# have the codeql binary installed by vscode automatically in PATH
bin=$(ls $HOME/.vscode-remote/data/User/globalStorage/github.vscode-codeql/*/codeql/codeql -t 2>/dev/null | head -1)
if [[ -n $bin ]]; then
  export PATH=$PATH:$(dirname "$bin")
fi
