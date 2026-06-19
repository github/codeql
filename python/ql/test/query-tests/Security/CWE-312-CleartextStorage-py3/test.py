import pathlib


def get_password():
    return "password"


def write_password(filename):
    password = get_password() # $ Source

    path = pathlib.Path(filename)
    path.write_text(password) # $ Alert # NOT OK
    path.write_bytes(password.encode("utf-8")) # $ Alert # NOT OK

    path.open("w").write(password) # $ Alert # NOT OK
