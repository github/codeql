const obj = {
    // Template where we can't parse `x x x` but surrounding file still OK
    template: '<b [foo]="x x x"></a>'
};
