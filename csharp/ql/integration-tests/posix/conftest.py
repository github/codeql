import runs_on


def _supports_mono_nuget():
    """
    Helper function to determine if the current platform supports Mono and nuget.
    
    Returns True on Ubuntu before 26.04 and on macOS x86_64 before macOS 15. Linux other than
    Ubuntu is not selected, as we do not test on it.
    Ubuntu dropped the `mono-complete` package in 26.04, and mono is end-of-life, its own apt
    repository publishing nothing newer than Ubuntu 20.04, so there is nothing to fall back on.
    macOS 15 and later are ARM runners, which have issues with Mono and nuget.
    """
    return runs_on.ubuntu < 2604 or (runs_on.macos < 15 and runs_on.x86_64)
