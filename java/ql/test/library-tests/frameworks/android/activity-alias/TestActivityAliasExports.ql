import java
import semmle.code.java.frameworks.android.Android

from ExportableAndroidComponent component
where component.isExported()
select component, component.getAndroidComponentXmlElement()
