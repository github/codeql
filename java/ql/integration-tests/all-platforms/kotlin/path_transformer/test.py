from create_database_utils import *

path_transformer_file = 'path_transformer'
root = os.getcwd().replace('\\', '/')
with open(path_transformer_file, 'w') as f:
    f.write('#/src\n' + root + '//\n')
os.environ['SEMMLE_PATH_TRANSFORMER'] = root + '/' + path_transformer_file

run_codeql_database_create(["kotlinc kotlin_source.kt"], lang="java")
files = ['test-db/trap/java/src/kotlin_source.kt.trap.gz', 'test-db/src/src/kotlin_source.kt']
exists = list(map(os.path.exists, files))
if exists != [True] * 2:
    print(exists)
    raise Exception("Didn't get expected filed")
