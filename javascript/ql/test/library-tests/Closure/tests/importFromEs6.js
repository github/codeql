// ES6 imports can import files by name, as long as they are modules

import * as googModule from './googModule';
import * as googModuleDefault from './googModuleDefault';

import * as es6Module from './es6Module';
import * as es6ModuleDefault from './es6ModuleDefault';

es6Module.fun();
es6ModuleDefault();

googModule.fun();
googModuleDefault();
