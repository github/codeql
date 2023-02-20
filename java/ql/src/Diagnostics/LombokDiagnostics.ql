/**
 * @name Lombok diagnostics
 * @description Diagnostic information about Lombok extraction.
 * @kind diagnostic
 * @id java/diagnostics/lombok
 */

import java
import DiagnosticsReporting

private string getLombokCount() {
  exists(int total, int lombok |
    total = count(CompilationUnit f | f.isSourceFile()) and
    lombok = count(File f | lombok_map(_, f, _, _, _, _, _))
  |
    result =
      "Total file count: " + total + ", Lomboked file count: " + lombok + " (" +
        100.0 * lombok / total + "%)"
  )
}

private string lombokStats() {
  exists(int total, int missing |
    total = count(Top e | lombok_map(_, e.getFile(), _, _, _, _, _)) and
    missing =
      count(Top e |
        exists(File delombokedFile |
          lombok_map(_, delombokedFile, _, _, _, _, _) and
          e.getLocation().hasLocationInfo(delombokedFile.getAbsolutePath(), _, _, _, _)
        )
      )
  |
    total != 0 and
    result =
      "Total element count in Lomboked files: " + total + ", missing location mapping: " + missing +
        " (" + 100.0 * missing / total + "%)"
    or
    total = 0 and
    result = "No elements in Lomboked files"
  )
}

private predicate filter(Top e) {
  e instanceof Javadoc or
  e instanceof JavadocElement
}

private string lombokStatsNoJavadoc() {
  exists(int total, int missing |
    total = count(Top e | lombok_map(_, e.getFile(), _, _, _, _, _) and not filter(e)) and
    missing =
      count(Top e |
        exists(File delombokedFile |
          lombok_map(_, delombokedFile, _, _, _, _, _) and
          e.getLocation().hasLocationInfo(delombokedFile.getAbsolutePath(), _, _, _, _)
        ) and
        not filter(e)
      )
  |
    total != 0 and
    result =
      "Total element count in Lomboked files (without Javadoc): " + total +
        ", missing location mapping: " + missing + " (" + 100.0 * missing / total + "%)"
    or
    total = 0 and
    result = "No elements in Lomboked files"
  )
}

from string s
where s = [getLombokCount(), lombokStats(), lombokStatsNoJavadoc()]
select s order by s
