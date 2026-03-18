package schema

var (
	defaultDecoder = NewDecoder() // form, url, header, param, schema.
	// Form Decoder. The default instance for DecodeForm function.
	Form = NewDecoder().SetAliasTag("form")
	// Query Decoder. The default instance for DecodeQuery function.
	Query = NewDecoder().SetAliasTag("url").IgnoreUnknownKeys(true) // allow unknown url queries
	// Headers Decoder. The default instance for DecodeHeaders function.
	Headers = NewDecoder().SetAliasTag("header").IgnoreUnknownKeys(true)
	// Params Decoder. The default instance for DecodeParams function.
	Params = NewDecoder().SetAliasTag("param").IgnoreUnknownKeys(true)
)

// Decode maps "values" to "ptr".
// With one of the "form", "url" or "schema" tag fields that can override the field's name mapping to key.
func Decode(values map[string][]string, ptr interface{}) error {
	return defaultDecoder.Decode(ptr, values)
}

// DecodeForm maps "values" to "ptr".
// With "form" tag for fields.
func DecodeForm(values map[string][]string, ptr interface{}) error {
	return Form.Decode(ptr, values)
}

// DecodeQuery maps "values" to "ptr".
// With "url" tag for fields.
func DecodeQuery(values map[string][]string, ptr interface{}) error {
	return Query.Decode(ptr, values)
}

// DecodeHeaders maps "values" to "ptr".
// With "header" tag for fields.
func DecodeHeaders(values map[string][]string, ptr interface{}) error {
	return Headers.Decode(ptr, values)
}

// DecodeParams maps "values" to "ptr".
// With "param" tag for fields.
func DecodeParams(values map[string][]string, ptr interface{}) error {
	return Params.Decode(ptr, values)
}

// IsErrPath reports whether the incoming error is type of unknown field passed,
// which can be ignored when server allows unknown post values to be sent by the client.
func IsErrPath(err error) bool {
	if err == nil {
		return false
	}

	if m, ok := err.(MultiError); ok {
		j := len(m)
		for _, e := range m {
			if _, is := e.(UnknownKeyError); is {
				j--
			}
		}

		return j == 0
	}

	return false
}
