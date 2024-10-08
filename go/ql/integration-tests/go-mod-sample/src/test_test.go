package makesample

import (
	"testing"
)

func TestTestMe(t *testing.T) {

	// Note because this is a test we do NOT expect this to be extracted.
	publicResult := PublicFunction()
	if publicResult != 1 {
		t.Errorf("Expected 1, got %d", publicResult)
	}

}
