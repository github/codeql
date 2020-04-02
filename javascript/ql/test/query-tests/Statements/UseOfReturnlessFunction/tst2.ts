declare function returnsVoid() : void;
declare function returnsSomething(): number;

console.log(returnsSomething());

console.log(returnsVoid()); // NOT OK!