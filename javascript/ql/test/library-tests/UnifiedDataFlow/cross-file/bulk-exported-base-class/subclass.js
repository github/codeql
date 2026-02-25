import { Base } from './base-class-re-export';

class Subclass extends Base {}

sink(new Subclass().foo()); // $ hasValueFlow=Base.foo
