import java

from CompilationUnit cu
where cu.fromSource() or cu.toString().contains("List")
select cu.toString(), cu.getLocation().toString().regexpReplaceAll(".*/", ".../")
