
def unclear():
    # Returns [ "first part of long string and the second part", "/usr/local/usr/bin" ]
    return [

        "first part of long string"
        " and the second part",
        "/usr/local"
        "/usr/bin"
    ]

def clarified():
    # Returns [ "first part of long string and the second part", "/usr/local", "/usr/bin" ]
    return [
        "first part of long string" +
        " and the second part",
        "/usr/local",
        "/usr/bin"
    ]
