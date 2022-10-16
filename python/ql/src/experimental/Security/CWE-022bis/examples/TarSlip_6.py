import tarfile
import sys
from contextlib import closing, contextmanager
import subprocess
import os 

@contextmanager
def py2_tarxz(filename):
    import tempfile
    with tempfile.TemporaryFile() as tmp:
        subprocess.check_call(["xz", "-dc", filename], stdout=tmp.fileno())
        tmp.seek(0)
        with closing(tarfile.TarFile(fileobj=tmp)) as tf:
            yield tf

def unpack_tarball(tar_filename, dest):
    # print('Unpacking %s into %s' % (os.path.basename(tar_filename), dest))
    # if sys.version_info[0] < 3 and tar_filename.endswith('.xz'):
    #     # Py 2.7 lacks lzma support
    #     tar_cm = py2_tarxz(tar_filename)
    # else:
    #     
    tar_cm = closing(tarfile.open(tar_filename))

    base_dir = None
    with tar_cm as tar:
        for member in tar:
            base_name = member.name.split('/')[0]
            if base_dir is None:
                base_dir = base_name
            elif base_dir != base_name:
                print('Unexpected path in %s: %s' % (tar_filename, base_name))
        tar.extractall(dest)
    return os.path.join(dest, base_dir)

unpack_tarball(sys.argv[1], "/tmp/unpack")
