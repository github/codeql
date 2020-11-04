import classNames from 'classnames';
import classNamesD from 'classnames/dedupe';
import classNamesB from 'classnames/bind';
import clsx from 'clsx';

function main() {
    document.body.innerHTML = `<span class="${classNames(window.name)}">Hello<span>`; // NOT OK
    document.body.innerHTML = `<span class="${classNamesD(window.name)}">Hello<span>`; // NOT OK
    document.body.innerHTML = `<span class="${classNamesB(window.name)}">Hello<span>`; // NOT OK
    let unsafeStyle = classNames.bind({foo: window.name});
    document.body.innerHTML = `<span class="${unsafeStyle('foo')}">Hello<span>`; // NOT OK
    let safeStyle = classNames.bind({});
    document.body.innerHTML = `<span class="${safeStyle(window.name)}">Hello<span>`; // NOT OK
    document.body.innerHTML = `<span class="${safeStyle('foo')}">Hello<span>`; // OK
    document.body.innerHTML = `<span class="${clsx(window.name)}">Hello<span>`; // NOT OK
}
