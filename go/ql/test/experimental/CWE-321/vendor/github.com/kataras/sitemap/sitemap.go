// Package sitemap implements the Sitemap Protocol.
// Reference: https://www.sitemaps.org/protocol.html
package sitemap

import (
	"encoding/xml"
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"
)

// MaxURLsPerSitemap is the limit of each sitemap, if more than number of urls are registered
// then sitemaps are automatically splitted and a sitemap index will be used.
// Defaults to 50000 as Sitemap Protocol specifies.
var MaxURLsPerSitemap = 50000

// URL.ChangeFreq valid values.
const (
	Always  = "always"
	Hourly  = "hourly"
	Daily   = "daily"
	Weekly  = "weekly"
	Monthly = "monthly"
	Yearly  = "yearly"
	Never   = "never"
)

// URL is the parent tag for each URL entry.
type URL struct {
	// Loc is required. It defines the URL of the page.
	// This URL must begin with the protocol (such as http) and end with a trailing slash,
	// if your web server requires it. This value must be less than 2,048 characters.
	// Read more at: https://www.sitemaps.org/protocol.html#location
	Loc string `xml:"loc"`
	// LastMod is optional. It is the date of last modification of the file.
	LastMod time.Time `xml:"-"`
	// LastModStr do NOT set it directly,
	// other solution would be to use ptr or custom time marshaler but this will ruin the API's expressiveness.
	//
	// See internal `sitemap#Add`.
	LastModStr string `xml:"lastmod,omitempty"`
	// ChangeFreq is optional. Defines how frequently the page is likely to change.
	// This value provides general information to search engines and may not correlate exactly to how often they crawl the page.
	// Valid values are:
	// "always"
	// "hourly"
	// "daily"
	// "weekly"
	// "monthly"
	// "yearly"
	// "never"
	ChangeFreq string `xml:"changefreq,omitempty"`
	// Priority is optional. It defines the priority of this URL relative to other URLs on your site.
	// Valid values range from 0.0 to 1.0.
	//
	// The default priority of a page is 0.5.
	Priority float32 `xml:"priority,omitempty"`

	Links []Link `xml:"xhtml:link,omitempty"`
}

// AddLink adds a link to this URL.
func (u *URL) AddLink(link Link) {
	u.Links = append(u.Links, link)
}

// Link is the optional child element of a URL.
// It can be used to list every alternate version of the page.
//
// Read more at: https://support.google.com/webmasters/answer/189077?hl=en.
type Link struct {
	Rel      string `xml:"rel,attr"`
	Hreflang string `xml:"hreflang,attr"`
	Href     string `xml:"href,attr"`
}

const (
	xmlSchemaURL  = "http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlnsXhtmlURL = "http://www.w3.org/1999/xhtml"
	xmlTimeFormat = "2006-01-02T15:04:05-07:00" // W3C Datetime.
)

type sitemap struct {
	XMLName    xml.Name `xml:"urlset"`
	Xmlns      string   `xml:"xmlns,attr"`
	XmlnsXhtml string   `xml:"xmlns:xhtml,attr,omitempty"`

	URLs []URL `xml:"url"`
}

func newSitemap() *sitemap {
	return &sitemap{
		Xmlns: xmlSchemaURL,
	}
}

func (s *sitemap) Add(url URL) {
	if !url.LastMod.IsZero() {
		url.LastModStr = url.LastMod.Format(xmlTimeFormat)
	}
	s.URLs = append(s.URLs, url)
}

type sitemapIndex struct {
	XMLName    xml.Name `xml:"sitemapindex"`
	Xmlns      string   `xml:"xmlns,attr"`
	XmlnsXhtml string   `xml:"xmlns:xhtml,attr,omitempty"`

	URLs []URL `xml:"sitemap"`
}

func newSitemapIndex() *sitemapIndex {
	return &sitemapIndex{Xmlns: xmlSchemaURL}
}

// Builder is the sitemaps Builder.
type Builder struct {
	startURL     string
	currentIndex int
	sitemaps     []*sitemap

	defaultLang  string
	errorHandler func(err error) (handled bool)
}

// DefaultLang is the default "hreflang" attribute of a self-included Link child element of URL.
const DefaultLang = "en"

// New returns a new sitemaps Builder.
// Use its `Add` to add one or more urls and `Build` once.
func New(startURL string) *Builder {
	return &Builder{
		startURL:     withScheme(startURL),
		currentIndex: 0,
		sitemaps:     []*sitemap{newSitemap()},
		defaultLang:  DefaultLang,
		errorHandler: func(err error) bool {
			log.Fatal(err)
			return false
		},
	}
}

// ErrorHandler sets the error handler.
func (b *Builder) ErrorHandler(fn func(err error) (handled bool)) *Builder {
	if fn == nil {
		fn = func(error) bool {
			return true
		}
	}

	b.errorHandler = fn

	return b
}

