package main

import (
	"fmt"
	"html"
	"net/http"
	"regexp"
	"strings"

	"golang.org/x/text/unicode/norm"
)

func main() {}

func bad() {
	http.HandleFunc("/bad_1", func(w http.ResponseWriter, req *http.Request) {
		// BAD: Unicode normalization is applied after escaping.
		unicode_input := req.URL.Query().Get("unicode_input")
		escaped := html.EscapeString(unicode_input)
		unicode_norm := norm.NFKC.String(escaped) // $result=BAD
		fmt.Println(w, "Results: %q", unicode_norm)
	})

	http.HandleFunc("/good_1", func(w http.ResponseWriter, req *http.Request) {
		// GOOD: Unicode normalization is applied before escaping.
		unicode_input := req.URL.Query().Get("unicode_input")
		unicode_norm := norm.NFKC.String(unicode_input) // $result=OK
		unicode_escaped := html.EscapeString(unicode_norm)

		fmt.Println(w, "Results: %q", unicode_escaped)
	})

	http.HandleFunc("/bad_2", func(w http.ResponseWriter, req *http.Request) {

		// BAD: Unicode normalization is performed after checking
		// if any of the unsafe two characters "<＜" is present, there may
		// be more like the tricky "﹤"
		unicode_input := req.URL.Query().Get("unicode_input")
		ind := strings.IndexAny(unicode_input, "<＜")
		if ind == -1 {
			unicode_norm := norm.NFKC.String(unicode_input) // $result=BAD
			fmt.Println(w, "Results: %q", unicode_norm)
		} else {
			fmt.Println(w, "Potential unsafe characters used : %q", unicode_input)
		}

	})

	http.HandleFunc("/bad_3", func(w http.ResponseWriter, req *http.Request) {

		// BAD: Unicode normalization is guarded by the call to `ContainsAny()` which suggests that the
		// input has been validated against the presence of the unsafe characters "<" or their unicode
		// equivalents. This may not the be the case of all the possible Unicode equivalents.
		unicode_input := req.URL.Query().Get("unicode_input")
		if !strings.ContainsAny(unicode_input, "<﹤＜") {
			unicode_norm := norm.NFKC.String(unicode_input) // $result=BAD
			fmt.Println(w, "Results: %q", unicode_norm)
		} else {
			fmt.Println(w, "Contains unsafe characters: %q", unicode_input)
		}

	})

	http.HandleFunc("/bad_4", func(w http.ResponseWriter, req *http.Request) {

		// BAD: Unicode normalization is performed after the regex match validation is performed
		// against the unsafe characters "<" and ">". This may be bypassed using the Unicode characters
		// equivalent to "<" and ">".
		unicode_input := req.URL.Query().Get("unicode_input")
		re := regexp.MustCompile("[<>]")
		if !re.MatchString(unicode_input) {
			unicode_norm := norm.NFKC.String(unicode_input) // $result=BAD
			fmt.Println(w, "Results: %q", unicode_norm)
		} else {
			fmt.Println("The input is not safe.")
		}

	})

	http.HandleFunc("/bad_5", func(w http.ResponseWriter, req *http.Request) {

		// BAD: Unicode normalization is performed after the check whether the unicode_input contains an unsafe characters
		// "<" and ">". This may be bypassed using the Unicode characters equivalent to "<" and ">".
		unicode_input := req.URL.Query().Get("unicode_input")
		if strings.Count("<", unicode_input) > 0 || strings.Count(">", unicode_input) > 0 {
			fmt.Println("The input is not safe.")
		} else {
			unicode_norm := norm.NFKC.String(unicode_input) // $result=BAD
			fmt.Println(w, "Results: %q", unicode_norm)
		}

	})

}
