var x = 'global.x', y = 'global.y', z = 'global.z', w = 'global.w';

function resolveGlobal(arg) {
  if (typeof arg === 'undefined') {
    console.error('Variable resolved to an ambient declaration, but should resolve to a global')
  }
}

function resolveAmbient(arg) {
  if (typeof arg !== 'undefined') {
    console.error('Variable resolved to ' + arg + ', but should resolve to an ambient declaration');
  }
}

// Ambient declarations should not interfere with name binding
namespace Ambients {
  declare var x: string;
  declare class y {}
  declare namespace z { export let instantiate; }
  declare function w();
  
  resolveGlobal(x);
  resolveGlobal(y);
  resolveGlobal(z);
  resolveGlobal(w);
}

// Ambient variable declarations that are exported *should* affect name binding,
// because TypeScript will rewrite their accesses to property accesses.
//
// For some arcane reason, classes, namespaces, and functions do not have this effect.
namespace ExportedAmbients {
  export declare var x: number;
  export declare class y {}
  export declare namespace z { export let instantiate; }
  export declare function w();
  
  resolveAmbient(x);
  resolveGlobal(y);
  resolveGlobal(z);
  resolveGlobal(w);
}

// Uninstantiated ambient exported namespaces should not interfere with name binding,
// despite being exported, even if the above behavior changes.
namespace UninstantiatedExportedAmbient {
  export declare namespace x {}
  
  resolveGlobal(x)
}
