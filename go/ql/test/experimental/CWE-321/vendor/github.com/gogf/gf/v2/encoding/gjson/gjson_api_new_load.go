// Copyright GoFrame Author(https://goframe.org). All Rights Reserved.
//
// This Source Code Form is subject to the terms of the MIT License.
// If a copy of the MIT was not distributed with this file,
// You can obtain one at https://github.com/gogf/gf.

package gjson

import (
	"bytes"
	"reflect"

	"github.com/gogf/gf/v2/encoding/gini"
	"github.com/gogf/gf/v2/encoding/gtoml"
	"github.com/gogf/gf/v2/encoding/gxml"
	"github.com/gogf/gf/v2/encoding/gyaml"
	"github.com/gogf/gf/v2/errors/gcode"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/internal/json"
	"github.com/gogf/gf/v2/internal/rwmutex"
	"github.com/gogf/gf/v2/internal/utils"
	"github.com/gogf/gf/v2/os/gfile"
	"github.com/gogf/gf/v2/text/gregex"
	"github.com/gogf/gf/v2/util/gconv"
)

// New creates a Json object with any variable type of `data`, but `data` should be a map
// or slice for data access reason, or it will make no sense.
//
// The parameter `safe` specifies whether using this Json object in concurrent-safe context,
// which is false in default.
func New(data interface{}, safe ...bool) *Json {
	return NewWithTag(data, "json", safe...)
}

// NewWithTag creates a Json object with any variable type of `data`, but `data` should be a map
// or slice for data access reason, or it will make no sense.
//
// The parameter `tags` specifies priority tags for struct conversion to map, multiple tags joined
// with char ','.
//
// The parameter `safe` specifies whether using this Json object in concurrent-safe context, which
// is false in default.
func NewWithTag(data interface{}, tags string, safe ...bool) *Json {
	option := Options{
		Tags: tags,
	}
	if len(safe) > 0 && safe[0] {
		option.Safe = true
	}
	return NewWithOptions(data, option)
}

// NewWithOptions creates a Json object with any variable type of `data`, but `data` should be a map
// or slice for data access reason, or it will make no sense.
func NewWithOptions(data interface{}, options Options) *Json {
	var j *Json
	switch data.(type) {
	case string, []byte:
		if r, err := loadContentWithOptions(data, options); err == nil {
			j = r
		} else {
			j = &Json{
				p:  &data,
				c:  byte(defaultSplitChar),
				vc: false,
			}
		}
	default:
		var reflectInfo = utils.OriginValueAndKind(data)
		switch reflectInfo.OriginKind {
		case reflect.Slice, reflect.Array:
			var i interface{} = gconv.Interfaces(data)
			j = &Json{
				p:  &i,
				c:  byte(defaultSplitChar),
				vc: false,
			}
		case reflect.Map:
			var i interface{} = gconv.MapDeep(data, options.Tags)
			j = &Json{
				p:  &i,
				c:  byte(defaultSplitChar),
				vc: false,
			}
		case reflect.Struct:
			if v, ok := data.(iVal); ok {
				return NewWithOptions(v.Val(), options)
			}
			var i interface{} = gconv.MapDeep(data, options.Tags)
			j = &Json{
				p:  &i,
				c:  byte(defaultSplitChar),
				vc: false,
			}
		default:
			j = &Json{
				p:  &data,
				c:  byte(defaultSplitChar),
				vc: false,
			}
		}
	}
	j.mu = rwmutex.New(options.Safe)
	return j
}

// Load loads content from specified file `path`, and creates a Json object from its content.
func Load(path string, safe ...bool) (*Json, error) {
	if p, err := gfile.Search(path); err != nil {
		return nil, err
	} else {
		path = p
	}
	option := Options{}
	if len(safe) > 0 && safe[0] {
		option.Safe = true
	}
	return doLoadContentWithOptions(gfile.Ext(path), gfile.GetBytesWithCache(path), option)
}

// LoadJson creates a Json object from given JSON format content.
func LoadJson(data interface{}, safe ...bool) (*Json, error) {
	option := Options{}
	if len(safe) > 0 && safe[0] {
		option.Safe = true
	}
	return doLoadContentWithOptions("json", gconv.Bytes(data), option)
}

// LoadXml creates a Json object from given XML format content.
func LoadXml(data interface{}, safe ...bool) (*Json, error) {
	option := Options{}
	if len(safe) > 0 && safe[0] {
		option.Safe = true
	}
	return doLoadContentWithOptions("xml", gconv.Bytes(data), option)
}

// LoadIni creates a Json object from given INI format content.
func LoadIni(data interface{}, safe ...bool) (*Json, error) {
	option := Options{}
	if len(safe) > 0 && safe[0] {
		option.Safe = true
	}
	return doLoadContentWithOptions("ini", gconv.Bytes(data), option)
}

// LoadYaml creates a Json object from given YAML format content.
func LoadYaml(data interface{}, safe ...bool) (*Json, error) {
	option := Options{}
	if len(safe) > 0 && safe[0] {
		option.Safe = true
	}
	return doLoadContentWithOptions("yaml", gconv.Bytes(data), option)
}

// LoadToml creates a Json object from given TOML format content.
func LoadToml(data interface{}, safe ...bool) (*Json, error) {
	option := Options{}
	if len(safe) > 0 && safe[0] {
		option.Safe = true
	}
	return doLoadContentWithOptions("toml", gconv.Bytes(data), option)
}

