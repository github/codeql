import java

from CompilationUnit cu
where cu.fromSource() or cu.toString().matches("%List%")
select cu.toString(), cu.getLocation().toString().regexpReplaceAll(".*/", ".../")
