// Note: The complexities of namespace exports are covered in the Namespaces test folder.
//       This test focuses on lexical scoping for type names.

interface I { where: 'global' }

let x: [I, 'global']
{
  let y: [I, 'global'];
}

function simple() {
  interface I { where: 'simple' }
  var x: [I, 'simple'];
}

function declaredAfter() {
  let x: [I, 'declaredAfter']
  interface I { where: 'declaredAfter' }
}

function innerScopes() {
  interface I { where: 'innerScopes' }
  {
    var x: [I, 'innerScopes']
  }
  {
    let y: [I, 'innerScopes']
  }
  function f() {
    let z: [I, 'innerScopes']
  }
}

function blockScope() {
  {
    interface I { where: 'blockScope' }
    let x: [I, 'blockScope']
  }
  let y: [I, 'global']
}

function paramType(p: [I, 'global']): [I, 'global'] {
  interface I { where: 'dont-use' }
  return null
}

var unresolved: UnresolvedType

var deepType: {
  p: [number, Array<[null | [I, 'global']]>]
} = null;

