import * as lib from "upstream-lib";

export { lib };

export const x = lib.x;
export const xy = lib.x.y;

export function func() {
    return lib;
}
