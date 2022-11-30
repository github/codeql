import java
import semmle.code.java.frameworks.gwt.GWT

from JsniComment jsni
select jsni, jsni.getImplementedMethod()
