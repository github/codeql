// Based on snippets in https://devblogs.microsoft.com/typescript/announcing-typescript-4-1-beta/

type World = "world";
type Greeting = `hello ${World}`;


type Color = "red" | "blue";
type Quantity = "one" | "two";
type SeussFish = `${Quantity | Color} fish`;


type VerticalAlignment = "top" | "middle" | "bottom";
type HorizontalAlignment = "left" | "center" | "right";
declare function setAlignment(value: `${VerticalAlignment}-${HorizontalAlignment}`): void;


type PropEventSource<T> = {
    on<K extends string & keyof T>(eventName: `${K}Changed`, callback: (newValue: T[K]) => void ): void;
};

declare function makeWatchedObject<T>(obj: T): T & PropEventSource<T>;

let person = makeWatchedObject({
    firstName: "Homer",
    age: 42,
    location: "Springfield",
});


// Can no longer be parsed by TypeScript:
// type EnthusiasticGreeting<T extends string> = `${uppercase T}`

type HELLO = EnthusiasticGreeting<"hello">;

// Can no longer be parsed by TypeScript:
// type Getters<T> = {
//     [K in keyof T as `get${capitalize K}`]: () => T[K]
// };

interface Person {
    name: string;
    age: number;
    location: string;
}

type LazyPerson = Getters<Person>;

type RemoveKindField<T> = {
    [K in keyof T as Exclude<K, "kind">]: T[K]
};

interface Circle {
    kind: "circle";
    radius: number;
}

type KindlessCircle = RemoveKindField<Circle>;
