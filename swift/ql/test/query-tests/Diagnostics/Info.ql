import swift

string describe(File f) { (f.isSuccessfullyExtracted() and result = "isSuccessfullyExtracted") }

from File f
select f, concat(f.getRelativePath(), ", "), concat(describe(f), ", ")
