package nested

import "testing"

func TestNestedFunc(t *testing.T) {
	if NestedFunc() != "nested" {
		t.Error("NestedFunc failed")
	}
}
