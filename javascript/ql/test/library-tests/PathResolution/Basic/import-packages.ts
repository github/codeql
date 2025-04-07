import '../PackageWithMain'; // $ importTarget=PackageWithMain/main.js
import '../PackageWithModuleMain'; // $ importTarget=PackageWithModuleMain/main.js
import '../PackageWithExports'; // Not a valid import

import '@example/package-with-main'; // $ importTarget=PackageWithMain/main.js
import '@example/package-with-module-main'; // $ importTarget=PackageWithModuleMain/main.js
import '@example/package-with-exports'; // $ importTarget=PackageWithExports/main.js

import '../PackageWithExports/fake-file'; // Not a valid import
import '@example/package-with-exports/fake-file'; // $ importTarget=PackageWithExports/fake-file-impl.js
