package raymond

import (
	"errors"
	"fmt"
	"reflect"
	"regexp"
	"strconv"
	"sync"
)

// Options represents the options argument provided to helpers and context functions.
type Options struct {
	// evaluation visitor
	eval *evalVisitor

	// params
	params []interface{}
	hash   map[string]interface{}
}

var (
	// helpers stores all globally registered helpers
	helpers      = make(map[string]reflect.Value)
	paramHelpers = make(map[string]paramHelperFunc)

	// protects global helpers
	helpersMutex sync.RWMutex

	// protects global param helpers
	paramHelpersMutex sync.RWMutex
)

func init() {
	// Register builtin helpers.
	RegisterHelper("if", ifHelper)
	RegisterHelper("unless", unlessHelper)
	RegisterHelper("with", withHelper)
	RegisterHelper("each", eachHelper)
	RegisterHelper("log", logHelper)
	RegisterHelper("lookup", lookupHelper)
	RegisterHelper("equal", equalHelper)
	RegisterHelper("ifGt", ifGtHelper)
	RegisterHelper("ifLt", ifLtHelper)
	RegisterHelper("ifEq", ifEqHelper)
	RegisterHelper("ifMatchesRegexStr", ifMatchesRegexStr)
	RegisterHelper("pluralize", pluralizeHelper)

	// Register builtin param helpers.
	RegisterParamHelper("length", lengthParamHelper)
}

// RegisterHelper registers a global helper. That helper will be available to all templates.
func RegisterHelper(name string, helper interface{}) {
	helpersMutex.Lock()
	defer helpersMutex.Unlock()

	if helpers[name] != zero {
		panic(fmt.Errorf("Helper already registered: %s", name))
	}

	val := reflect.ValueOf(helper)
	ensureValidHelper(name, val)

	helpers[name] = val
}

// RegisterHelpers registers several global helpers. Those helpers will be available to all templates.
func RegisterHelpers(helpers map[string]interface{}) {
	for name, helper := range helpers {
		RegisterHelper(name, helper)
	}
}

// RemoveHelper unregisters a global helper
func RemoveHelper(name string) {
	helpersMutex.Lock()
	defer helpersMutex.Unlock()

	delete(helpers, name)
}

// RemoveAllHelpers unregisters all global helpers
func RemoveAllHelpers() {
	helpersMutex.Lock()
	defer helpersMutex.Unlock()

	helpers = make(map[string]reflect.Value)
}

// ensureValidHelper panics if given helper is not valid
func ensureValidHelper(name string, funcValue reflect.Value) {
	if funcValue.Kind() != reflect.Func {
		panic(fmt.Errorf("Helper must be a function: %s", name))
	}

	funcType := funcValue.Type()

	if funcType.NumOut() != 1 {
		panic(fmt.Errorf("Helper function must return a string or a SafeString: %s", name))
	}

	// @todo Check if first returned value is a string, SafeString or interface{} ?
}

// findHelper finds a globally registered helper
func findHelper(name string) reflect.Value {
	helpersMutex.RLock()
	defer helpersMutex.RUnlock()

	return helpers[name]
}

// newOptions instanciates a new Options
func newOptions(eval *evalVisitor, params []interface{}, hash map[string]interface{}) *Options {
	return &Options{
		eval:   eval,
		params: params,
		hash:   hash,
	}
}

// newEmptyOptions instanciates a new empty Options
func newEmptyOptions(eval *evalVisitor) *Options {
	return &Options{
		eval: eval,
		hash: make(map[string]interface{}),
	}
}

//
// Context Values
//

// Value returns field value from current context.
func (options *Options) Value(name string) interface{} {
	value := options.eval.evalField(options.eval.curCtx(), name, false)
	if !value.IsValid() {
		return nil
	}

	return value.Interface()
}

// ValueStr returns string representation of field value from current context.
func (options *Options) ValueStr(name string) string {
	return Str(options.Value(name))
}

// Ctx returns current evaluation context.
func (options *Options) Ctx() interface{} {
	return options.eval.curCtx().Interface()
}

//
// Hash Arguments
//

// HashProp returns hash property.
func (options *Options) HashProp(name string) interface{} {
	return options.hash[name]
}

// HashStr returns string representation of hash property.
func (options *Options) HashStr(name string) string {
	return Str(options.hash[name])
}

// Hash returns entire hash.
func (options *Options) Hash() map[string]interface{} {
	return options.hash
}

//
// Parameters
//

// Param returns parameter at given position.
func (options *Options) Param(pos int) interface{} {
	if len(options.params) > pos {
		return options.params[pos]
	}

	return nil
}

// ParamStr returns string representation of parameter at given position.
func (options *Options) ParamStr(pos int) string {
	return Str(options.Param(pos))
}

// Params returns all parameters.
func (options *Options) Params() []interface{} {
	return options.params
}

//
// Private data
//

// Data returns private data value.
func (options *Options) Data(name string) interface{} {
	return options.eval.dataFrame.Get(name)
}

