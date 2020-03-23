class C { 
    #privateField: any;

    constructor(x: any) {
        this.#privateField = x;
        this.#privateField(y);
    }
}
