package util

import "testing"

func TestNewSemVer(t *testing.T) {
	type TestPair struct {
		Input    string
		Expected string
	}

	// Check the special case for the empty string.
	result := NewSemVer("")
	if result != nil {
		t.Errorf("Expected NewSemVer(\"\") to return nil, but got \"%s\".", result)
	}

	testData := []TestPair{
		{"0", "v0.0.0"},
		{"1.0", "v1.0.0"},
		{"1.0.2", "v1.0.2"},
		{"1.20", "v1.20.0"},
		{"1.22.3", "v1.22.3"},
	}

	// Check that we get what we expect for each of the test cases.
	for _, pair := range testData {
		result := NewSemVer(pair.Input)

		if result.String() != pair.Expected {
			t.Errorf("Expected NewSemVer(\"%s\") to return \"%s\", but got \"%s\".", pair.Input, pair.Expected, result)
		}
	}

	// And again, but this time prefixed with "v"
	for _, pair := range testData {
		result := NewSemVer("v" + pair.Input)

		if result.String() != pair.Expected {
			t.Errorf("Expected NewSemVer(\"v%s\") to return \"%s\", but got \"%s\".", pair.Input, pair.Expected, result)
		}
	}

	// And again, but this time prefixed with "go"
	for _, pair := range testData {
		result := NewSemVer("go" + pair.Input)

		if result.String() != pair.Expected {
			t.Errorf("Expected NewSemVer(\"go%s\") to return \"%s\", but got \"%s\".", pair.Input, pair.Expected, result)
		}
	}

	// And again, but this time with an "rc1" suffix.
	for _, pair := range testData {
		result := NewSemVer(pair.Input + "rc1")

		if result.String() != pair.Expected+"-rc1" {
			t.Errorf("Expected NewSemVer(\"%src1\") to return \"%s\", but got \"%s\".", pair.Input, pair.Expected+"-rc1", result)
		}
	}
}
