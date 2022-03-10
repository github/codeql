import java

// For ExtensionMethodAccess:
// * qualifier is the child with index 0 instead of -1
// * arguments are children starting from index 1 instead of 0
from MethodAccess ma
select ma, ma.getQualifier(), ma.getAnArgument()
