import '../PackageWithMain'; // $ MISSING: importTarget=PackageWithMain/main.js
import '../PackageWithModuleMain'; // $ MISSING: importTarget=PackageWithModuleMain/main.js
import '../PackageWithExports'; // $ MISSING: importTarget=PackageWithExports/main.js

import '@example/package-with-main'; // $ importTarget=PackageWithMain/main.js
import '@example/package-with-module-main'; // $ importTarget=PackageWithModuleMain/main.js
import '@example/package-with-exports'; // $ importTarget=PackageWithExports/main.js
