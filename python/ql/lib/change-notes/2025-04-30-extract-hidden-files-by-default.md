---
category: minorAnalysis
---

- The Python extractor now extracts files in hidden directories by default. If you would like to skip hidden files, add `paths-ignore: ["**/.*/**"]` to your [Code Scanning config](https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#specifying-directories-to-scan). When using the CodeQL CLI for extraction, specify the configuration (creating the configuration file if necessary) using the `--codescanning-config` option.
