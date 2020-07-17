from setuptools import find_packages, setup

from cg_trace import MIN_PYTHON_VERSION_FORMATTED, __version__

# TODO: There was some benefit of structuring your code as `src/yourpackage/code.py`
# instead of `yourpackage/code.py` concerning imports, but I don't recall the details

setup(
    name="cg_trace",
    version=__version__,
    description="Call graph tracing",
    packages=find_packages(),
    install_requires=["lxml"],
    entry_points={"console_scripts": ["cg-trace = cg_trace.main:main"]},
    python_requires=">={}".format(MIN_PYTHON_VERSION_FORMATTED),
)
