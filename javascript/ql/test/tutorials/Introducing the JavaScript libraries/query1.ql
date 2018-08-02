import javascript

from Folder d
select d.getRelativePath(), count(File f | f = d.getAFile() and f.getExtension() = "js")
