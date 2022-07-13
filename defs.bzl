codeql_platform = select({
    "@platforms//os:linux": "linux64",
    "@platforms//os:macos": "osx64",
    "@platforms//os:windows": "win64",
})
