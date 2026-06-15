const f1 = {
    m() {} // $ name=(pack11).C1.publicField.really.long.name.m
};

export class C1 {
    private static privateField = f1;

    public static publicField = {
        really: {
            long: {
                name: f1
            }
        }
    }
} // $ name=(pack11).C1

const f2 = {
    m() {} // $ name=(pack11).C2.publicField.really.long.name.m
}

export class C2 {
    static #privateField = f2;

    static publicField = {
        really: {
            long: {
                name: f2
            }
        }
    }
} // $ name=(pack11).C2

function f3() {} // $ name=(pack11).C3.publicField.really.long.name

export class C3 {
    private static privateField = f3;

    public static publicField = {
        really: {
            long: {
                name: f3
            }
        }
    }
} // $ name=(pack11).C3


const f4 = {
    m() {} // $ name=(pack11).C4.really.long.name.m
};

export const C4 = {
    [Math.random()]: f4,
    really: {
        long: {
            name: f4
        }
    }
}
