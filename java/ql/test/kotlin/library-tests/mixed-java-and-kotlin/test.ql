import java

from File f
where f.getExtension() in ["java", "kt"]
select f

// This test is mainly a consistency test; just checking that both the Java and Kotlin source were extracted here
