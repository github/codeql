import urllib.request
from create_database_utils import *

urllib.request.urlretrieve("https://repo1.maven.org/maven2/org/eclipse/jdt/ecj/3.38.0/ecj-3.38.0.jar", "ecj.jar")

# This tests the case where ECJ emits a RuntimeIn/VisibleAnnotations attribute that isn't the same size as the corresponding method argument list, in particular due to forgetting to include the synthetic parameters added to explicit enumeration constructors.

run_codeql_database_create(["java -cp ecj.jar org.eclipse.jdt.internal.compiler.batch.Main Test.java -d out -source 8", "java -cp ecj.jar org.eclipse.jdt.internal.compiler.batch.Main Test2.java -cp out -source 8"], lang="java")
