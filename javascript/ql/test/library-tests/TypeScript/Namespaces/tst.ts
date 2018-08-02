// Every variable must have exactly one assignment, 
// and its RHS must be a string unique to that variable.

// The test query checks every calls of form `resolve(var, "xxx")` and
// ensures that var resolves to a variable whose assignment RHS is "xxx".
 
// The test can be compiled with TypeScript and run in node.js to check
// that the test itself is correct. 

function resolve(x, expected) { // Special function recognised by test query
  if (x !== expected) {
    console.error('Variable resolved to: ' + x + ', not ' + expected);
  }
}

var x = 'global.x', y = 'global.y', z = 'global.z'

namespace LocalScope {
  let x = 'LocalScope.x'
  resolve(x, 'LocalScope.x')
}
namespace LocalScope {
  resolve(x, 'global.x') // 'x' was not exported, so it is not shared
}

// Assigning to an undeclared variable does not bring it into scope
namespace N {
  undeclaredVariable = 'global.undeclaredVariable'
  resolve(undeclaredVariable, 'global.undeclaredVariable')
}

// Test lexical shadowing
namespace Outer {
  let x = 'Outer.x'
  
  export namespace Inner {
    let y = 'Outer.Inner.y'
    resolve(x, 'Outer.x')
    resolve(y, 'Outer.Inner.y')
  }
  
  let z = 'Outer.z';
  
  resolve(x, 'Outer.x')
  resolve(y, 'global.y')
  resolve(z, 'Outer.z')
}

// Test exports shared between namespace declarations
innerShared = 'global.innerShared'
badExport = 'global.badExport'
outerShared = 'global.outerShared'
innerShared = 'global.innerShared'
shadowed = 'global.shadowed'

namespace Shared {
  export let outerShared = 'Shared.outerShared'
  export let shadowed = 'Shared.shadowed'
  
  export namespace Inner {
    export let innerShared = 'Shared.Inner.innerShared'
    export let shadowed = 'Shared.Inner.shadowed'
    export let y = 'Shared.Inner.y'
    
    resolve(outerShared, 'Shared.outerShared')
    resolve(innerShared, 'Shared.Inner.innerShared')
    resolve(shadowed, 'Shared.Inner.shadowed')
    resolve(y, 'Shared.Inner.y') // Should not clash with 'Outer.Inner'
  }
  
  resolve(outerShared, 'Shared.outerShared')
  resolve(innerShared, 'global.innerShared')
  resolve(shadowed, 'Shared.shadowed')
  
  namespace NotExported { // Note: namespace is not exported
    export let badExport = 'Shared.<NotExported>.badExport'
  }
}

namespace Shared {
  resolve(outerShared, 'Shared.outerShared')
  resolve(innerShared, 'global.innerShared')
  resolve(shadowed, 'Shared.shadowed')
}

namespace Shared.Inner {
  resolve(outerShared, 'Shared.outerShared')
  resolve(innerShared, 'Shared.Inner.innerShared')
  resolve(shadowed, 'Shared.Inner.shadowed')
}

namespace Shared.NotExported {
  resolve(badExport, 'global.badExport') // Not seen because the namespace was not exported
}

// Test uninstantiated namespaces
namespace TestUninstantiated {
  namespace x {}
  namespace y { "TestUninstantiated.y" }
  resolve(x, 'global.x')
  resolve(y, "TestUninstantiated.y")
}

// Interfaces should not affect resolution of variables.
namespace Interfaces {
  interface x {}
  export interface y {}
  resolve(x, 'global.x')
  resolve(y, 'global.y')
}
