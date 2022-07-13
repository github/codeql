import java

from ClassOrInterface ci, Member m
where m = ci.getAMember() and ci.getSourceDeclaration().fromSource()
select ci, m