// DataStr returns string representation of private data value.
func (options *Options) DataStr(name string) string {
	return Str(options.eval.dataFrame.Get(name))
}

// DataFrame returns current private data frame.
func (options *Options) DataFrame() *DataFrame {
	return options.eval.dataFrame
}

// NewDataFrame instanciates a new data frame that is a copy of current evaluation data frame.
//
// Parent of returned data frame is set to current evaluation data frame.
func (options *Options) NewDataFrame() *DataFrame {
	return options.eval.dataFrame.Copy()
}

// newIterDataFrame instanciates a new data frame and set iteration specific vars
func (options *Options) newIterDataFrame(length int, i int, key interface{}) *DataFrame {
	return options.eval.dataFrame.newIterDataFrame(length, i, key)
}

//
// Evaluation
//

// evalBlock evaluates block with given context, private data and iteration key
func (options *Options) evalBlock(ctx interface{}, data *DataFrame, key interface{}) string {
	result := ""

	if block := options.eval.curBlock(); (block != nil) && (block.Program != nil) {
		result = options.eval.evalProgram(block.Program, ctx, data, key)
	}

	return result
}

// Fn evaluates block with current evaluation context.
func (options *Options) Fn() string {
	return options.evalBlock(nil, nil, nil)
}

// FnCtxData evaluates block with given context and private data frame.
func (options *Options) FnCtxData(ctx interface{}, data *DataFrame) string {
	return options.evalBlock(ctx, data, nil)
}

// FnWith evaluates block with given context.
func (options *Options) FnWith(ctx interface{}) string {
	return options.evalBlock(ctx, nil, nil)
}

// FnData evaluates block with given private data frame.
func (options *Options) FnData(data *DataFrame) string {
	return options.evalBlock(nil, data, nil)
}

// Inverse evaluates "else block".
func (options *Options) Inverse() string {
	result := ""
	if block := options.eval.curBlock(); (block != nil) && (block.Inverse != nil) {
		result, _ = block.Inverse.Accept(options.eval).(string)
	}

	return result
}

// Eval evaluates field for given context.
func (options *Options) Eval(ctx interface{}, field string) interface{} {
	if ctx == nil {
		return nil
	}

	if field == "" {
		return nil
	}

	val := options.eval.evalField(reflect.ValueOf(ctx), field, false)
	if !val.IsValid() {
		return nil
	}

	return val.Interface()
}

//
// Misc
//

// isIncludableZero returns true if 'includeZero' option is set and first param is the number 0
func (options *Options) isIncludableZero() bool {
	b, ok := options.HashProp("includeZero").(bool)
	if ok && b {
		nb, ok := options.Param(0).(int)
		if ok && nb == 0 {
			return true
		}
	}

	return false
}

//
// Builtin helpers
//

// #if block helper
func ifHelper(conditional interface{}, options *Options) interface{} {
	if options.isIncludableZero() || IsTrue(conditional) {
		return options.Fn()
	}

	return options.Inverse()
}

func ifGtHelper(a, b interface{}, options *Options) interface{} {
	var aFloat, bFloat float64
	var err error

	if aFloat, err = floatValue(a); err != nil {
		log.WithError(err).Errorf("failed to convert value to float '%v'", a)
		return options.Inverse()
	}
	if bFloat, err = floatValue(b); err != nil {
		log.WithError(err).Errorf("failed to convert value to float '%v'", b)
		return options.Inverse()
	}

	if aFloat > bFloat {
		return options.Fn()
	}
	// Evaluate possible else condition.
	return options.Inverse()
}

func ifLtHelper(a, b interface{}, options *Options) interface{} {
	var aFloat, bFloat float64
	var err error

	if aFloat, err = floatValue(a); err != nil {
		log.WithError(err).Errorf("failed to convert value to float '%v'", a)
		return options.Inverse()
	}
	if bFloat, err = floatValue(b); err != nil {
		log.WithError(err).Errorf("failed to convert value to float '%v'", b)
		return options.Inverse()
	}

	if aFloat < bFloat {
		return options.Fn()
	}
	// Evaluate possible else condition.
	return options.Inverse()
}

func ifEqHelper(a, b interface{}, options *Options) interface{} {
	var aFloat, bFloat float64
	var err error

	if aFloat, err = floatValue(a); err != nil {
		log.WithError(err).Errorf("failed to convert value to float '%v'", a)
		return options.Inverse()
	}
	if bFloat, err = floatValue(b); err != nil {
		log.WithError(err).Errorf("failed to convert value to float '%v'", b)
		return options.Inverse()
	}

	if aFloat == bFloat {
		return options.Fn()
	}
	// Evaluate possible else condition.
	return options.Inverse()
}

// ifMatchesRegexStr is helper function which does a regex match, where a is the expression to compile and
// b is the string to match against.
func ifMatchesRegexStr(a, b interface{}, options *Options) interface{} {
	exp := Str(a)
	match := Str(b)

	re, err := regexp.Compile(exp)
	if err != nil {
		log.WithError(err).Errorf("failed to compile regex '%v'", a)
		return options.Inverse()
	}

	if re.MatchString(match) {
		return options.Fn()
	}
	return options.Inverse()
}

