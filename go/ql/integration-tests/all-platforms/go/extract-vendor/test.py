from go_integration_test import *

os.environ['CODEQL_EXTRACTOR_GO_EXTRACT_VENDOR_DIRS'] = "true"
go_integration_test()
