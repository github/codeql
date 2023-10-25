// Package raymond provides handlebars evaluation
package raymond

import "github.com/sirupsen/logrus"

var log *logrus.Entry

func init() {
	log = logrus.NewEntry(logrus.StandardLogger())
}

// SetLogger allows the user to set a customer logger adding the ability to add custom fields to
// the log entries.
func SetLogger(entry *logrus.Entry) {
	log = entry
}

// Render parses a template and evaluates it with given context
//
// Note that this function call is not optimal as your template is parsed everytime you call it. You should use Parse() function instead.
func Render(source string, ctx interface{}) (string, error) {
	// parse template
	tpl, err := Parse(source)
	if err != nil {
		return "", err
	}

	// renders template
	str, err := tpl.Exec(ctx)
	if err != nil {
		return "", err
	}

	return str, nil
}

// MustRender parses a template and evaluates it with given context. It panics on error.
//
// Note that this function call is not optimal as your template is parsed everytime you call it. You should use Parse() function instead.
func MustRender(source string, ctx interface{}) string {
	return MustParse(source).MustExec(ctx)
}
