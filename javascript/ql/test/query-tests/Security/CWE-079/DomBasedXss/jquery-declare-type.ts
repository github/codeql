import 'dummy';

declare var $: JQueryStatic;

function t() {
    $(window.name); // $ MISSING: Alert
}
