import './PackageWithMain/main'; // $ importTarget=PackageWithMain/main.js
import '@example/package-with-main'; // $ importTarget=PackageWithMain/main.js

import './PackageWithModuleMain'; // $ MISSING: importTarget=PackageWithModuleMain/main.js
import '@example/package-with-module-main'; // $ importTarget=PackageWithModuleMain/main.js

import './PackageWithExports'; // Not a valid import
import './PackageWithExports/fake-file'; // Not a valid import
import './PackageWithExports/star/foo'; // Not a valid import
import '@example/package-with-exports'; // $ importTarget=PackageWithExports/main.js
import '@example/package-with-exports/fake-file'; // $ MISSING: importTarget=PackageWithExports/fake-file-impl.js
import '@example/package-with-exports/star/foo'; // $ MISSING: importTarget=PackageWithExports/star-impl/foo.js

import './PackageIndexFile'; // $ importTarget=PackageIndexFile/index.js
import '@example/package-with-index-file'; // $ importTarget=PackageIndexFile/index.js

import './PackageGuess1'; // $ MISSING: importTarget=PackageGuess1/src/index.ts
import '@example/package-guess1'; // $ importTarget=PackageGuess1/src/index.ts

import './PackageGuess2'; // $ MISSING: importTarget=PackageGuess2/blah/stuff.ts
import '@example/package-guess2'; // $ importTarget=PackageGuess2/blah/stuff.ts

import './PackageWithMainExt'; // $ importTarget=PackageWithMainExt/lib/main.ts
import '@example/package-with-main-ext'; // $ importTarget=PackageWithMainExt/lib/main.ts

import './TSConfigOutDir/customOutDir/foo.js'; // $ importTarget=TSConfigOutDir/src/foo.ts

import './MainIsFolder'; // $ MISSING: importTarget=MainIsFolder/src/index.ts
import '@example/main-is-folder'; // $ importTarget=MainIsFolder/src/index.ts

import './DistContainsSrc'; // $ MISSING: importTarget=DistContainsSrc/src/foo.ts

import './MinifiedMain'; // $ MISSING: importTarget=MinifiedMain/src/library.ts

import './RootDir/my-out/foo.js'; // $ importTarget=RootDir/my-root/foo.ts
