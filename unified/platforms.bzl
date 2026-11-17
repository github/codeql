"""Shared platform constraint for the unified extractor."""

# Extractor packs currently support Linux and macOS.
UNIFIED_SUPPORTED_PLATFORMS = select({
    "@platforms//os:linux": [],
    "@platforms//os:macos": [],
    "//conditions:default": ["@platforms//:incompatible"],
})
