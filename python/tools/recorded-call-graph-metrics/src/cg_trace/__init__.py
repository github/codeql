import sys

__version__ = "0.0.2"  # remember to update setup.py

# Since the virtual machine opcodes changed in 3.6, not going to attempt to support
# anything before that. Using dataclasses, which is a new feature in Python 3.7
MIN_PYTHON_VERSION = (3, 7)
MIN_PYTHON_VERSION_FORMATTED = ".".join(str(i) for i in MIN_PYTHON_VERSION)

if not sys.version_info[:2] >= MIN_PYTHON_VERSION:
    sys.exit(
        "You need at least Python {} to use 'cg_trace'".format(
            MIN_PYTHON_VERSION_FORMATTED
        )
    )
