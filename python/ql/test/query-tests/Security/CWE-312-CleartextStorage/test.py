def get_cert():
    return "<CERT>"

def get_password():
    return "password"

def write_cert(filename):
    cert = get_cert()
    with open(filename, "w") as file:
        file.write(cert) # OK
        lines = [cert + "\n"]
        file.writelines(lines) # OK

def write_password(filename):
    password = get_password()
    with open(filename, "w") as file:
        file.write(password) # NOT OK
        lines = [password + "\n"]
        file.writelines(lines) # NOT OK

def FPs():
    # just like for cleartext-logging see that file for more elaborate tests
    #
    # this part is just to make sure the two queries are in line with what is considered
    # sensitive information.

    with open(filename, "w") as file:
        # Harmless UUIDs
        x = generate_uuid4()
        file.write(x) # OK
