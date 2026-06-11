package main

func sanitizeUrl(redir string) string { // $ Source
	if len(redir) > 0 && redir[0] == '/' { // $ Alert
		return redir
	}
	return "/"
}
