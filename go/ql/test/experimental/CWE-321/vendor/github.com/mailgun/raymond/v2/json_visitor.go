package raymond

import (
	"encoding/json"
	"github.com/mailgun/raymond/v2/ast"
	"strings"
)

type list []interface{}

func (l *list) Add(item interface{}) {
	*l = append(*l, item)
}

func (l *list) Get() interface{} {
	return (*l)[0]
}

func (l *list) Len() int {
	return len(*l)
}

func newList(item interface{}) *list {
	l := new(list)
	l.Add(item)
	return l
}

type JSONVisitor struct {
	JSON map[string]interface{}
	ctx  *handlebarsContext
}

func newJSONVisitor() *JSONVisitor {
	j := map[string]interface{}{}
	v := &JSONVisitor{JSON: j, ctx: newHandlebarsContext()}
	return v
}

func ToJSON(node ast.Node) string {
	visitor := newJSONVisitor()
	node.Accept(visitor)
	b, _ := json.Marshal(visitor.JSON)
	return string(b)
}

func (v *JSONVisitor) VisitProgram(node *ast.Program) interface{} {
	for _, n := range node.Body {
		n.Accept(v)
	}
	return v.JSON
}

func (v *JSONVisitor) VisitMustache(node *ast.MustacheStatement) interface{} {

	node.Expression.Accept(v)

	return nil
}

func (v *JSONVisitor) VisitBlock(node *ast.BlockStatement) interface{} {
	var action string
	fp := node.Expression.FieldPath()
	if fp != nil {
		action = node.Expression.HelperName()
	}
	if action == "with" || action == "each" {
		blockParamsPath := make([]string, 0)
		blockParams := make([]string, 0)
		for _, params := range node.Expression.Params {
			// Extract block params from nested nodes.
			if pe, ok := params.(*ast.PathExpression); ok {
				blockParamsPath = append(blockParamsPath, pe.Parts...)
			}
		}
		if node.Program != nil {
			if len(node.Program.BlockParams) > 0 {
				blockParams = append(node.Program.BlockParams)
			}
		}
		if action == "each" {
			blockParamsPath = append(blockParamsPath, "[0]")
		}
		if len(blockParams) > 0 {
			v.ctx.AddMemberContext(strings.Join(blockParamsPath, "."), strings.Join(blockParams, "."))
		} else {
			v.ctx.AddMemberContext(strings.Join(blockParamsPath, "."), "")
		}
		if node.Program != nil {
			node.Program.Accept(v)
		}
		if node.Inverse != nil {
			node.Inverse.Accept(v)
		}
		v.ctx.MoveUpContext()
	} else {
		for _, param := range node.Expression.Params {
			param.Accept(v)
		}
		if node.Program != nil {
			node.Program.Accept(v)
		}
		if node.Inverse != nil {
			node.Inverse.Accept(v)
		}
	}
	return nil
}

func (v *JSONVisitor) VisitPartial(node *ast.PartialStatement) interface{} {

	return nil
}

func (v *JSONVisitor) VisitContent(node *ast.ContentStatement) interface{} {

	return nil
}

func (v *JSONVisitor) VisitComment(node *ast.CommentStatement) interface{} {

	return nil
}

func (v *JSONVisitor) VisitExpression(node *ast.Expression) interface{} {
	var action string
	fp := node.FieldPath()
	if fp != nil {
		if len(fp.Parts) > 0 {
			action = node.HelperName()
			if action == "lookup" {
				if len(node.Params) > 0 {
					path, ok := node.Params[0].(*ast.PathExpression)
					if ok {
						depth := path.Depth
						tmpPath := []string{}
						for _, p := range path.Parts {
							tmpPath = append(tmpPath, p)
						}
						for _, n := range node.Params[1:] {
							pe, ok := n.(*ast.PathExpression)
							if ok {
								pe.Depth = depth
								pe.Parts = append(tmpPath, pe.Parts...)
								pe.Accept(v)
							}
						}
						return nil
					}
				}
			}
		}
	}
	node.Path.Accept(v)
	for _, n := range node.Params {
		n.Accept(v)
	}
	return nil
}

func (v *JSONVisitor) VisitSubExpression(node *ast.SubExpression) interface{} {
	node.Expression.Accept(v)

	return nil
}

func (v *JSONVisitor) VisitPath(node *ast.PathExpression) interface{} {
	if node.Data {
		data := node.Parts[len(node.Parts)-1]
		if data == "index" {
			node.Parts[len(node.Parts)-1] = "[0]"
		}
	}
	if node.Scoped {
		if strings.HasPrefix(node.Original, ".") && !strings.HasPrefix(node.Original, "..") {
			if len(node.Parts) == 0 {
				node.Parts = []string{""}
			}
		}
	}
	res := v.ctx.GetMappedContext(node.Parts, node.Depth)
	v.appendToJSON(res)
	return nil
}

func (v *JSONVisitor) VisitString(node *ast.StringLiteral) interface{} {
	return nil
}

func (v *JSONVisitor) VisitBoolean(node *ast.BooleanLiteral) interface{} {
	return nil
}

