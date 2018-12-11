#Code Duplication


#Exact duplication of function

#Code copied from stdlib, copyright PSF.
#See http://www.python.org/download/releases/2.7/license/

def dis(x=None):
    """Disassemble classes, methods, functions, or code.

    With no argument, disassemble the last traceback.

    """
    if x is None:
        distb()
        return
    if isinstance(x, types.InstanceType):
        x = x.__class__
    if hasattr(x, 'im_func'):
        x = x.im_func
    if hasattr(x, 'func_code'):
        x = x.func_code
    if hasattr(x, '__dict__'):
        items = x.__dict__.items()
        items.sort()
        for name, x1 in items:
            if isinstance(x1, _have_code):
                print("Disassembly of %s:" % name)
                try:
                    dis(x1)
                except TypeError(msg):
                    print("Sorry:", msg)
                print()
    elif hasattr(x, 'co_code'):
        disassemble(x)
    elif isinstance(x, str):
        disassemble_string(x)
    else:
        raise TypeError(
              "don't know how to disassemble %s objects" %
              type(x).__name__)


#And duplicate version

def dis2(x=None):
    """Disassemble classes, methods, functions, or code.

    With no argument, disassemble the last traceback.

    """
    if x is None:
        distb()
        return
    if isinstance(x, types.InstanceType):
        x = x.__class__
    if hasattr(x, 'im_func'):
        x = x.im_func
    if hasattr(x, 'func_code'):
        x = x.func_code
    if hasattr(x, '__dict__'):
        items = x.__dict__.items()
        items.sort()
        for name, x1 in items:
            if isinstance(x1, _have_code):
                print("Disassembly of %s:" % name)
                try:
                    dis(x1)
                except TypeError(msg):
                    print("Sorry:", msg)
                print()
    elif hasattr(x, 'co_code'):
        disassemble(x)
    elif isinstance(x, str):
        disassemble_string(x)
    else:
        raise TypeError(
              "don't know how to disassemble %s objects" %
              type(x).__name__)

#Exactly duplicate class

class Popen3:
    """Class representing a child process.  Normally, instances are created
    internally by the functions popen2() and popen3()."""

    sts = -1                    # Child not completed yet

    def __init__(self, cmd, capturestderr=False, bufsize=-1):
        """The parameter 'cmd' is the shell command to execute in a
        sub-process.  On UNIX, 'cmd' may be a sequence, in which case arguments
        will be passed directly to the program without shell intervention (as
        with os.spawnv()).  If 'cmd' is a string it will be passed to the shell
        (as with os.system()).   The 'capturestderr' flag, if true, specifies
        that the object should capture standard error output of the child
        process.  The default is false.  If the 'bufsize' parameter is
        specified, it specifies the size of the I/O buffers to/from the child
        process."""
        _cleanup()
        self.cmd = cmd
        p2cread, p2cwrite = os.pipe()
        c2pread, c2pwrite = os.pipe()
        if capturestderr:
            errout, errin = os.pipe()
        self.pid = os.fork()
        if self.pid == 0:
            # Child
            os.dup2(p2cread, 0)
            os.dup2(c2pwrite, 1)
            if capturestderr:
                os.dup2(errin, 2)
            self._run_child(cmd)
        os.close(p2cread)
        self.tochild = os.fdopen(p2cwrite, 'w', bufsize)
        os.close(c2pwrite)
        self.fromchild = os.fdopen(c2pread, 'r', bufsize)
        if capturestderr:
            os.close(errin)
            self.childerr = os.fdopen(errout, 'r', bufsize)
        else:
            self.childerr = None

    def __del__(self):
        # In case the child hasn't been waited on, check if it's done.
        self.poll(_deadstate=sys.maxint)
        if self.sts < 0:
            if _active is not None:
                # Child is still running, keep us alive until we can wait on it.
                _active.append(self)

    def _run_child(self, cmd):
        if isinstance(cmd, basestring):
            cmd = ['/bin/sh', '-c', cmd]
        os.closerange(3, MAXFD)
        try:
            os.execvp(cmd[0], cmd)
        finally:
            os._exit(1)

    def poll(self, _deadstate=None):
        """Return the exit status of the child process if it has finished,
        or -1 if it hasn't finished yet."""
        if self.sts < 0:
            try:
                pid, sts = os.waitpid(self.pid, os.WNOHANG)
                # pid will be 0 if self.pid hasn't terminated
                if pid == self.pid:
                    self.sts = sts
            except os.error:
                if _deadstate is not None:
                    self.sts = _deadstate
        return self.sts

    def wait(self):
        """Wait for and return the exit status of the child process."""
        if self.sts < 0:
            pid, sts = os.waitpid(self.pid, 0)
            # This used to be a test, but it is believed to be
            # always true, so I changed it to an assertion - mvl
            assert pid == self.pid
            self.sts = sts
        return self.sts


