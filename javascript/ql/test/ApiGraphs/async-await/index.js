const fs = require('fs-extra');

module.exports.foo = async function foo() {
    return await fs.copy('/tmp/myfile', '/tmp/mynewfile'); /* use=moduleImport("fs-extra").getMember("exports").getMember("copy").getReturn().getPromised()*/ /* def=moduleImport("async-await").getMember("exports").getMember("foo").getReturn().getPromised() */
};
