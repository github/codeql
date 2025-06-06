---
category: minorAnalysis
---

- The Python extractor now extracts files in hidden directories by default. If you would like to skip files in hidden directories, add `paths-ignore: ["**/.*/**"]` to your [Code Scanning config](https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#specifying-directories-to-scan). If you would like to skip all hidden files, you can use `paths-ignore: ["**/.*"]`. When using the CodeQL CLI for extraction, specify the configuration (creating the configuration file if necessary) using the `--codescanning-config` option.
