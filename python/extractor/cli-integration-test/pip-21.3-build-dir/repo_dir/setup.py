from setuptools import find_packages, setup

# using src/ folder as recommended in: https://blog.ionelmc.ro/2014/05/25/python-packaging/

setup(
    name="example_pkg",
    version="0.0.1",
    description="example",
    packages=find_packages("src"),
    package_dir={"": "src"},
    install_requires=[],
)
