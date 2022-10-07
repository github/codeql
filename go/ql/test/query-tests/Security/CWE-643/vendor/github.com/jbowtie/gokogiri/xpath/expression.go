package xpath

/*
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>
#include <string.h>

void check_xpath_syntax_noop(void *ctx, const char *fmt, ...) {
}

char *check_xpath_syntax(const char *xpath) {
	xmlGenericErrorFunc err_func = check_xpath_syntax_noop;
	initGenericErrorDefaultFunc(&err_func);
	xmlResetLastError();
	xmlXPathCompile((const xmlChar *)xpath);
	xmlErrorPtr err = xmlGetLastError();
	if (err != NULL) {
		if (err->code == XML_XPATH_EXPR_ERROR) {
			// TODO: Not the cleanest but should scale well
			int size = strlen(err->message) + strlen(err->str1) + err->int1 + 16;
			char *msg = malloc(size);
			sprintf(msg, "%s%s\n%*s^", err->message, err->str1, err->int1, " ");
			return msg;
		} else {
			char *msg = malloc(strlen(err->message));
			sprintf(msg, "%s", err->message);
			return msg;
		}
	}
	return NULL;
}
*/
import "C"
import "unsafe"
import . "github.com/jbowtie/gokogiri/util"

//import "runtime"
import "errors"

type Expression struct {
	Ptr   *C.xmlXPathCompExpr
	xpath string
}

func Check(path string) (err error) {
	str := C.CString(path)
	defer C.free(unsafe.Pointer(str))
	cstr := C.check_xpath_syntax(str)
	if cstr != nil {
		defer C.free(unsafe.Pointer(cstr))
		err = errors.New(C.GoString(cstr))
	}
	return
}

func Compile(path string) (expr *Expression) {
	if len(path) == 0 {
		return
	}

	xpathBytes := GetCString([]byte(path))
	xpathPtr := unsafe.Pointer(&xpathBytes[0])
	ptr := C.xmlXPathCompile((*C.xmlChar)(xpathPtr))
	if ptr == nil {
		return
	}
	expr = &Expression{Ptr: ptr, xpath: path}
	//runtime.SetFinalizer(expr, (*Expression).Free)
	return
}

func (exp *Expression) String() string {
	return exp.xpath
}

func (exp *Expression) Free() {
	if exp.Ptr != nil {
		C.xmlXPathFreeCompExpr(exp.Ptr)
		exp.Ptr = nil
	}
}
