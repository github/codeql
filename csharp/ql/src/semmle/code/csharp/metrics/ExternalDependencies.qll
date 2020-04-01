/**
 * Support for ExternalDependencies.ql query.
 *
 * This performs a "technology inventory" by associating each source file
 * with the assemblies it uses. This creates a metric showing how much each
 * source file uses external assemblies.
 */

import csharp

/**
 * Finds any type use by each source element. Only source declarations
 * are considered, not constructed types and methods.
 */
private Type getATypeUse(Element elt) {
  exists(Variable v | elt = v and v.isSourceDeclaration() and result = v.getType())
  or
  exists(ValueOrRefType t | elt = t and t.isSourceDeclaration() and result = t.getABaseType())
  or
  exists(Property p | elt = p and p.isSourceDeclaration() and result = p.getType())
  or
  exists(Method m | elt = m and m.isSourceDeclaration() and result = m.getReturnType())
  or
  result = elt.(Expr).getType()
  or
  result = elt.(Attribute).getType()
  or
  result = getATypeUse(elt).(ConstructedType).getATypeArgument()
  or
  result = elt.(MethodCall).getTarget().(ConstructedMethod).getATypeArgument()
}

private predicate getElementInFile(File file, Element elt, Assembly assembly) {
  elt.getLocation().getFile() = file and
  assembly = getATypeUse(elt).getLocation()
}

private predicate excludedAssembly(Assembly assembly) {
  assembly.getName() = "mscorlib"
  or
  assembly.getName() = "System"
  or
  assembly.getName() = "System.Core"
  or
  assembly.getName() = "System.Private.CoreLib"
}

/**
 * Generate the table of dependencies for the query.
 */
predicate externalDependencies(File file, string encodedDependency, int num) {
  num =
    strictcount(Element e |
      // Quantify over `assembly` inside the `strictcount`, to avoid multiple entries for
      // assemblies with the same name and version
      exists(Assembly assembly |
        getElementInFile(file, e, assembly) and
        not excludedAssembly(assembly) and
        encodedDependency =
          "/" + file.getRelativePath() + "<|>" + assembly.getName() + "<|>" + assembly.getVersion()
      )
    )
}
