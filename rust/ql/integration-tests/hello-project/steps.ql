import codeql.rust.elements.internal.ExtractorStep

from ExtractorStep step
where not step.getAction() = ["ParseLibrary", "ExtractLibrary"]
select step
