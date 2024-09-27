package testsample_test

import (
	"testing"
	"testsample"
)

func TestTestMe(t *testing.T) {

	publicResult := testsample.PublicFunction()
	if publicResult != 1 {
		t.Errorf("Expected 1, got %d", publicResult)
	}

}
