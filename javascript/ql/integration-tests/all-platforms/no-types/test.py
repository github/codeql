# from create_database_utils import *

# run_codeql_database_create([], lang="javascript", extra_args=["-Oskip_types=true"])
def test(codeql, javascript):
    codeql.database.create(extractor_option="skip_types=true")
