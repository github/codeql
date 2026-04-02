import cpp

from Location l
where
  not any(Element e).getLocation() = l and
  not any(LambdaCapture lc).getLocation() = l and
  not any(MacroAccess ma).getActualLocation() = l and
  not any(NamespaceDeclarationEntry nde).getBodyLocation() = l and
  not any(XmlLocatable xml).getLocation() = l
select l
