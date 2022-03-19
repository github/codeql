import secrets


def generatePassword():
    # GOOD: the random is cryptographically secure
    secret_generator = secrets.SystemRandom()
    return secret_generator.random()
