lgtm,codescanning
* The extractor now attempts to extract the AST of all dependencies that are related to the packages passed explicitly on the commandline, which is determined by using the module root or, if not using modules, the directory containing the source for those packages.
