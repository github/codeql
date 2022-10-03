import java

from JavadocTag javadocTag, string text
where if exists(javadocTag.getText()) then text = javadocTag.getText() else text = "<none>"
select javadocTag, javadocTag.getJavadoc(), javadocTag.getParent(), javadocTag.getTagName(), text