// LoadContent creates a Json object from given content, it checks the data type of `content`
// automatically, supporting data content type as follows:
// JSON, XML, INI, YAML and TOML.
func LoadContent(data interface{}, safe ...bool) (*Json, error) {
	content := gconv.Bytes(data)
	if len(content) == 0 {
		return New(nil, safe...), nil
	}
	return LoadContentType(checkDataType(content), content, safe...)
}

// LoadContentType creates a Json object from given type and content,
// supporting data content type as follows:
// JSON, XML, INI, YAML and TOML.
func LoadContentType(dataType string, data interface{}, safe ...bool) (*Json, error) {
	content := gconv.Bytes(data)
	if len(content) == 0 {
		return New(nil, safe...), nil
	}
	// ignore UTF8-BOM
	if content[0] == 0xEF && content[1] == 0xBB && content[2] == 0xBF {
		content = content[3:]
	}
	option := Options{}
	if len(safe) > 0 && safe[0] {
		option.Safe = true
	}
	return doLoadContentWithOptions(dataType, content, option)
}

// IsValidDataType checks and returns whether given `dataType` a valid data type for loading.
func IsValidDataType(dataType string) bool {
	if dataType == "" {
		return false
	}
	if dataType[0] == '.' {
		dataType = dataType[1:]
	}
	switch dataType {
	case "json", "js", "xml", "yaml", "yml", "toml", "ini":
		return true
	}
	return false
}

func loadContentWithOptions(data interface{}, options Options) (*Json, error) {
	content := gconv.Bytes(data)
	if len(content) == 0 {
		return NewWithOptions(nil, options), nil
	}
	return loadContentTypeWithOptions(checkDataType(content), content, options)
}

func loadContentTypeWithOptions(dataType string, data interface{}, options Options) (*Json, error) {
	content := gconv.Bytes(data)
	if len(content) == 0 {
		return NewWithOptions(nil, options), nil
	}
	// ignore UTF8-BOM
	if content[0] == 0xEF && content[1] == 0xBB && content[2] == 0xBF {
		content = content[3:]
	}
	return doLoadContentWithOptions(dataType, content, options)
}

// doLoadContent creates a Json object from given content.
// It supports data content type as follows:
// JSON, XML, INI, YAML and TOML.
func doLoadContentWithOptions(dataType string, data []byte, options Options) (*Json, error) {
	var (
		err    error
		result interface{}
	)
	if len(data) == 0 {
		return NewWithOptions(nil, options), nil
	}
	if dataType == "" {
		dataType = checkDataType(data)
	}
	switch dataType {
	case "json", ".json", ".js":

	case "xml", ".xml":
		if data, err = gxml.ToJson(data); err != nil {
			return nil, err
		}

	case "yml", "yaml", ".yml", ".yaml":
		if data, err = gyaml.ToJson(data); err != nil {
			return nil, err
		}

	case "toml", ".toml":
		if data, err = gtoml.ToJson(data); err != nil {
			return nil, err
		}

	case "ini", ".ini":
		if data, err = gini.ToJson(data); err != nil {
			return nil, err
		}

	default:
		err = gerror.NewCodef(gcode.CodeInvalidParameter, `unsupported type "%s" for loading`, dataType)
	}
	if err != nil {
		return nil, err
	}
	decoder := json.NewDecoder(bytes.NewReader(data))
	if options.StrNumber {
		decoder.UseNumber()
	}
	if err := decoder.Decode(&result); err != nil {
		return nil, err
	}
	switch result.(type) {
	case string, []byte:
		return nil, gerror.Newf(`json decoding failed for content: %s`, data)
	}
	return NewWithOptions(result, options), nil
}

// checkDataType automatically checks and returns the data type for `content`.
// Note that it uses regular expression for loose checking, you can use LoadXXX/LoadContentType
// functions to load the content for certain content type.
func checkDataType(content []byte) string {
	if json.Valid(content) {
		return "json"
	} else if gregex.IsMatch(`^<.+>[\S\s]+<.+>\s*$`, content) {
		return "xml"
	} else if !gregex.IsMatch(`[\n\r]*[\s\t\w\-\."]+\s*=\s*"""[\s\S]+"""`, content) &&
		!gregex.IsMatch(`[\n\r]*[\s\t\w\-\."]+\s*=\s*'''[\s\S]+'''`, content) &&
		((gregex.IsMatch(`^[\n\r]*[\w\-\s\t]+\s*:\s*".+"`, content) || gregex.IsMatch(`^[\n\r]*[\w\-\s\t]+\s*:\s*\w+`, content)) ||
			(gregex.IsMatch(`[\n\r]+[\w\-\s\t]+\s*:\s*".+"`, content) || gregex.IsMatch(`[\n\r]+[\w\-\s\t]+\s*:\s*\w+`, content))) {
		return "yml"
	} else if !gregex.IsMatch(`^[\s\t\n\r]*;.+`, content) &&
		!gregex.IsMatch(`[\s\t\n\r]+;.+`, content) &&
		!gregex.IsMatch(`[\n\r]+[\s\t\w\-]+\.[\s\t\w\-]+\s*=\s*.+`, content) &&
		(gregex.IsMatch(`[\n\r]*[\s\t\w\-\."]+\s*=\s*".+"`, content) || gregex.IsMatch(`[\n\r]*[\s\t\w\-\."]+\s*=\s*\w+`, content)) {
		return "toml"
	} else if gregex.IsMatch(`\[[\w\.]+\]`, content) &&
		(gregex.IsMatch(`[\n\r]*[\s\t\w\-\."]+\s*=\s*".+"`, content) || gregex.IsMatch(`[\n\r]*[\s\t\w\-\."]+\s*=\s*\w+`, content)) {
		// Must contain "[xxx]" section.
		return "ini"
	} else {
		return ""
	}
}
