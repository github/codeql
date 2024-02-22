export class D {} // $ class=(pack7).D instance=(pack7).D.prototype

// In this case we are forced to include ".default" to avoid ambiguity with class D above.
export default {
    D: class {} // $ class=(pack7).default.D instance=(pack7).default.D.prototype
};
