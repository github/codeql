import semmle.javascript.frameworks.Bundling

from TopLevel tl
where isMultiLicenseBundle(tl)
select tl.getFile()
