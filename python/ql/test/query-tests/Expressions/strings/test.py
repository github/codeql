
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
        "/usr/bin" # $ Alert
    ]
    error2 = [
        "foo" +
        "bar",
        "/usr/local"
        "/usr/bin" # $ Alert
    ]

#Examples from documentation

def unclear():
    # Returns [ "first part of long string and the second part", "/usr/local/usr/bin" ]
    return [

        "first part of long string"
        " and the second part", # $ Alert
        "/usr/local"
        "/usr/bin" # $ Alert
    ]

def clarified():
    # Returns [ "first part of long string and the second part", "/usr/local", "/usr/bin" ]
    return [
        "first part of long string" +
        " and the second part",
        "/usr/local",
        "/usr/bin"
    ]
