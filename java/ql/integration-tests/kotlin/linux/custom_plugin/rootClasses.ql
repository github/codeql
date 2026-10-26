import java

from ClassOrInterface ci
where not exists(ci.getASupertype())
select ci.getPackage(), ci.toString()
