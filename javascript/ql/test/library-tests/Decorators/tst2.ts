declare var A : any;
declare var B : any;
declare var C : any;

class C {
  m1(none) {}
  m2(@A a) {}
  m3(@A @B ab) {}
  
  m4(none, @A a) {}
  m5(none, @A @B ab) {}
  
  m6(@A a, @B b) {}
  m7(@A a, @B @C bc) {}
}

