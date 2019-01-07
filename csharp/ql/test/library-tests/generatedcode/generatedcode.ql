import csharp
import semmle.code.csharp.commons.GeneratedCode

from SourceFile file
where not isGeneratedCode(file)
select file
