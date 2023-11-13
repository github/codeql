goreferrer
==========

A Go module that analyzes and classifies different kinds of referrer URLs (search, social, ...).

## Example

```go
package main

import (
	"fmt"

	"github.com/Shopify/goreferrer"
)

var urls = []string{
	"http://ca.search.yahoo.com/search?p=hello",
	"https://twitter.com/jdoe/status/391149968360103936",
	"http://yoursite.com/links",
}

func main() {
	for _, url := range urls {
		r := goreferrer.DefaultRules.Parse(url)
		switch r.Type {
		case goreferrer.Search:
			fmt.Printf("Search %s: %s\n", r.Label, r.Query)
		case goreferrer.Social:
			fmt.Printf("Social %s\n", r.Label)
		case goreferrer.Indirect:
			fmt.Printf("Indirect: %s\n", r.URL)
		}
	}
}
```
Result:
```
Search Yahoo: hello
Social Twitter
Indirect: http://yoursite.com/links
```
