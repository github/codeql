import 'foo'; // $ importTarget=NodeModules/node_modules/foo/index.js
import 'bar'; // $ SPURIOUS: importTarget=NodeModules/subfolder/node_modules/bar/index.js // Technically would not resolve
