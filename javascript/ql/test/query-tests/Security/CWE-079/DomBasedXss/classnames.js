import classNames from 'classnames';
import classNamesD from 'classnames/dedupe';
import classNamesB from 'classnames/bind';
import clsx from 'clsx';

function main() {
    document.body.innerHTML = `<span class="${classNames(window.name)}">Hello<span>`; // $ Alert
    document.body.innerHTML = `<span class="${classNamesD(window.name)}">Hello<span>`; // $ Alert
    document.body.innerHTML = `<span class="${classNamesB(window.name)}">Hello<span>`; // $ Alert
    let unsafeStyle = classNames.bind({foo: window.name}); // $ Source
    document.body.innerHTML = `<span class="${unsafeStyle('foo')}">Hello<span>`; // $ Alert
    let safeStyle = classNames.bind({});
    document.body.innerHTML = `<span class="${safeStyle(window.name)}">Hello<span>`; // $ Alert
    document.body.innerHTML = `<span class="${safeStyle('foo')}">Hello<span>`;
    document.body.innerHTML = `<span class="${clsx(window.name)}">Hello<span>`; // $ Alert

    document.body.innerHTML += `<span class="${clsx(window.name)}">Hello<span>`; // $ Alert
}
