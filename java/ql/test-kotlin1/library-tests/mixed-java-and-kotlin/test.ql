import java

from File f
where f.isSourceFile()
select f
// This test is mainly a consistency test; just checking that both the Java and Kotlin source were extracted here
