package main

//go:generate depstubber -vendor github.com/revel/revel Controller,Params,Request,Router HTTP_QUERY

import (
	"io/ioutil"
	"mime/multipart"
	"net/url"

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

func useString(val string) {}

func useFiles(val *multipart.FileHeader) {}

func useJSON(val []byte) {}

func useURLValues(v url.Values) {
	useString(v["key"][0])
	useString(v.Get("key"))
}

func usePerson(p person) {}

func (c myAppController) accessingParamsDirectlyIsUnsafe() {
	useString(c.Params.Get("key")) // NOT OK
	useURLValues(c.Params.Values)  // NOT OK

	val4 := ""
	c.Params.Bind(&val4, "key") // NOT OK
	useString(val4)

	useString(c.Request.FormValue("key")) // NOT OK
}

func (c myAppController) accessingFixedIsSafe(mainRouter *revel.Router) {
	useURLValues(c.Params.Fixed)                          // OK
	useString(mainRouter.Route(c.Request).FixedParams[0]) // OK
}

func (c myAppController) accessingRouteIsUnsafe(mainRouter *revel.Router) {
	useURLValues(c.Params.Route)                     // NOT OK
	useURLValues(mainRouter.Route(c.Request).Params) // NOT OK
}

func (c myAppController) accessingParamsQueryIsUnsafe() {
	useURLValues(c.Params.Query) // NOT OK
}

func (c myAppController) accessingParamsFormIsUnsafe() {
	useURLValues(c.Params.Form)               // NOT OK
	useString(c.Request.PostFormValue("key")) // NOT OK
}

func (c myAppController) accessingParamsFilesIsUnsafe() {
	useFiles(c.Params.Files["key"][0]) // NOT OK
}

func (c myAppController) accessingParamsJSONIsUnsafe() {
	useJSON(c.Params.JSON) // NOT OK

	var val2 map[string]interface{}
	c.Params.BindJSON(&val2) // NOT OK
	useString(val2["name"].(string))
}

func (c myAppController) rawRead() { // $responsebody=argument corresponding to c
	c.ViewArgs["Foo"] = "<p>raw HTML</p>" // $responsebody="<p>raw HTML</p>"
	c.ViewArgs["Bar"] = "<p>not raw HTML</p>"
	c.Render()
}

func accessingRequestDirectlyIsUnsafe(c *revel.Controller) {
	useURLValues(c.Request.GetQuery())               // NOT OK
	useURLValues(c.Request.Form)                     // NOT OK
	useURLValues(c.Request.MultipartForm.Value)      // NOT OK
	useString(c.Request.ContentType)                 // NOT OK
	useString(c.Request.AcceptLanguages[0].Language) // NOT OK
	useString(c.Request.Locale)                      // NOT OK

	form, _ := c.Request.GetForm() // NOT OK
	useURLValues(form)

	smp1, _ := c.Request.GetMultipartForm() // NOT OK
	useURLValues(smp1.GetValues())

	smp2, _ := c.Request.GetMultipartForm() // NOT OK
	useFiles(smp2.GetFiles()["key"][0])

	useFiles(c.Request.MultipartForm.File["key"][0]) // NOT OK

	json, _ := ioutil.ReadAll(c.Request.GetBody()) // NOT OK
	useJSON(json)

	cookie, _ := c.Request.Cookie("abc")
	useString(cookie.GetValue()) // NOT OK

	useString(c.Request.GetHttpHeader("headername")) // NOT OK

	useString(c.Request.GetRequestURI()) // NOT OK

	reader, _ := c.Request.MultipartReader()
	part, _ := reader.NextPart()
	partbody := make([]byte, 100)
	part.Read(partbody)
	useString(string(partbody)) // NOT OK

	useString(c.Request.Referer()) // NOT OK

	useString(c.Request.UserAgent()) // NOT OK
}

func accessingServerRequest(c *revel.Controller) {
	var message string
	c.Request.WebSocket.MessageReceive(&message) // NOT OK
	useString(message)

	var p person
	c.Request.WebSocket.MessageReceiveJSON(&p) // NOT OK
	usePerson(p)
}

func accessingHeaders(c *revel.Controller) {
	tainted := c.Request.Header.Get("somekey") // NOT OK
	useString(tainted)

	tainted2 := c.Request.Header.GetAll("somekey") // NOT OK
	useString(tainted2[0])
}
