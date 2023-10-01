package help

/*
#cgo pkg-config: libxml-2.0

#include <libxml/tree.h>
#include <libxml/parser.h>
#include <libxml/HTMLtree.h>
#include <libxml/HTMLparser.h>
#include <libxml/xmlsave.h>

void printMemoryLeak() { xmlMemDisplay(stdout); }
*/
import "C"

import (
	"sync"
	"sync/atomic"
)

/**
* With regards to Thread Safety
*
* xmlInitParser and xmlCleanupParser need to be called *once* each during the
* lifetime of the program, regardless of how many documents you parse.
*
* xmlInitParser should be called at the very beginning before doing anything
*   parser related.  Luckly, using the call below, we can guarantee that by
*   making sure it gets called exactly once if anyone uses any gokogiri
*   related functions.
*
* xmlCleanupParser is trickier because it also can only be called once, but it
*   should strictly be called at the very end of program execution, after we're
*   sure that no more documents will be parsed.  If it's ever called, and a new
*   document is parsed, there is a potential for a segfault.
*
* For more information:
*
* http://www.xmlsoft.org/threads.html
* http://www.xmlsoft.org/FAQ.html#Developer (In particular, question #7)
**/

var once sync.Once
var cleaned = new(int32)

func LibxmlInitParser() {
	if called_clean := atomic.LoadInt32(cleaned); called_clean != 0 {
		panic("LibxmlCleanUpParser has been called.  Please make sure you only " +
			"call it if no more document parsing will take place.")
	}
	once.Do(func() { C.xmlInitParser() })
}

func LibxmlCleanUpParser() {
	// Because of our test structure, this method is called several
	// times during a test run (but it should only be called once
	// during the lifetime of the program).
	once.Do(func() {
		atomic.AddInt32(cleaned, 1)
		C.xmlCleanupParser()
	})
}

func LibxmlGetMemoryAllocation() int {
	return (int)(C.xmlMemBlocks())
}

func LibxmlCheckMemoryLeak() bool {
	return (C.xmlMemBlocks() == 0)
}

func LibxmlReportMemoryLeak() {
	C.printMemoryLeak()
}
