package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
)

// A utility program for generating `project` and `variable` files for SemmleCore Go projects
//
// This program should not normally be run directly; it is usually executed as part of
// `odasa bootstrap`, and expects two files as arguments: a (partial) `variables` file and
// an empty file to be filled in with an `<autoupdate>` element containing build steps.
//
// The `variables` file is extended with a definition of `LGTM_SRC` and, if it defines the
// `repository` variable, `SEMMLE_REPO_URL`. The only build step is an invocation of the
// Go autobuilder.
func main() {
	vars := os.Args[1]
	buildSteps := os.Args[2]

	haveRepo := false
	content, err := ioutil.ReadFile(vars)
	if err != nil {
		log.Fatal(err)
	}
	re := regexp.MustCompile(`(^|\n)repository=`)
	haveRepo = re.Find(content) != nil

	additionalVars := "LGTM_SRC=${src}\n"
	if haveRepo {
		additionalVars += "SEMMLE_REPO_URL=${repository}\n"
	}
	content = append(content, []byte(additionalVars)...)
	err = ioutil.WriteFile(vars, content, 0644)
	if err != nil {
		log.Fatal(err)
	}

	export := "LGTM_SRC"
	if haveRepo {
		export += ",SEMMLE_REPO_URL"
	}
	content = []byte(fmt.Sprintf(`<autoupdate>
  <build export="%s">${semmle_dist}/language-packs/go/tools/platform/${semmle_platform}/bin/go-autobuilder</build>
</autoupdate>
`, export))
	err = ioutil.WriteFile(buildSteps, content, 0644)
	if err != nil {
		log.Fatal(err)
	}
}
