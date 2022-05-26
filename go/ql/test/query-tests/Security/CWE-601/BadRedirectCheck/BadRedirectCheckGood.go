package main

func sanitizeUrlGood(redir string) string {
	if len(redir) > 1 && redir[0] == '/' && redir[1] != '/' && redir[1] != '\\' {
		return redir
	}
	return "/"
}
