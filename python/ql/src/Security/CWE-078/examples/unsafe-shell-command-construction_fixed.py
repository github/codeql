import subprocess

def download(path): 
    subprocess.run(["wget", path]) # OK
