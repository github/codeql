import runs_on


def _supports_mono_nuget():
    """
    Helper function to determine if the current platform supports Mono and nuget.
    
    Returns True if running on Linux or on macOS x86_64 (excluding macos-15 and macos-26).
    macOS ARM runners (macos-15 and macos-26) are excluded due to issues with Mono and nuget.
    """
    return (
        runs_on.linux
        or (
            runs_on.macos
            and runs_on.x86_64
            and not runs_on.macos_15
            and not runs_on.macos_26
        )
    )