func (v *JSONVisitor) VisitNumber(node *ast.NumberLiteral) interface{} {

	return nil
}

func (v *JSONVisitor) VisitHash(node *ast.Hash) interface{} {
	return nil
}

func (v *JSONVisitor) VisitHashPair(node *ast.HashPair) interface{} {
	return nil
}

func (v *JSONVisitor) appendToJSON(templateLabels []string) {
	var tmp interface{}
	tmp = v.JSON
	for idx, name := range templateLabels {
		var onArrayLabel, isArray, isLastLabel bool
		//Figure out if name is an array Label.
		if strings.HasPrefix(name, "[") {
			onArrayLabel = true
		}
		//Figure out if we are on a simple last label.
		if idx == len(templateLabels)-1 {
			isLastLabel = true
		}
		//Figure out if the next label is an array label.
		if !isLastLabel {
			if strings.HasPrefix(templateLabels[idx+1], "[") {
				isArray = true
			}
		}
		//Complex isLastLabel check.
		//Since we skip onArrayLabels not nested with another array.
		//foo.[0].[0] would not skip first array label.
		//This allows us to know it's a nested array
		//and not a struct value with an array.
		// foo.[0].baz would skip array label.
		// If isArray and is not isLastLabel and if
		// the idx is equal to the length of the slice - 2
		// We know this is actually the last label as we skip single instances
		// of an array label.
		if isArray && !isLastLabel {
			if idx == len(templateLabels)-2 {
				isLastLabel = true
			}
		}
		//If onArrayLabel and not isArray
		//Skip this iteration because we only care about
		// array labels for nested arrays.
		if onArrayLabel && !isArray {
			continue
		}
		switch c := tmp.(type) {
		case map[string]interface{}:
			if _, ok := c[name]; !ok {
				//If the name does not exist in the map
				//And is the last label.
				if isLastLabel {
					//If that last label is an array.
					if isArray {
						//Use the provided name to make a new list and mock the string value.
						c[name] = newList(mockStringValue(name))
					} else {
						//If it is not an array. Add the value as a mocked string value set to the current name.
						c[name] = mockStringValue(name)
					}
				} else {
					//If it is not the last label.
					// And the label value is an array.
					if isArray {
						//Set the label name to a new list value
						c[name] = new(list)
					} else {
						//If the value is not an array and it is not the last value.
						//It must be a map
						c[name] = map[string]interface{}{}
					}
				}
			} else {
				//If the name does exist in the map lets determine its type.
				if li, ok := c[name].(list); ok {
					//If it's a list and is the last value.
					//Set the the 0 index of the list to name
					//If it is not already set.
					if isLastLabel && li.Len() == 0 {
						li.Add(mockStringValue(name))
					}
				} else if _, ok := c[name].(string); ok {
					//If c[name]'s value is a string and it is not the last label
					//c[name] had been used in an if or other reference that made us
					// determine it was a string value. That is false turn it into a map.
					if !isLastLabel {
						c[name] = map[string]interface{}{}
					}
				}
			}
			//Update tmp to the next deepest value
			tmp = c[name]
		case *list:
			//If type is list.
			//If it is the last label and is array and on array label.
			//This is a special case where we know our final value is an array.
			//So we can just add the array and the final value.
			//However cause these arrays are nested at an unknown depth we use test_value
			//Rather than replacing it with name, because name is actually an array label.
			if isLastLabel && isArray && onArrayLabel {
				if c.Len() == 0 {
					c.Add(newList("test_value"))
				}
			} else if isArray && isLastLabel {
				//If isArray and isLastLabel.
				//We know that it is safe to use name for the value.
				//So we set it as such.
				if c.Len() == 0 {
					c.Add(mockStringValue(name))
				}
			} else if isArray {
				//If it is not the last item just add an array.
				if c.Len() == 0 {
					c.Add(new(list))
				}
			} else {
				if c.Len() == 0 {
					if isLastLabel {
						//If already in an array and no string values have been applied above.
						//Then this indicates a map to end this label resolution
						c.Add(map[string]interface{}{name: mockStringValue(name)})
					} else {
						//If not last label and not a future nested array as determined above.
						//Then make this a map.
						c.Add(map[string]interface{}{name: map[string]interface{}{}})
					}
				} else {
					//If c.Len is greater than zero we have already added to this array.
					//The only case that should fall through here is a previously created map.
					if _, ok := (*c)[0].(map[string]interface{}); ok {
						if isLastLabel {
							//If this is the last label assign it to the map and mock it's value.
							(*c)[0].(map[string]interface{})[name] = mockStringValue(name)
						} else {
							//If it's not the last label. Add just the map.
							(*c)[0].(map[string]interface{})[name] = (map[string]interface{}{})
						}
					}
				}
				//If we had to mess with maps assign tmp the map value matching name within the array.
				tmp = (*c)[0].(map[string]interface{})[name]
				continue
			}
			//Assign tmp to the 0 index of the array. *Note we should never have any arrays larger than a length of 1.
			tmp = (*c)[0]

		}
	}
}

func mockStringValue(name string) string {
	return "test_" + name
}
