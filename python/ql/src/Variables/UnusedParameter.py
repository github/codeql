import random

def write_to_file(text, filename):
    with open("log.txt", "w") as file:
        file.write(text)
