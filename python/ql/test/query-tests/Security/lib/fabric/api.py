# For the 1.x version

def needs_host(func):
    @wraps(func)
    def inner(*args, **kwargs):
        return func(*args, **kwargs)
    return inner


def local(command, capture=False, shell=None):
    pass


@needs_host
def run(command, shell=True, pty=True, combine_stderr=None, quiet=False,
    warn_only=False, stdout=None, stderr=None, timeout=None, shell_escape=None,
    capture_buffer_size=None):
    pass


@needs_host
def sudo(command, shell=True, pty=True, combine_stderr=None, user=None,
    quiet=False, warn_only=False, stdout=None, stderr=None, group=None,
    timeout=None, shell_escape=None, capture_buffer_size=None):
    pass

# https://github.com/fabric/fabric/blob/1.14/fabric/tasks.py#L281
def execute(task, *args, **kwargs):
    pass
