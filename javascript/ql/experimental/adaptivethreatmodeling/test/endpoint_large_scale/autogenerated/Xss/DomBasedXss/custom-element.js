import * as dummy from 'dummy';

class CustomElm extends HTMLElement {
    test() {
        this.innerHTML = window.name; // NOT OK
    }
}
