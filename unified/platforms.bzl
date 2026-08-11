"""Shared platform constraint for the unified extractor."""

# swift-syntax requires a Swift toolchain, which is only available
# through rules_swift.
UNIFIED_SUPPORTED_PLATFORMS = select({
    "@platforms//os:linux": [],
    "@platforms//os:macos": [],
    "//conditions:default": ["@platforms//:incompatible"],
})
