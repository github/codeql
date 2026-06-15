
# Creates a test file that will cause a RecursionError when run with the Python extractor.
with open('repo_dir/recursion_error.py', 'w') as f:
    f.write("print({})\n".format("+".join(["1"] * 1000)))