func pluralizeHelper(count, plural, singular interface{}) interface{} {
	if c, err := floatValue(count); err != nil || c <= 1 {
		return singular
	}
	return plural
}

// #unless block helper
func unlessHelper(conditional interface{}, options *Options) interface{} {
	if options.isIncludableZero() || IsTrue(conditional) {
		return options.Inverse()
	}

	return options.Fn()
}

// #with block helper
func withHelper(context interface{}, options *Options) interface{} {
	if IsTrue(context) {
		return options.FnWith(context)
	}

	return options.Inverse()
}

// #each block helper
func eachHelper(context interface{}, options *Options) interface{} {
	if !IsTrue(context) {
		return options.Inverse()
	}

	result := ""

	val := reflect.ValueOf(context)
	switch val.Kind() {
	case reflect.Array, reflect.Slice:
		for i := 0; i < val.Len(); i++ {
			// computes private data
			data := options.newIterDataFrame(val.Len(), i, nil)

			// evaluates block
			result += options.evalBlock(val.Index(i).Interface(), data, i)
		}
	case reflect.Map:
		// note: a go hash is not ordered, so result may vary, this behaviour differs from the JS implementation
		keys := val.MapKeys()
		for i := 0; i < len(keys); i++ {
			key := keys[i].Interface()
			ctx := val.MapIndex(keys[i]).Interface()

			// computes private data
			data := options.newIterDataFrame(len(keys), i, key)

			// evaluates block
			result += options.evalBlock(ctx, data, key)
		}
	case reflect.Struct:
		var exportedFields []int

		// collect exported fields only
		for i := 0; i < val.NumField(); i++ {
			if tField := val.Type().Field(i); tField.PkgPath == "" {
				exportedFields = append(exportedFields, i)
			}
		}

		for i, fieldIndex := range exportedFields {
			key := val.Type().Field(fieldIndex).Name
			ctx := val.Field(fieldIndex).Interface()

			// computes private data
			data := options.newIterDataFrame(len(exportedFields), i, key)

			// evaluates block
			result += options.evalBlock(ctx, data, key)
		}
	}

	return result
}

// #log helper
func logHelper(message string) interface{} {
	log.Print(message)
	return ""
}

// #lookup helper
func lookupHelper(obj interface{}, field string, options *Options) interface{} {
	return Str(options.Eval(obj, field))
}

// #equal helper
// Ref: https://github.com/aymerick/raymond/issues/7
func equalHelper(a interface{}, b interface{}, options *Options) interface{} {
	if Str(a) == Str(b) {
		return options.Fn()
	}

	return ""
}

// floatValue attempts to convert value into a float64 and returns an error if it fails.
func floatValue(value interface{}) (result float64, err error) {
	val := reflect.ValueOf(value)

	switch val.Kind() {
	case reflect.Bool:
		result = 0
		if val.Bool() {
			result = 1
		}
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
		result = float64(val.Int())
	case reflect.Float32, reflect.Float64:
		result = val.Float()
	case reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64, reflect.Uintptr:
		result = float64(val.Uint())
	case reflect.String:
		result, err = strconv.ParseFloat(val.String(), 64)
	default:
		err = errors.New(fmt.Sprintf("uable to convert type '%s' to float64", val.Kind().String()))
	}
	return
}

// A paramHelperFunc is a function that will mutate the input by performing some kind of
// operation on it. Such as getting the length of a string, slice, or map.
type paramHelperFunc func(value reflect.Value) reflect.Value

// RegisterParamHelper registers a global param helper. That helper will be available to all templates.
func RegisterParamHelper(name string, helper paramHelperFunc) {
	paramHelpersMutex.Lock()
	defer paramHelpersMutex.Unlock()

	if _, ok := paramHelpers[name]; ok {
		panic(fmt.Errorf("Param helper already registered: %s", name))
	}

	paramHelpers[name] = helper
}

// RemoveParamHelper unregisters a global param helper
func RemoveParamHelper(name string) {
	paramHelpersMutex.Lock()
	defer paramHelpersMutex.Unlock()

	delete(paramHelpers, name)
}

// findParamHelper finds a globally registered param helper
func findParamHelper(name string) paramHelperFunc {
	paramHelpersMutex.RLock()
	defer paramHelpersMutex.RUnlock()

	return paramHelpers[name]
}

// lengthParamHelper is a helper func to return the length of the value passed. It
// will only return the length if the value  is an array, slice, map, or string. Otherwise,
// it returns zero value.
// e.g. foo == "foo" -> foo.length -> 3
func lengthParamHelper(ctx reflect.Value) reflect.Value {
	if ctx == zero {
		return ctx
	}

	switch ctx.Kind() {
	case reflect.Array, reflect.Slice, reflect.Map, reflect.String:
		return reflect.ValueOf(ctx.Len())

	}
	return zero
}
