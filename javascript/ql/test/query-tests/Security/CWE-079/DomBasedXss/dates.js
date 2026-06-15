import dateFns from 'date-fns';
import dateFnsFp from 'date-fns/fp';
import dateFnsEsm from 'date-fns/esm';
import moment from 'moment';
import dateformat from 'dateformat';

function main() {
    let time = new Date();
    let taint = decodeURIComponent(window.location.hash.substring(1)); // $ Source

    document.body.innerHTML = `Time is ${dateFns.format(time, taint)}`; // $ Alert
    document.body.innerHTML = `Time is ${dateFnsEsm.format(time, taint)}`; // $ Alert
    document.body.innerHTML = `Time is ${dateFnsFp.format(taint)(time)}`; // $ Alert
    document.body.innerHTML = `Time is ${dateFns.format(taint, time)}`; // OK - time arg is safe
    document.body.innerHTML = `Time is ${dateFnsFp.format(time)(taint)}`; // OK - time arg is safe
    document.body.innerHTML = `Time is ${moment(time).format(taint)}`; // $ Alert
    document.body.innerHTML = `Time is ${moment(taint).format()}`;
    document.body.innerHTML = `Time is ${dateformat(time, taint)}`; // $ Alert

    import dayjs from 'dayjs';
    document.body.innerHTML = `Time is ${dayjs(time).format(taint)}`; // $ Alert
}

import LuxonAdapter from "@date-io/luxon";
import DateFnsAdapter from "@date-io/date-fns";
import MomentAdapter from "@date-io/moment";
import DayJSAdapter from "@date-io/dayjs"

function dateio() {
    let taint = decodeURIComponent(window.location.hash.substring(1)); // $ Source

    const dateFns = new DateFnsAdapter();
    const luxon = new LuxonAdapter();
    const moment = new MomentAdapter();
    const dayjs = new DayJSAdapter();

    document.body.innerHTML = `Time is ${dateFns.formatByString(new Date(), taint)}`; // $ Alert
    document.body.innerHTML = `Time is ${luxon.formatByString(luxon.date(), taint)}`; // $ Alert
    document.body.innerHTML = `Time is ${moment.formatByString(moment.date(), taint)}`; // $ Alert
    document.body.innerHTML = `Time is ${dayjs.formatByString(dayjs.date(), taint)}`; // $ Alert
}

import { DateTime } from "luxon";

function luxon() {
    let taint = decodeURIComponent(window.location.hash.substring(1)); // $ Source

    document.body.innerHTML = `Time is ${DateTime.now().plus({years: 1}).toFormat(taint)}`; // $ Alert
    document.body.innerHTML = `Time is ${new DateTime().setLocale('fr').toFormat(taint)}`; // $ Alert
    document.body.innerHTML = `Time is ${DateTime.fromISO("2020-01-01").startOf('day').toFormat(taint)}`; // $ Alert
}

function dateio2() {
    let taint = decodeURIComponent(window.location.hash.substring(1)); // $ Source

    const moment = new MomentAdapter();
    document.body.innerHTML = `Time is ${moment.addDays(moment.date("2020-06-21"), 1).format(taint)}`; // $ Alert
    const luxon = new LuxonAdapter();
    document.body.innerHTML = `Time is ${luxon.endOfDay(luxon.date()).toFormat(taint)}`; // $ Alert
    const dayjs = new DayJSAdapter();
    document.body.innerHTML = `Time is ${dayjs.setHours(dayjs.date(), 4).format(taint)}`; // $ Alert
}