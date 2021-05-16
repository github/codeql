const lib = require("./lib");

describe("lib", () => {
    it("should work", () => {
        const obj = Object.create(null);

        lib.usedInTest(obj, "foo", "my-value");
    });
});