export function tstModuleCJS(): 'a' | 'b' {
    return Math.random() > 0.5 ? 'a' : 'b';
}