class Popen3Again:
    """Class representing a child process.  Normally, instances are created
    internally by the functions popen2() and popen3()."""

    sts = -1                    # Child not completed yet

    def __init__(self, cmd, capturestderr=False, bufsize=-1):
        """The parameter 'cmd' is the shell command to execute in a
        sub-process.  On UNIX, 'cmd' may be a sequence, in which case arguments
        will be passed directly to the program without shell intervention (as
        with os.spawnv()).  If 'cmd' is a string it will be passed to the shell
        (as with os.system()).   The 'capturestderr' flag, if true, specifies
        that the object should capture standard error output of the child
        process.  The default is false.  If the 'bufsize' parameter is
        specified, it specifies the size of the I/O buffers to/from the child
        process."""
        _cleanup()
        self.cmd = cmd
        p2cread, p2cwrite = os.pipe()
        c2pread, c2pwrite = os.pipe()
        if capturestderr:
            errout, errin = os.pipe()
        self.pid = os.fork()
        if self.pid == 0:
            # Child
            os.dup2(p2cread, 0)
            os.dup2(c2pwrite, 1)
            if capturestderr:
                os.dup2(errin, 2)
            self._run_child(cmd)
        os.close(p2cread)
        self.tochild = os.fdopen(p2cwrite, 'w', bufsize)
        os.close(c2pwrite)
        self.fromchild = os.fdopen(c2pread, 'r', bufsize)
        if capturestderr:
            os.close(errin)
            self.childerr = os.fdopen(errout, 'r', bufsize)
        else:
            self.childerr = None

    def __del__(self):
        # In case the child hasn't been waited on, check if it's done.
        self.poll(_deadstate=sys.maxint)
        if self.sts < 0:
            if _active is not None:
                # Child is still running, keep us alive until we can wait on it.
                _active.append(self)

    def _run_child(self, cmd):
        if isinstance(cmd, basestring):
            cmd = ['/bin/sh', '-c', cmd]
        os.closerange(3, MAXFD)
        try:
            os.execvp(cmd[0], cmd)
        finally:
            os._exit(1)

    def poll(self, _deadstate=None):
        """Return the exit status of the child process if it has finished,
        or -1 if it hasn't finished yet."""
        if self.sts < 0:
            try:
                pid, sts = os.waitpid(self.pid, os.WNOHANG)
                # pid will be 0 if self.pid hasn't terminated
                if pid == self.pid:
                    self.sts = sts
            except os.error:
                if _deadstate is not None:
                    self.sts = _deadstate
        return self.sts

    def wait(self):
        """Wait for and return the exit status of the child process."""
        if self.sts < 0:
            pid, sts = os.waitpid(self.pid, 0)
            # This used to be a test, but it is believed to be
            # always true, so I changed it to an assertion - mvl
            assert pid == self.pid
            self.sts = sts
        return self.sts

#Duplicate function with identifiers changed

def dis3(y=None):
    """frobnicate classes, methods, functions, or code.

    With no argument, frobnicate the last traceback.

    """
    if y is None:
        distb()
        return
    if isinstance(y, types.InstanceType):
        y = y.__class__
    if hasattr(y, 'im_func'):
        y = y.im_func
    if hasattr(y, 'func_code'):
        y = y.func_code
    if hasattr(y, '__dict__'):
        items = y.__dict__.items()
        items.sort()
        for name, y1 in items:
            if isinstance(y1, _have_code):
                print("Disassembly of %s:" % name)
                try:
                    dis(y1)
                except TypeError(msg):
                    print("Sorry:", msg)
                print()
    elif hasattr(y, 'co_code'):
        frobnicate(y)
    elif isinstance(y, str):
        frobnicate_string(y)
    else:
        raise TypeError(
              "don't know how to frobnicate %s objects" %
              type(y).__name__)


#Mostly similar function

def dis4(x=None):
    """Disassemble classes, methods, functions, or code.

    With no argument, disassemble the last traceback.

    """
    if x is None:
        distb()
        return
    if isinstance(x, types.InstanceType):
        x = x.__class__
    if hasattr(x, 'im_func'):
        x = x.im_func
    if hasattr(x, '__dict__'):
        items = x.__dict__.items()
        items.sort()
        for name, x1 in items:
            if isinstance(x1, _have_code):
                print("Disassembly of %s:" % name)
                try:
                    dis(x1)
                except TypeError(msg):
                    print("Sorry:", msg)
                print()
    elif hasattr(x, 'co_code'):
        disassemble(x)
    elif isinstance(x, str):
        disassemble_string(x)
    else:
        raise TypeError(
              "don't know how to disassemble %s objects" %
              type(x).__name__)


#Similar function with changed identifiers

def dis5(z=None):
    """splat classes, methods, functions, or code.

    With no argument, splat the last traceback.

    """
    if z is None:
        distb()
        return
    if isinstance(z, types.InstanceType):
        z = z.__class__
    if hasattr(z, 'im_func'):
        z = z.im_func
    if hasattr(y, 'func_code'):
        y = y.func_code
    if hasattr(z, '__dict__'):
        items = z.__dict__.items()
        items.sort()
        for name, z1 in items:
            if isinstance(z1, _have_code):
                print("Disassembly of %s:" % name)
                try:
                    dis(z1)
                except TypeError(msg):
                    print("Sorry:", msg)
                print()
    elif hasattr(z, 'co_code'):
        splat(z)
    elif isinstance(z, str):
        splat_string(z)
    else:
        raise TypeError(
              "don't know how to splat %s objects" %
              type(z).__name__)


