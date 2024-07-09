set -xe

# git lfs install may fail because codespaces can install its own hooks
# let's install it manually
for script in pre-push post-checkout post-commit post-merge; do
  if [ -x .git/hooks/$script ]; then
    sed -i "2i git lfs $script || exit 1" .git/hooks/$script
  else
    printf "#!/bin/bash\ngit lfs %s\n" $script > .git/hooks/$script
    chmod +x .git/hooks/$script
  fi
done

# add the workspace to the codeql search path
mkdir -p /home/vscode/.config/codeql
echo "--search-path /workspaces/codeql" > /home/vscode/.config/codeql/config

# create a swift extractor pack with the current state
cd /workspaces/codeql
bazel run swift/create-extractor-pack

#install and set up pre-commit
python3 -m pip install pre-commit --no-warn-script-location
$HOME/.local/bin/pre-commit install
