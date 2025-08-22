package main

//go:generate depstubber -vendor github.com/revel/revel Controller,Params,Request,Router HTTP_QUERY

import (
	"io/ioutil"

	"github.com/revel/revel"
)

func main() {}

type myAppController struct {
	*revel.Controller
	OtherStuff string
}

type person struct {
	Name    string `form:"name"`
	Address string `form:"address"`
}

func sink(_ ...interface{}) {}

func (c myAppController) accessingParamsDirectlyIsUnsafe() {
	sink(c.Params.Get("key"))
	sink(c.Params.Values)

	val4 := ""
	c.Params.Bind(&val4, "key")
	sink(val4)

	sink(c.Request.FormValue("key"))
}

func (c myAppController) accessingFixedIsSafe(mainRouter *revel.Router) {
	sink(c.Params.Fixed.Get("key"))                  // $ noflow
	sink(mainRouter.Route(c.Request).FixedParams[0]) // $ noflow
}

func (c myAppController) accessingRouteIsUnsafe(mainRouter *revel.Router) {
	sink(c.Params.Route["key"][0])
	sink(mainRouter.Route(c.Request).Params["key"][0])
}

func (c myAppController) accessingParamsQueryIsUnsafe() {
	sink(c.Params.Query["key"][0])
}

func (c myAppController) accessingParamsFormIsUnsafe() {
	sink(c.Params.Form["key"][0])
	sink(c.Request.PostFormValue("key"))
}

func (c myAppController) accessingParamsFilesIsUnsafe() {
	sink(c.Params.Files["key"][0])
}

func (c myAppController) accessingParamsJSONIsUnsafe() {
	sink(c.Params.JSON)

	var val2 map[string]interface{}
	c.Params.BindJSON(&val2)
	sink(val2["name"].(string))
}

func (c myAppController) rawRead() { // $ responsebody='argument corresponding to c'
	c.ViewArgs["Foo"] = "<p>raw HTML</p>" // $ responsebody='"<p>raw HTML</p>"'
	c.ViewArgs["Bar"] = "<p>not raw HTML</p>"
	c.ViewArgs["Foo"] = c.Params.Query // $ responsebody='selection of Query'
	c.Render()
}

func accessingRequestDirectlyIsUnsafe(c *revel.Controller) {
	sink(c.Request.GetQuery()["key"][0])
	sink(c.Request.Form["key"][0])
	sink(c.Request.MultipartForm.Value["key"][0])
	sink(c.Request.ContentType)
	sink(c.Request.AcceptLanguages[0].Language)
	sink(c.Request.Locale)

	form, _ := c.Request.GetForm()
	sink(form["key"][0])

	smp1, _ := c.Request.GetMultipartForm()
	sink(smp1.GetValues()["key"][0])

	smp2, _ := c.Request.GetMultipartForm()
	sink(smp2.GetFiles()["key"][0])

	sink(c.Request.MultipartForm.File["key"][0])

	json, _ := ioutil.ReadAll(c.Request.GetBody())
	sink(json)

	cookie, _ := c.Request.Cookie("abc")
	sink(cookie.GetValue())

	sink(c.Request.GetHttpHeader("headername"))

	sink(c.Request.GetRequestURI())

	reader, _ := c.Request.MultipartReader()
	part, _ := reader.NextPart()
	partbody := make([]byte, 100)
	part.Read(partbody)
	sink(string(partbody))

	sink(c.Request.Referer())

	sink(c.Request.UserAgent())
}

func accessingServerRequest(c *revel.Controller) {
	var message string
	c.Request.WebSocket.MessageReceive(&message)
	sink(message)

	var p person
	c.Request.WebSocket.MessageReceiveJSON(&p)
	sink(p)
}

func accessingHeaders(c *revel.Controller) {
	tainted := c.Request.Header.Get("somekey")
	sink(tainted)

	tainted2 := c.Request.Header.GetAll("somekey")
	sink(tainted2[0])
}

func headerMutators(c *revel.Controller) {
	tainted := c.Request.UserAgent()

	var cleanHeaders revel.RevelHeader
	cleanHeaders.Set(tainted, "clean")
	sink(cleanHeaders.Get("clean"))

	var cleanHeaders2 revel.RevelHeader
	cleanHeaders2.Set("clean", tainted)
	sink(cleanHeaders2.Get("clean"))

	var cleanHeaders3 revel.RevelHeader
	cleanHeaders3.Add(tainted, "clean")
	sink(cleanHeaders3.Get("clean"))

	var cleanHeaders4 revel.RevelHeader
	cleanHeaders4.Add("clean", tainted)
	sink(cleanHeaders4.Get("clean"))

	var cleanHeaders5 revel.RevelHeader
	cleanHeaders5.SetCookie(tainted)
	sink(cleanHeaders5.Get("clean"))
}
