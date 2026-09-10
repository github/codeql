/**
 * @name Files covered by module manifest
 * @description Files that are included from a module manifest
 * @kind problem
 * @problem.severity recommendation
 * @id unified/diagnostic/files-covered-by-module-manifest
 * @tags meta
 * @precision very-low
 */

import unified
import codeql.unified.internal.StaticNameBinding
import codeql.unified.internal.NameBindingPlugin
import codeql.unified.internal.AnalysisQuality

from FilesCoveredByModuleManifestStats::Candidate c, ModuleScopeRepr mod
where c.isOk() and mod = c.getAModule()
select c, "File included in $@.", mod, mod.toString()
