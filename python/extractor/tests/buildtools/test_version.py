import os
import re
from textwrap import dedent
import itertools

import pytest

import buildtools.version as version
from tests.buildtools.helper import in_fresh_temp_dir


class TestTravisVersion:

    # based on https://docs.travis-ci.com/user/customizing-the-build/#build-matrix
    # and https://docs.travis-ci.com/user/languages/python/

    def test_simple(self):
        with in_fresh_temp_dir():
            assert version.travis_version('.') is None


    @pytest.mark.parametrize(
        'name,expected,travis_file',[
        ('empty', None, ''),
        ('no_python', None, dedent("""\
        language: ruby
        rvm:
        - 2.5
        - 2.6
        """)),

        ('both', None, dedent("""\
        language: python
        python:
        - "2.6"
        - "2.7"
        - "3.5"
        - "3.6"
        """)),

        ('only_py2', 2, dedent("""\
        language: python
        python:
        - "2.6"
        - "2.7"
        """)),

        ('only_py3', 3, dedent("""\
        language: python
        python:
        - "3.5"
        - "3.6"
        """)),

        ('jobs_both', None, dedent("""\
        language: python
        jobs:
            include:
                - python: 2.6
                - python: 2.7
                - python: 3.5
                - python: 3.6
        """)),

        ('jobs_only_py2', 2, dedent("""\
        language: python
        jobs:
            include:
                - python: 2.6
                - python: 2.7
        """)),

        ('jobs_only_py3', 3, dedent("""\
        language: python
        jobs:
            include:
                - python: 3.5
                - python: 3.6
        """)),

        ('top_level_and_jobs', None, dedent("""\
        language: python
        python:
        - "2.6"
        - "2.7"
        jobs:
            include:
                - python: 3.5
                - python: 3.6
        """)),

        ('jobs_unrelated', 2, dedent("""\
        language: python
        python:
        - "2.6"
        - "2.7"
        jobs:
            include:
                - env: FOO=FOO
                - env: FOO=BAR
        """)),

        ('jobs_no_python', None, dedent("""\
        language: ruby
        jobs:
            include:
                - rvm: 2.5
                - rvm: 2.6
        """)),

        # matrix is the old name for jobs (still supported as of 2019-11)
        ('matrix_only_py3', 3, dedent("""\
        language: python
        matrix:
            include:
                - python: 3.5
                - python: 3.6
        """)),

        ('quoted_py2', 2, dedent("""\
        language: python
        python:
        - "2.7"
        """)),

        ('unquoted_py2', 2, dedent("""\
        language: python
        python:
        - 2.7
        """)),
    ])
    def test_with_file(self, name, expected, travis_file):
        with in_fresh_temp_dir():
            with open('.travis.yml', 'w') as f:
                f.write(travis_file)
            assert version.travis_version('.') is expected, name

    def test_filesnames(self):
        """Should prefer .travis.yml over travis.yml (which we still support for some legacy reason)
        """
        with in_fresh_temp_dir():
            with open('travis.yml', 'w') as f:
                f.write(dedent("""\
                    language: python
                    python:
                    - "2.6"
                    - "2.7"
                    """))
            assert version.travis_version('.') is 2

            with open('.travis.yml', 'w') as f:
                f.write(dedent("""\
                    language: python
                    python:
                    - "3.5"
                    - "3.6"
                    """))
            assert version.travis_version('.') is 3
class TestTroveVersion:

    def test_empty(self):
        with in_fresh_temp_dir():
            assert version.trove_version('.') is None

    def test_with_file(self):
        def _to_file(classifiers):
            with open('setup.py', 'wt') as f:
                f.write(dedent("""\
                setup(
                    classifiers={!r}
                )
                """.format(classifiers)
                ))

        cases = [
            (2, "Programming Language :: Python :: 2.7"),
            (2, "Programming Language :: Python :: 2"),
            (2, "Programming Language :: Python :: 2 :: Only"),
            (3, "Programming Language :: Python :: 3.7"),
            (3, "Programming Language :: Python :: 3"),
            (3, "Programming Language :: Python :: 3 :: Only"),
        ]

        for expected, classifier in cases:
            with in_fresh_temp_dir():
                _to_file([classifier])
                assert version.trove_version('.') == expected

        for combination in itertools.combinations(cases, 2):
            with in_fresh_temp_dir():
                versions, classifiers = zip(*combination)
                _to_file(classifiers)
                expected = 3 if 3 in versions else 2
                assert version.trove_version('.') == expected

    @pytest.mark.xfail()
    def test_tricked_regex_is_too_simple(self):
        with in_fresh_temp_dir():
            with open('setup.py', 'wt') as f:
                f.write(dedent("""\
                setup(
                    name='Programming Language :: Python :: 2',
                    classifiers=[],
                )
                """
                ))
            assert version.trove_version('.') is None

    @pytest.mark.xfail()
    def test_tricked_regex_is_too_simple2(self):
        with in_fresh_temp_dir():
            with open('setup.py', 'wt') as f:
                f.write(dedent("""\
                setup(
                    # classifiers=['Programming Language :: Python :: 2'],
                )
                """
                ))
            assert version.trove_version('.') is None

    @pytest.mark.xfail()
    def test_tricked_not_running_as_code(self):
        with in_fresh_temp_dir():
            with open('setup.py', 'wt') as f:
                f.write(dedent("""\
                c = 'Programming Language :: ' + 'Python :: 2'
                setup(
                    classifiers=[c],
                )
                """
                ))
            assert version.trove_version('.') is 2

    def test_constructing_other_place(self):
        with in_fresh_temp_dir():
            with open('setup.py', 'wt') as f:
                f.write(dedent("""\
                c = 'Programming Language :: Python :: 2'
                setup(
                    classifiers=[c],
                )
                """
                ))
            assert version.trove_version('.') is 2
