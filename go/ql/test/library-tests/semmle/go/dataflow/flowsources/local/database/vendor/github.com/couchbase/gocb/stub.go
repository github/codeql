package gocb

import "time"

type Cluster struct{}

func (c *Cluster) ExecuteAnalyticsQuery(q *AnalyticsQuery, options *AnalyticsOptions) (AnalyticsResult, error) {
	return nil, nil
}

func (c *Cluster) ExecuteN1qlQuery(q *N1qlQuery, params interface{}) (QueryResults, error) {
	return nil, nil
}

func (c *Cluster) ExecuteSearchQuery(q *SearchQuery) (SearchResults, error) {
	return nil, nil
}

type AnalyticsOptions struct{}

type AnalyticsResult interface {
	One(valuePtr interface{}) error
	Next(valuePtr interface{}) bool
	NextBytes() []byte
	Close() error
}

type AnalyticsQuery struct{}

type N1qlQuery struct{}

type QueryResults interface {
	One(valuePtr interface{}) error
	Next(valuePtr interface{}) bool
	NextBytes() []byte
	Close() error
}

type SearchQuery struct{}

type SearchResults interface {
	Status() SearchResultStatus
	Errors() []string
	TotalHits() int
	Hits() []SearchResultHit
	Facets() map[string]SearchResultFacet
	Took() time.Duration
	MaxScore() float64
}

type SearchResultDateFacet struct {
	Name  string `json:"name,omitempty"`
	Min   string `json:"min,omitempty"`
	Max   string `json:"max,omitempty"`
	Count int    `json:"count,omitempty"`
}

type SearchResultFacet struct {
	Field         string                     `json:"field,omitempty"`
	Total         int                        `json:"total,omitempty"`
	Missing       int                        `json:"missing,omitempty"`
	Other         int                        `json:"other,omitempty"`
	Terms         []SearchResultTermFacet    `json:"terms,omitempty"`
	NumericRanges []SearchResultNumericFacet `json:"numeric_ranges,omitempty"`
	DateRanges    []SearchResultDateFacet    `json:"date_ranges,omitempty"`
}

type SearchResultHit struct {
	Index       string                                       `json:"index,omitempty"`
	Id          string                                       `json:"id,omitempty"`
	Score       float64                                      `json:"score,omitempty"`
	Explanation map[string]interface{}                       `json:"explanation,omitempty"`
	Locations   map[string]map[string][]SearchResultLocation `json:"locations,omitempty"`
	Fragments   map[string][]string                          `json:"fragments,omitempty"`
	// Deprecated: See AllFields
	Fields map[string]string `json:"-"`
	// AllFields is to avoid making a breaking change changing the type of Fields. Only
	// fields in the response that are of type string will be put into Fields, all
	// field types will be placed into AllFields.
	AllFields map[string]interface{} `json:"fields,omitempty"`
}

type SearchResultLocation struct {
	Position       int    `json:"position,omitempty"`
	Start          int    `json:"start,omitempty"`
	End            int    `json:"end,omitempty"`
	ArrayPositions []uint `json:"array_positions,omitempty"`
}

type SearchResultNumericFacet struct {
	Name  string  `json:"name,omitempty"`
	Min   float64 `json:"min,omitempty"`
	Max   float64 `json:"max,omitempty"`
	Count int     `json:"count,omitempty"`
}

type SearchResultStatus struct {
	Total      int         `json:"total,omitempty"`
	Failed     int         `json:"failed,omitempty"`
	Successful int         `json:"successful,omitempty"`
	Errors     interface{} `json:"errors,omitempty"`
}

type SearchResultTermFacet struct {
	Term  string `json:"term,omitempty"`
	Count int    `json:"count,omitempty"`
}
