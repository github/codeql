import packageA.*;

import packageA.Subclass;
import packageA.Subclass.Inner;
import packageA.Subinterface;

import packageA.Subclass.*;
import packageA.Subclass.Inner.*;
import packageA.Subinterface.*;

import static packageA.Subclass.StaticNested;
import static packageA.Subclass.STATIC_FIELD;
import static packageA.Subclass.staticMethod;
import static packageA.Subclass.nameClash;

import static packageA.Subinterface.StaticNested;
import static packageA.Subinterface.STATIC_FIELD;
import static packageA.Superinterface.staticMethod;
import static packageA.Subinterface.nameClash;

import static packageA.Subclass.*;
// Apparently 'import static member' can import from inheriting class Subclass: `packageA.Subclass.StaticNested`,
// but 'on demand' (wildcard) import here must use name of declaring type Superclass?
import static packageA.Superclass.StaticNested.*;
import static packageA.Subinterface.*;

class Test {}
