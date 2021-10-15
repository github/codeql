from setuptools import find_packages, setup

# using src/ folder as recommended in: https://blog.ionelmc.ro/2014/05/25/python-packaging/

setup(
    name="cg_trace",
    version="0.0.2",  # Remember to update src/cg_trace/__init__.py
    description="Call graph tracing",
    packages=find_packages("src"),
    package_dir={"": "src"},
    install_requires=["lxml"],
    entry_points={"console_scripts": ["cg-trace = cg_trace.main:main"]},
    python_requires=">=3.7",
)
