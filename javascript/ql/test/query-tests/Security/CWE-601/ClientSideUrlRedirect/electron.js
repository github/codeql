import { shell } from 'electron';

function getTaint() {
    return window.name; // $ Source
}

shell.openExternal(getTaint()); // $ Alert
