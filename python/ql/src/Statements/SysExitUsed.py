import sys

def main():
    try:
        process()
    except Exception as ex:
        print(ex)
        sys.exit(1)
