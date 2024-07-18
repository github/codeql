import urllib.request
from create_database_utils import *

urllib.request.urlretrieve("https://repo1.maven.org/maven2/org/eclipse/jdt/ecj/3.37.0/ecj-3.37.0.jar", "ecj.jar")

run_codeql_database_create(["java -cp ecj.jar org.eclipse.jdt.internal.compiler.batch.Main Test.java"], lang="java")
