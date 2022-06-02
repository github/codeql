package main

func sanitizeUrl(redir string) string {
	if len(redir) > 0 && redir[0] == '/' {
		return redir
	}
	return "/"
}
