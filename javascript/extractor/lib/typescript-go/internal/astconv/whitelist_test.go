package astconv

import "testing"

func TestAllowedProperties(t *testing.T) {
	allowed := []string{"kind", "$pos", "$end", "statements", "body", "name", "type"}
	for _, p := range allowed {
		if !IsAllowedProperty(p) {
			t.Errorf("expected %q to be allowed", p)
		}
	}

	disallowed := []string{"parent", "symbol", "localSymbol", "nextContainer", "flowNode"}
	for _, p := range disallowed {
		if IsAllowedProperty(p) {
			t.Errorf("expected %q to be disallowed", p)
		}
	}
}

func TestNumericKeys(t *testing.T) {
	for _, k := range []string{"0", "1", "42", "999"} {
		if !IsAllowedProperty(k) {
			t.Errorf("expected numeric key %q to be allowed", k)
		}
	}
}

func TestMetaProperties(t *testing.T) {
	if !IsAllowedProperty("ast") {
		t.Error("expected 'ast' to be allowed (meta property)")
	}
	if !IsAllowedProperty("type") {
		t.Error("expected 'type' to be allowed (meta property)")
	}
}
