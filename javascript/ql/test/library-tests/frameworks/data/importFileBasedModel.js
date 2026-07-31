import * as bar from './foo/bar/baz';

function t1() {
    sink(bar.customSource()); // NOT OK
}
