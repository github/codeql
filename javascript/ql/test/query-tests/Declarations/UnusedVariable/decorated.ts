import {actionHandler, actionHandlerFactory, actionHandlerFactoryProvider, actionHandlerFactoryProviderKind} from 'somewhere'; // $ TODO-SPURIOUS: Alert - OK - imports used as decorators

@actionHandler
function fun() {} // $ TODO-SPURIOUS: Alert - OK - decorator might use the function

@actionHandlerFactory
class Class {}  // OK - decorator might use the class

@actionHandlerFactoryProvider
export class ExportedClass {} // OK - decorator might use the class

@actionHandlerFactoryProviderKind
enum Enum { plain } // OK - decorator might use the enum
