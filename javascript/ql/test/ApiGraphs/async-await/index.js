const fs = require('fs-extra');

module.exports.foo = async function foo() {
    return await fs.copy('/tmp/myfile', '/tmp/mynewfile'); /* use (promised (return (member copy (member exports (module fs-extra))))) */ /* def (promised (return (member foo (member exports (module async-await))))) */
};
