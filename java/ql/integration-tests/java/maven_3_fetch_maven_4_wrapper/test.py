import os
import tarfile
import tempfile
import pathlib
from fixtures.util import download_file_cached

def test_maven3_fetch_maven4_wrapper(codeql, java, use_java_17, cache):
    maven_url = "https://archive.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz"
    maven_archive = download_file_cached(maven_url, "apache-maven-3.6.0-bin.tar.gz", cache)

    temp_dir = pathlib.Path(tempfile.mkdtemp())
    with tarfile.open(maven_archive, "r:gz") as tar:
        tar.extractall(temp_dir, filter='data')

    # Set maven_home_path to the extracted directory
    maven_home_path = temp_dir / "apache-maven-3.6.0"

    codeql.database.create(source_root="app",
                           build_mode="autobuild",
                           _env={"MAVEN_USER_HOME": str(maven_home_path)})