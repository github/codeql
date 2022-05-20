var t;

class A {}

class c1 {};
class c2 { f() {} }
class c3 { x = 5; f() {} }
class c4 { static x = 5; f() {} }
class c5 { static x = 5; f() {} constructor() {} }

class c6 extends A {};
class c7 extends A { f() {} }
class c8 extends A { x = 5; f() {} }
class c9 extends A { static x = 5; f() {} }
class c10 extends A { static x = 5; f() {} constructor() {} }

t = class c {};
t = class c { f() {} }
t = class c { x = 5; f() {} }
t = class c { static x = 5; f() {} }
t = class c { static x = 5; f() {} constructor() {} }

t = class c extends A {};
t = class c extends A { f() {} }
t = class c extends A { x = 5; f() {} }
t = class c extends A { static x = 5; f() {} }
t = class c extends A { static x = 5; f() {} constructor() {} }

t = class {};
t = class { f() {} }
t = class { x = 5; f() {} }
t = class { static x = 5; f() {} }
t = class { static x = 5; f() {} constructor() {} }

t = class extends A {};
t = class extends A { f() {} }
t = class extends A { x = 5; f() {} }
t = class extends A { static x = 5; f() {} }
t = class extends A { static x = 5; f() {} constructor() {} }
