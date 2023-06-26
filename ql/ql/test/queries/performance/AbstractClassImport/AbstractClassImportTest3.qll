import ql
import AbstractClassImportTest1

class Sub31 extends Base {
  Sub31() { this instanceof Comment }
}

class Sub32 extends Base instanceof Comment { }

final class BaseFinal = Base;

class Sub33 extends BaseFinal instanceof Comment { }

abstract class Sub34 extends Base { }

final class Sub34Final = Sub34;

class Sub35 extends Sub34Final instanceof Comment { }
