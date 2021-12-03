
def test():
    single_string = [
        "foo"
        "bar"
        "/usr/local"
        "/usr/bin"
    ]
    explict_concat = [
        "foo" +
        "bar",
        "/usr/local",
        "/usr/bin"
    ]
    error1 = [
        "foo",
        "/usr/local"
        "/usr/bin"
    ]
    error2 = [
        "foo" +
        "bar",
        "/usr/local"
        "/usr/bin"
    ]

#Examples from documentation

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
