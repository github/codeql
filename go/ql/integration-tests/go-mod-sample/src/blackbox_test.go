package makesample_test

import (
	"makesample"
	"testing"
)

// Note because this is a test we do NOT expect this to be extracted.
func TestTestMe(t *testing.T) {

	publicResult := makesample.PublicFunction()
	if publicResult != 1 {
		t.Errorf("Expected 1, got %d", publicResult)
	}

}
