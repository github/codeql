package testsample

import (
	"testing"
)

func TestTestMe(t *testing.T) {

	// Note because this is a test we do NOT expect it to be extracted
	publicResult := PublicFunction()
	if publicResult != 1 {
		t.Errorf("Expected 1, got %d", publicResult)
	}

	privateResult := privateFunction()
	if privateResult != 2 {
		t.Errorf("Expected 2, got %d", privateResult)
	}

}
