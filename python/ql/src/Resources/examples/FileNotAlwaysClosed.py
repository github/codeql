def bad():
    f = open("filename", "w")
    f.write("could raise exception") # BAD: This call could raise an exception, leading to the file not being closed.
    f.close()


def good1():
    with open("filename", "w") as f:
        f.write("always closed") # GOOD: The `with` statement ensures the file is always closed.

def good2():
    f = open("filename", "w")
    try:
       f.write("always closed")
    finally:
        f.close() # GOOD: The `finally` block always ensures the file is closed.
   
