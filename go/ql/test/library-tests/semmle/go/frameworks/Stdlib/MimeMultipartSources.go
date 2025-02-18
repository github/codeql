package main

import "mime/multipart"

func MimeMultipartSources(fh *multipart.FileHeader, form *multipart.Form) {
	tainted1, _ := fh.Open()
	sink(tainted1)    // $ hasValueFlow="tainted1"
	sink(fh.Filename) // $ hasValueFlow="selection of Filename"
	sink(fh.Header)   // $ hasValueFlow="selection of Header"
	sink(form.Value)  // $ hasValueFlow="selection of Value"
}
