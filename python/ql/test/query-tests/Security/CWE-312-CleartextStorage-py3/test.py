import pathlib


def get_password():
    return "password"


def write_password(filename):
    password = get_password()

    path = pathlib.Path(filename)
    path.write_text(password) # NOT OK
    path.write_bytes(password.encode("utf-8")) # NOT OK

    path.open("w").write(password) # NOT OK
