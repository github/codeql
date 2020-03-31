var obj = {
    x: 4,
    func: function() {
      return 42;
    },
    f() {
      return 23;
    }
}

class C {
  static func(x) {
    console.log(x);
  }
  f(x) {
    console.log(x);
  }
}

C.prop = 56;

const click = this.someMethod.bind(this);
return <div onClick={click}>Hello {this.state.name}</div>;

({
  get x() { return null; },
  set y(v) {}
});

({
    n: 1,
    [v]: 2,
    [vv.pp]: 3,
    [vvv.ppp.qqq]: 4
});

var arr1 = ["a", "b", "c"],
    arr2 = ["a", , "c"],
    arr3 = [, "b", "c"],
    arr4 = ["a", "b",],
    arr5 = ["a", ...arr3, "d"];

for (var p in obj)
  console.log(obj[p]);

  function test(array) {
    let [x, y, z] = array;
  }
  