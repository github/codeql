def select_os(linux = None, macos = None, windows = None, posix = None, otherwise = []):
    selection = {}
    if posix != None:
        if linux != None or macos != None:
            fail("select_os: cannot specify both posix and linux or macos")
        selection["@platforms//os:linux"] = posix
        selection["@platforms//os:macos"] = posix
    if linux != None:
        selection["@platforms//os:linux"] = linux
    if macos != None:
        selection["@platforms//os:macos"] = macos
    if windows != None:
        selection["@platforms//os:windows"] = windows
    if len(selection) < 3:
        selection["//conditions:default"] = otherwise
    elif otherwise != []:
        fail("select_os: cannot specify all three OSes and an otherwise")
    return select(selection)
