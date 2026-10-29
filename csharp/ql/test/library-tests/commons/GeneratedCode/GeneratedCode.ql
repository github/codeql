import semmle.code.csharp.commons.GeneratedCode

from File f
where isGeneratedCode(f)
select f
