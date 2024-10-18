declare function source(): any;
declare function sink(taint: any): any;


interface Thing {
    do(s: string): void;
}

class ThingImpl implements Thing {
    do(s: string): void {
        sink(s);
    }
}

class ThingDoer {
    thing: Thing;
    doThing(s: string): void {
        this.thing.do(s);
    }
}

export function run(doer: ThingDoer): void {
    doer.doThing(source());
}
 