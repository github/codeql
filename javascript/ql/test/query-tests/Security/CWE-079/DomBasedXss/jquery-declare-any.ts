import 'dummy';

declare var $: any;

function t() {
    $(window.name); // $ MISSING: Alert
}
