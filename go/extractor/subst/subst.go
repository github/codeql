package subst

// ResolvePath resolves subst'd drive letters in a full path.
// If the path starts with a subst'd drive letter, replaces it with the backing path.
// Otherwise returns the path unchanged.
func ResolvePath(path string) string {
	return resolvePath(path, ResolveDrive)
}

func resolvePath(path string, resolveDrive func(string) string) string {
	if len(path) < 3 {
		return path
	}
	if path[1] != ':' {
		return path
	}
	if path[2] != '\\' && path[2] != '/' {
		return path
	}
	c := path[0]
	if !((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {
		return path
	}

	resolved := resolveDrive(path[:3])
	if resolved == "" {
		return path
	}
	return resolved + path[2:]
}
