const f1 = {
    m() {} // $ method=(pack11).C1.publicField.really.long.name.m
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
} // $ class=(pack11).C1 instance=(pack11).C1.prototype

const f2 = {
    m() {} // $ method=(pack11).C2.publicField.really.long.name.m
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
} // $ class=(pack11).C2 instance=(pack11).C2.prototype

function f3() {} // $ method=(pack11).C3.publicField.really.long.name

export class C3 {
    private static privateField = f3;

    public static publicField = {
        really: {
            long: {
                name: f3
            }
        }
    }
} // $ class=(pack11).C3 instance=(pack11).C3.prototype
