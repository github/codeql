package gqlparser

import (
	"github.com/vektah/gqlparser/v2/ast"
	"github.com/vektah/gqlparser/v2/gqlerror"
	"github.com/vektah/gqlparser/v2/parser"
	"github.com/vektah/gqlparser/v2/validator"

	// Blank import is used to load up the validator rules.
	_ "github.com/vektah/gqlparser/v2/validator/rules"
)

func LoadSchema(str ...*ast.Source) (*ast.Schema, error) {
	ast, err := validator.LoadSchema(append([]*ast.Source{validator.Prelude}, str...)...)
	gqlErr, ok := err.(*gqlerror.Error)
	if ok {
		return ast, gqlErr
	}
	if err != nil {
		return ast, gqlerror.Wrap(err)
	}
	return ast, nil
}

func MustLoadSchema(str ...*ast.Source) *ast.Schema {
	s, err := validator.LoadSchema(append([]*ast.Source{validator.Prelude}, str...)...)
	if err != nil {
		panic(err)
	}
	return s
}

func LoadQuery(schema *ast.Schema, str string) (*ast.QueryDocument, gqlerror.List) {
	query, err := parser.ParseQuery(&ast.Source{Input: str})
	if err != nil {
		gqlErr, ok := err.(*gqlerror.Error)
		if ok {
			return nil, gqlerror.List{gqlErr}
		}
		return nil, gqlerror.List{gqlerror.Wrap(err)}
	}
	errs := validator.Validate(schema, query)
	if len(errs) > 0 {
		return nil, errs
	}

	return query, nil
}

func MustLoadQuery(schema *ast.Schema, str string) *ast.QueryDocument {
	q, err := LoadQuery(schema, str)
	if err != nil {
		panic(err)
	}
	return q
}