// DefaultLang sets the default "hreflang" attribute of a self-included URL Link.
func (b *Builder) DefaultLang(langCode string) *Builder {
	b.defaultLang = langCode
	return b
}

const alternateLinkAttrName = "alternate"

// URL adds a location of a Sitemap file determines the set of URLs that can be included in that Sitemap.
func (b *Builder) URL(sitemapURLs ...URL) *Builder {
	for _, sitemapURL := range sitemapURLs {
		if sitemapURL.Loc == "" {
			continue
		}

		sitemapURL.Loc = concat(b.startURL, sitemapURL.Loc)

		sm := b.sitemaps[b.currentIndex]
		if len(sm.URLs) >= MaxURLsPerSitemap {
			// If static pages are more than 50000 then
			// a sitemap index should be served because each sitemap.xml has a limit of 50000 url elements.
			sm = newSitemap()
			b.currentIndex++
			b.sitemaps = append(b.sitemaps, sm)
		}

		if len(sitemapURL.Links) > 0 {
			sm.XmlnsXhtml = xmlnsXhtmlURL

			hasItself := false
			for idx, link := range sitemapURL.Links {
				link.Href = concat(b.startURL, link.Href)
				if link.Rel == "" && link.Hreflang != "" {
					link.Rel = alternateLinkAttrName
				}

				if !hasItself {
					// Check if the user provided the translated link to that URL itself.
					// the links, if not empty, should provide the URL loc itself.
					if link.Rel == alternateLinkAttrName && link.Hreflang == b.defaultLang {
						hasItself = true
					}
				}

				sitemapURL.Links[idx] = link
			}

			if !hasItself && b.defaultLang != "" {
				sitemapURL.AddLink(Link{
					Rel:      alternateLinkAttrName,
					Hreflang: b.defaultLang,
					Href:     sitemapURL.Loc,
				})
			}
		}

		sm.Add(sitemapURL)
	}

	return b
}

var xmlHeaderElem = []byte("<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>")

// Handler is a sitemap handler. The result of `Builder#Build`.
type Handler struct {
	// Content returns the raw xml data.
	Content []byte
	// Pos returns the position, starting from 0.
	Pos int
	// Path returns the request path that this handler should be listening on.
	Path string
	// IsSitemapIndex reports whether this handler serves a Sitemap Index File.
	IsSitemapIndex bool
}

const indexPath = "/sitemap.xml"

func newSitemapHandler(v interface{}, pos int) (*Handler, error) {
	b, err := xml.Marshal(v)
	if err != nil {
		return nil, err
	}

	sitemapContent := append(xmlHeaderElem, b...)

	path := indexPath
	if pos > 0 {
		path = fmt.Sprintf("/sitemap%d.xml", pos)
	}

	_, isSitemapIndex := v.(*sitemapIndex)

	handler := &Handler{
		Content:        sitemapContent,
		Pos:            pos,
		Path:           path,
		IsSitemapIndex: isSitemapIndex,
	}
	return handler, nil
}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/xml; charset=utf-8")
	w.Write(h.Content)
}

// Build builds the sitemaps based on previous `Builder#URL` calls.
// It returns a list of sitemap Handlers. Each `Handler` is compatible with `net/http#Handler`
// and it contains further like the `Path`, `Pos` and if it's a sitemaps index handler.
func (b *Builder) Build() (handlers []*Handler) {
	pos := 0

	if len(b.sitemaps) == 1 {
		// write single sitemap.
		handler, err := newSitemapHandler(b.sitemaps[pos], pos)
		if err != nil {
			b.errorHandler(err)
		} else {
			handlers = append(handlers, handler)
		}

		return
	}

	index := newSitemapIndex()

	for _, sitemap := range b.sitemaps {
		pos++
		handler, err := newSitemapHandler(sitemap, pos)
		if err != nil {
			pos--
			if !b.errorHandler(err) {
				break
			}
			continue
		}

		index.URLs = append(index.URLs, URL{
			Loc: b.startURL + handler.Path,
		})

		handlers = append(handlers, handler)
	}

	indexHandler, err := newSitemapHandler(index, 0)
	if err != nil {
		if !b.errorHandler(err) {
			return
		}
	}

	// prepend index sitemap.
	handlers = append([]*Handler{indexHandler}, handlers...)
	return
}

func withScheme(s string) string {
	if len(s) == 0 {
		return "http://localhost:8080"
	}

	if !strings.HasPrefix(s, "http://") && !strings.HasPrefix(s, "https://") {
		s = "https://" + s
	}

	if lidx := len(s) - 1; s[lidx] == '/' {
		s = s[0:lidx]
	}

	return s
}

func concat(startURL, loc string) string {
	if loc[0] == '/' {
		return startURL + loc
	}

	return startURL + "/" + loc
}
