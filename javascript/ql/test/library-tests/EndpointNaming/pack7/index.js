export class D {} // $ name=(pack7).D

// In this case we are forced to include ".default" to avoid ambiguity with class D above.
export default {
    D: class {} // $ name=(pack7).default.D
};
