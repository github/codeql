package testsample_test

import (
	"testing"
	"testsample"
)

func TestTestMe(t *testing.T) {

	// Note because this is a test we do NOT expect it to be extracted
	publicResult := testsample.PublicFunction()
	if publicResult != 1 {
		t.Errorf("Expected 1, got %d", publicResult)
	}

}
