import swift

string describe(File f) { (f.isSuccessfullyExtracted() and result = "isSuccessfullyExtracted") }

from File f
where exists(f.getRelativePath()) or f instanceof UnknownFile
select f, concat(f.getRelativePath(), ", "), concat(describe(f), ", ")
