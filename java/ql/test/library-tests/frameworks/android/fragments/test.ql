import java
import semmle.code.java.frameworks.android.Fragment

from AndroidFragment f
where f.getFile().getBaseName() = "TestFragment.java"
select f
