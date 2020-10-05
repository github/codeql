# Failure to use HTTPS or SFTP URL in Maven artifact upload/download

```
ID: java/maven/non-https-url
Kind: problem
Severity: error
Precision: very-high
Tags: security external/cwe/cwe-300 external/cwe/cwe-319 external/cwe/cwe-494 external/cwe/cwe-829

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-829/InsecureDependencyResolution.ql)

Using an insecure protocol like HTTP or FTP to download your dependencies leaves your Maven build vulnerable to a [Man in the Middle (MITM)](https://en.wikipedia.org/wiki/Man-in-the-middle_attack). This can allow attackers to inject malicious code into the artifacts that you are resolving and infect build artifacts that are being produced. This can be used by attackers to perform a [Supply chain attack](https://en.wikipedia.org/wiki/Supply_chain_attack) against your project's users.

This vulnerability has a [ CVSS v3.1 base score of 8.1/10 ](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator?vector=AV:N/AC:H/PR:N/UI:N/S:U/C:H/I:H/A:H&version=3.1).


## Recommendation
Always use HTTPS or SFTP to download artifacts from artifact servers.


## Example
These examples show examples of locations in Maven POM files where artifact repository upload/download is configured. The first shows the use of HTTP, the second shows the use of HTTPS.


```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.semmle</groupId>
    <artifactId>parent</artifactId>
    <version>1.0</version>
    <packaging>pom</packaging>

    <name>Security Testing</name>
    <description>An example of insecure download and upload of dependencies</description>

    <distributionManagement>
        <repository>
            <id>insecure-releases</id>
            <name>Insecure Repository Releases</name>
            <!-- BAD! Use HTTPS -->
            <url>http://insecure-repository.example</url>
        </repository>
        <snapshotRepository>
            <id>insecure-snapshots</id>
            <name>Insecure Repository Snapshots</name>
            <!-- BAD! Use HTTPS -->
            <url>http://insecure-repository.example</url>
        </snapshotRepository>
    </distributionManagement>
    <repositories>
        <repository>
            <id>insecure</id>
            <name>Insecure Repository</name>
            <!-- BAD! Use HTTPS -->
            <url>http://insecure-repository.example</url>
        </repository>
    </repositories>
    <pluginRepositories>
        <pluginRepository>
            <id>insecure-plugins</id>
            <name>Insecure Repository Releases</name>
            <!-- BAD! Use HTTPS -->
            <url>http://insecure-repository.example</url>
        </pluginRepository>
    </pluginRepositories>
</project>

```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.semmle</groupId>
    <artifactId>parent</artifactId>
    <version>1.0</version>
    <packaging>pom</packaging>

    <name>Security Testing</name>
    <description>An example of secure download and upload of dependencies</description>

    <distributionManagement>
        <repository>
            <id>insecure-releases</id>
            <name>Secure Repository Releases</name>
            <!-- GOOD! Use HTTPS -->
            <url>https://insecure-repository.example</url>
        </repository>
        <snapshotRepository>
            <id>insecure-snapshots</id>
            <name>Secure Repository Snapshots</name>
            <!-- GOOD! Use HTTPS -->
            <url>https://insecure-repository.example</url>
        </snapshotRepository>
    </distributionManagement>
    <repositories>
        <repository>
            <id>insecure</id>
            <name>Secure Repository</name>
            <!-- GOOD! Use HTTPS -->
            <url>https://insecure-repository.example</url>
        </repository>
    </repositories>
    <pluginRepositories>
        <pluginRepository>
            <id>insecure-plugins</id>
            <name>Secure Repository Releases</name>
            <!-- GOOD! Use HTTPS -->
            <url>https://insecure-repository.example</url>
        </pluginRepository>
    </pluginRepositories>
</project>

```

## References
* Research: [ Want to take over the Java ecosystem? All you need is a MITM! ](https://medium.com/bugbountywriteup/want-to-take-over-the-java-ecosystem-all-you-need-is-a-mitm-1fc329d898fb?source=friends_link&sk=3c99970c55a899ad9ef41f126efcde0e)
* Research: [ How to take over the computer of any Java (or Closure or Scala) Developer. ](https://max.computer/blog/how-to-take-over-the-computer-of-any-java-or-clojure-or-scala-developer/)
* Proof of Concept: [ mveytsman/dilettante ](https://github.com/mveytsman/dilettante)
* Additional Gradle & Maven plugin: [ Announcing nohttp ](https://spring.io/blog/2019/06/10/announcing-nohttp)
* Java Ecosystem Announcement: [ HTTP Decommission Artifact Server Announcements ](https://gist.github.com/JLLeitschuh/789e49e3d34092a005031a0a1880af99)
* Common Weakness Enumeration: [CWE-300](https://cwe.mitre.org/data/definitions/300.html).
* Common Weakness Enumeration: [CWE-319](https://cwe.mitre.org/data/definitions/319.html).
* Common Weakness Enumeration: [CWE-494](https://cwe.mitre.org/data/definitions/494.html).
* Common Weakness Enumeration: [CWE-829](https://cwe.mitre.org/data/definitions/829.html).