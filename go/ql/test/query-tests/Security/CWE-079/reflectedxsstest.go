package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

func encode(s string) ([]byte, error) {
	return json.Marshal(s)
}

func ServeJsonIndirect(w http.ResponseWriter, r http.Request) {
	tainted := r.Header.Get("Origin")
	noLongerTainted, _ := encode(tainted)
	w.Write(noLongerTainted)
}

func ServeJsonDirect(w http.ResponseWriter, r http.Request) {
	tainted := r.Header.Get("Origin")
	noLongerTainted, _ := json.Marshal(tainted)
	w.Write(noLongerTainted)
}

func ErrTest(w http.ResponseWriter, r http.Request) {
	cookie, err := r.Cookie("somecookie")
	w.Write([]byte(fmt.Sprintf("Cookie result: %v", cookie)))   // BAD: Cookie's value is user-controlled
	w.Write([]byte(fmt.Sprintf("Cookie check error: %v", err))) // GOOD: Cookie's err return is harmless

	file, header, err := r.FormFile("someFile")
	content, err2 := ioutil.ReadAll(file)
	w.Write([]byte(fmt.Sprintf("File content: %v", content)))      // BAD: file content is user-controlled
	w.Write([]byte(fmt.Sprintf("File name: %v", header.Filename))) // BAD: file header is user-controlled
	w.Write([]byte(fmt.Sprintf("FormFile error: %v", err)))        // GOOD: FormFile's err return is harmless
	w.Write([]byte(fmt.Sprintf("FormFile error: %v", err2)))       // GOOD: ReadAll's err return is harmless

	reader, err := r.MultipartReader()
	part, err2 := reader.NextPart()
	partName := part.FileName()
	byteSlice := make([]byte, 100)
	part.Read(byteSlice)

	w.Write([]byte(fmt.Sprintf("Part name: %v", partName)))         // BAD: part name is user-controlled
	w.Write(byteSlice)                                              // BAD: part contents are user-controlled
	w.Write([]byte(fmt.Sprintf("MultipartReader error: %v", err)))  // GOOD: MultipartReader's err return is harmless
	w.Write([]byte(fmt.Sprintf("MultipartReader error: %v", err2))) // GOOD: NextPart's err return is harmless
}

func QueryMapTest(w http.ResponseWriter, r http.Request) {
	keys, ok := r.URL.Query()["data_id"]
	if ok && len(keys[0]) > 0 {
		key := keys[0]
		w.Write([]byte(key)) // BAD: query string is user-controlled
	}
}
