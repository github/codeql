import java
import semmle.code.java.frameworks.gwt.GWT

from JSNIComment jsni
select jsni, jsni.getImplementedMethod()
