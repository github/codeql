package testsample

import (
	"testing"
)

func TestTestMe(t *testing.T) {

	publicResult := PublicFunction()
	if publicResult != 1 {
		t.Errorf("Expected 1, got %d", publicResult)
	}

	privateResult := privateFunction()
	if privateResult != 2 {
		t.Errorf("Expected 2, got %d", privateResult)
	}

}
