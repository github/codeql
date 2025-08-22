class Element extends @element {
  string toString() { none() }
}

int getImportedModuleIndex(Element m, Element i) {
  i =
    rank[result + 1](Element j, string name |
      module_decl_imported_modules(m, j) and type_decls(j, name)
    |
      j order by name
    )
}

from Element m, Element i
select m, getImportedModuleIndex(m, i), i
