package main

//go:generate depstubber -vendor github.com/gin-gonic/gin Context
//go:generate depstubber -vendor github.com/gin-gonic/gin/binding "" YAML

import (
	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
)

func main() {}

type Person struct {
	Name    string `form:"name"`
	Address string `form:"address"`
}

func use(val string) {}

// gin
func ginHandler(ctx *gin.Context) {
	{
		val := ctx.GetHeader("key")
		use(val)
	}
	{
		val := ctx.QueryArray("key")
		use(val[0])
	}
	{
		val := ctx.Query("key")
		use(val)
	}
	{
		val := ctx.PostFormArray("key")
		use(val[0])
	}
	{
		val := ctx.PostForm("key")
		use(val)
	}
	{
		val := ctx.Param("key")
		use(val)
	}
	{
		val := ctx.GetStringSlice("key")
		use(val[0])
	}
	{
		val := ctx.GetString("key")
		use(val)
	}
	{
		val, _ := ctx.GetRawData()
		use(string(val))
	}
	{
		val := ctx.ClientIP()
		use(val)
	}
	{
		val := ctx.ContentType()
		use(val)
	}
	{
		val, _ := ctx.Cookie("key")
		use(val)
	}
	{
		val, _ := ctx.GetQueryArray("key")
		use(val[0])
	}
	{
		val, _ := ctx.GetQuery("key")
		use(val)
	}
	{
		val, _ := ctx.GetPostFormArray("key")
		use(val[0])
	}
	{
		val, _ := ctx.GetPostForm("key")
		use(val)
	}
	{
		val := ctx.DefaultPostForm("key", "default-value")
		use(val)
	}
	{
		val := ctx.DefaultQuery("key", "default-value")
		use(val)
	}
	{
		val, _ := ctx.GetPostFormMap("key")
		use(val["a"])
	}
	{
		val, _ := ctx.GetQueryMap("key")
		use(val["a"])
	}
	{
		val := ctx.GetStringMap("key")
		use(val["a"].(string))
	}
	{
		val := ctx.GetStringMapString("key")
		use(val["a"])
	}
	{
		val := ctx.GetStringMapStringSlice("key")
		use(val["a"][0])
	}
	{
		val := ctx.PostFormMap("key")
		use(val["a"])
	}
	{
		val := ctx.QueryMap("key")
		use(val["a"])
	}
	{
		val := ctx.FullPath()
		use(val)
	}

	// fields:
	{
		val := ctx.Accepted
		use(val[0])
	}
	{
		val := ctx.Params
		use(val[0].Value)
	}

	// Params:
	{
		val := ctx.Params[0]
		use(val.Value)
	}
	{
		val := ctx.Params.ByName("name")
		use(val)
	}
	{
		val, _ := ctx.Params.Get("name")
		use(val)
	}

	// Param:
	{
		param := ctx.Params[0]
		key := param.Key
		val := param.Value
		use(key)
		use(val)
	}

	// bind:
	{
		var person Person
		ctx.BindYAML(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.BindYAML(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.BindXML(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.BindXML(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.BindWith(&person, binding.YAML)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.BindWith(personPointer, binding.YAML)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.BindUri(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.BindUri(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.BindQuery(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.BindQuery(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.MustBindWith(&person, binding.YAML)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.MustBindWith(personPointer, binding.YAML)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.BindJSON(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.BindJSON(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.Bind(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.Bind(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.ShouldBind(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.ShouldBind(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.ShouldBindBodyWith(&person, binding.YAML)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.ShouldBindBodyWith(personPointer, binding.YAML)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.ShouldBindJSON(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.ShouldBindJSON(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.ShouldBindQuery(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.ShouldBindQuery(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.ShouldBindUri(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.ShouldBindUri(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.ShouldBindWith(&person, binding.YAML)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.ShouldBindWith(personPointer, binding.YAML)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.ShouldBindXML(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.ShouldBindXML(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.ShouldBindYAML(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.ShouldBindYAML(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.BindHeader(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.BindHeader(personPointer)
		use(personPointer.Name)
	}
	{
		var person Person
		ctx.ShouldBindHeader(&person)
		use(person.Name)
	}
	{
		var personPointer *Person
		ctx.ShouldBindHeader(personPointer)
		use(personPointer.Name)
	}
}
