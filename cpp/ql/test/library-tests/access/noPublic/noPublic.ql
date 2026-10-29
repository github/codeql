import cpp

from AccessSpecifier spec
// There is no way to create "protected" access without writing the keyword
// `protected` in the source, so we don't need to test for that.
where spec.hasName(["private", "public"])
select spec
