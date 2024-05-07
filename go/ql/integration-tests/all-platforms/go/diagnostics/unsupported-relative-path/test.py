import os

from go_integration_test import *

os.environ['GITHUB_REPOSITORY'] = "a/b"
go_integration_test(source="work", db=None)
