import java

from Method m
where m.getFile().getBaseName() = "Test.java"
select m, m.getSignature()
