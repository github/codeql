import { actionHandlerFactory, actionHandlerFactoryProvider } from 'somewhere'; // OK - imports used as decorators

@actionHandlerFactory
class Class { }  // OK - decorator might use the class

@actionHandlerFactoryProvider
export class ExportedClass { } // OK - decorator might use the class
