---
category: minorAnalysis
---
* The JavaScript extractor now skips generated JavaScript files if the original TypeScript files are already present. It also skips any files in the output directory specified in the `compilerOptions` part of the `tsconfig.json` file.
