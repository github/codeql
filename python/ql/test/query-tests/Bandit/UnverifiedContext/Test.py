import ssl

# Correct
context = ssl.create_default_context()

# Incorrect: unverified context
context = ssl._create_unverified_context()
