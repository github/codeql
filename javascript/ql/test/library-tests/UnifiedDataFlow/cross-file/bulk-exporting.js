export * from './file2.js';

export * as file2 from './file2.js';

export function foo() {
    return source('shadowing.foo');
}
