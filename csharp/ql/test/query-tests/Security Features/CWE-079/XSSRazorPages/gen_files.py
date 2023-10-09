# A script for generating code from .cshtml files, mimicking the output of the C# compiler with an option that is not available from the codeql test runner.

import sys
import os

work_dir = os.path.dirname(sys.argv[0])
gen_dir = f"{work_dir}/Generated"
with open(f"{gen_dir}/Template.g") as f:
    template = f.read()


def process_file(path: str):
    """
    Generates the file from the .cshtml file at `path`.
    `path` is a relative filepath from `work_dir`.
    """
    # The location of the .cshtml file is the only relevant part for these tests; its contents are assumed to be the same.
    assert path.endswith(".cshtml")
    path = path.lstrip("/")
    path_under = path.replace("/", "_")[:-len(".cshtml")]

    gen = template.replace("$PATHSLASH", path).replace("$PATHUNDER", path_under)

    with open(f"{gen_dir}/{path_under}.cshtml.g.cs", "w") as f:
        f.write(gen)


def process_dir(path: str):
    """
    Generates all the .cshtml files in the directory `path`.
    `path` is a relative filepath from `work_dir`.
    """
    abs_path = f"{work_dir}/{path}"
    assert os.path.isdir(abs_path)

    for sub in os.listdir(abs_path):
        sub_abs = f"{abs_path}/{sub}"
        sub_rel = f"{path}/{sub}"

        if sub.endswith(".cshtml") and os.path.isfile(sub_abs):
            process_file(sub_rel)
        elif os.path.isdir(sub_abs) and ".testproj" not in sub_abs:
            process_dir(sub_rel)


process_dir("")
