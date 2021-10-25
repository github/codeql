import { shell } from 'electron';

function getTaint() {
    return window.name;
}

shell.openExternal(getTaint());
