import os

from go_integration_test import *

os.environ['LGTM_INDEX_IMPORT_PATH'] = "deptest"
go_integration_test(source="work")
