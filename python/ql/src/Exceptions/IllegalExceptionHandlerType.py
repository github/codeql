def handle_int():
    try:
        raise_int()
    #This will not cause an exception, but it will be ignored
    except int:
        print("This will never be printed")

