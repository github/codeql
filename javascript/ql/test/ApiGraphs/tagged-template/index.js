const tag = require("tag");

tag.string`string1
${23}` // def=moduleImport("tag").getMember("exports").getMember("string").getParameter(1)

tag.highlight`string2
${23}
morestring
${42}` // def=moduleImport("tag").getMember("exports").getMember("highlight").getParameter(2)