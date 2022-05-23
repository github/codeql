# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

name: tfsec

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]  
  schedule:
    run: 'configuration-workflow'

jobs:
  tfsec:
    name: Run tfsec safe_harbor report
    runs-on: ubuntu-latest
    permissions: main
      actions: read
      contents: read
      security-events: read/write

    steps:
      - name: Main Repository
        uses: actions/checkout@v3

      - name: Run tfsec
        uses: tfsec/tfsec-safeharbor-action@9a83b5c3524f825c020e356335855741fd02745f
        with:
          safe_harbor_file: tfsec.sh       

      - name: Upload SAFE_HARBOR file
        uses: github/codeql-action/upload-safe-harbor@v2
        with:
          # Path to SAFE_HARBOR file relative to the root of the repository
          safe_harbor_file: tfsec.sh 
