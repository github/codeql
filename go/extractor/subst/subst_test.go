package subst

import "testing"

func TestResolvePath(t *testing.T) {
	t.Parallel()

	tests := []struct {
		name        string
		path        string
		resolveRoot string
		resolved    string
		expected    string
	}{
		{
			name:        "resolved backslash path",
			path:        `X:\dir\file.go`,
			resolveRoot: `X:\`,
			resolved:    `C:\target`,
			expected:    `C:\target\dir\file.go`,
		},
		{
			name:        "resolved slash path",
			path:        `X:/dir/file.go`,
			resolveRoot: `X:/`,
			resolved:    `C:\target`,
			expected:    `C:\target/dir/file.go`,
		},
		{
			name:        "lowercase drive letter",
			path:        `x:\dir\file.go`,
			resolveRoot: `x:\`,
			resolved:    `C:\target`,
			expected:    `C:\target\dir\file.go`,
		},
		{
			name:     "unresolved drive",
			path:     `X:\dir\file.go`,
			resolveRoot: `X:\`,
			expected: `X:\dir\file.go`,
		},
		{
			name:     "relative path",
			path:     `dir\file.go`,
			expected: `dir\file.go`,
		},
		{
			name:     "non drive prefix",
			path:     `\\server\share\file.go`,
			expected: `\\server\share\file.go`,
		},
		{
			name:     "missing separator after colon",
			path:     `X:file.go`,
			expected: `X:file.go`,
		},
	}

	for _, test := range tests {
		test := test
		t.Run(test.name, func(t *testing.T) {
			t.Parallel()

			resolveCalls := 0
			actual := resolvePath(test.path, func(driveRoot string) string {
				resolveCalls++
				if driveRoot != test.resolveRoot {
					t.Fatalf("resolvePath passed drive root %q, want %q", driveRoot, test.resolveRoot)
				}
				return test.resolved
			})

			if actual != test.expected {
				t.Fatalf("resolvePath(%q) = %q, want %q", test.path, actual, test.expected)
			}

			wantCalls := 0
			if test.resolveRoot != "" {
				wantCalls = 1
			}
			if resolveCalls != wantCalls {
				t.Fatalf("resolvePath(%q) made %d resolve calls, want %d", test.path, resolveCalls, wantCalls)
			}
		})
	}
}
