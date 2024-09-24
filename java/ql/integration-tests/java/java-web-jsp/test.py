def test(codeql, java):
    codeql.database.create(
        command="mvn clean package -P tomcat8Jsp", _env={"CODEQL_EXTRACTOR_JAVA_JSP": "true"}
    )
