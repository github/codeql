import os
import sys


def pip_installed_folder():
    try:
        import pip
    except ImportError:
        print("ERROR: 'pip' not installed.")
        sys.exit(2)
    dirname, filename = os.path.split(pip.__file__)
    if filename.startswith("__init__."):
        dirname = os.path.dirname(dirname)
    return dirname

def first_site_packages():
    dist_packages = None
    for path in sys.path:
        if "site-packages" in path:
            return path
        if "dist-packages" in path and not dist_packages:
            dist_packages = path
    if dist_packages:
        return dist_packages
    # No site-packages or dist-packages?
    raise Exception

def get_venv_lib():
    try:
        return pip_installed_folder()
    except:
        return first_site_packages()

if __name__=='__main__':
    print(get_venv_lib())
