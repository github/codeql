# Sitemap (Go)

[![build status](https://img.shields.io/github/workflow/status/kataras/sitemap/CI/master?style=for-the-badge)](https://github.com/kataras/sitemap/actions) [![report card](https://img.shields.io/badge/report%20card-a%2B-ff3333.svg?style=for-the-badge)](https://goreportcard.com/report/github.com/kataras/sitemap) [![godocs](https://img.shields.io/badge/go-%20docs-488AC7.svg?style=for-the-badge)](https://pkg.go.dev/github.com/kataras/sitemap)

[Sitemap Protocol](https://www.sitemaps.org/protocol.html) implementation for Go. Automatically handles [Sitemap index files](https://www.sitemaps.org/protocol.html#index) `"/sitemap.xml"`.

## Getting started

The only requirement is the [Go Programming Language](https://golang.org/dl).

```sh
$ go get github.com/kataras/sitemap
```

```go
import "github.com/kataras/sitemap"
```

```go
sitemaps := sitemap.New("http://localhost:8080").
    URL(sitemap.URL{Loc: "/home"}).
    URL(sitemap.URL{Loc: "/articles", LastMod: time.Now(), ChangeFreq: sitemap.Daily, Priority: 1}).
    Build()
```

```go
import "net/http"
```

```go
for _, s := range sitemaps {
    http.Handle(s.Path, s)
}

http.ListenAndServe(":8080", nil)
```

Visit http://localhost:8080/sitemap.xml

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc>http://localhost:8080/home</loc>
    </url>
    <url>
        <loc>http://localhost:8080/articles</loc>
        <lastmod>2019-12-05T08:17:35+02:00</lastmod>
        <changefreq>daily</changefreq>
        <priority>1</priority>
    </url>
</urlset>
```

For a more detailed technical documentation you can head over to our [godocs](https://godoc.org/github.com/kataras/sitemap). And for executable code you can always visit the [_examples](_examples) repository's subdirectory.

## License

kataras/sitemap is free and open-source software licensed under the [MIT License](https://tldrlegal.com/license/mit-license).
