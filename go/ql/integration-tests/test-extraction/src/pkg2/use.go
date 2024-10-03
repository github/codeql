package pkg2

import (
	"testsample/pkg1"
)

// This tests the case of cross-package generic type references
// in the presence of test extraction. We need to make sure we
// extract packages, including test variants, in the right order
// such that we've seen pkg1.Generic before we try to use it here.

type Specialised = pkg1.Generic[string]
