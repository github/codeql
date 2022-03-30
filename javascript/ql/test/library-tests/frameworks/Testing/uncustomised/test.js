// a QUnit test
QUnit.test( "hello test", function( assert ) {
  assert.ok( 1 == "1", "Passed!" );
});

// a Jasmine test
describe("A " + "suite", function() {
  it("contains spec with an expectation", function() {
    expect(true).toBe(true);
  });
});

// not recognised as test without further customisation
mytest("A custom test", function(assert) {
  assert.ok(true);
});

// not tests
it();
it("hi");
it("hi", 23);
