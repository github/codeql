package xpath

import "github.com/lestrrat-go/libxml2/types"

// String returns the string component of the result, and as a side effect
// releases the Result by calling Free() on it. Use this if you do not
// really care about the error value from Find()
func String(r types.XPathResult, err error) string {
	if err != nil {
		return ""
	}

	defer r.Free()
	return r.String()
}

// Bool returns the boolean component of the result, and as a side effect
// releases the Result by calling Free() on it. Use this if you do not
// really care about the error value from Find()
func Bool(r types.XPathResult, err error) bool {
	if err != nil {
		return false
	}

	defer r.Free()
	return r.Bool()
}

// Number returns the numeric component of the result, and as a side effect
// releases the Result by calling Free() on it. Use this if you do not
// really care about the error value from Find()
func Number(r types.XPathResult, err error) float64 {
	if err != nil {
		return 0
	}

	defer r.Free()
	return r.Number()
}

// NodeList returns the nodes associated with this result, and as a side effect
// releases the result by calling Free() on it. Use this if you do not
// really care about the error value from Find().
func NodeList(r types.XPathResult, err error) types.NodeList {
	if err != nil {
		return nil
	}

	defer r.Free()
	return r.NodeList()
}

// NodeIter returns an iterator that will return the nodes assocaied with
// this reult,  and as a side effect releases the result by calling Free()
// on it. Use this if you do not really care about the error value from Find().
func NodeIter(r types.XPathResult, err error) types.NodeIter {
	if err != nil {
		return NewNodeIterator(nil)
	}

	defer r.Free()
	return r.NodeIter()
}
