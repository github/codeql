import dateFns from 'date-fns';
import dateFnsFp from 'date-fns/fp';
import dateFnsUtc from 'date-fns/utc';
import moment from 'moment';

function main() {
    let time = new Date();
    let taint = decodeURIComponent(window.location.hash.substring(1));

    document.body.innerHTML = `Time is ${dateFns.format(time, taint)}`; // NOT OK
    document.body.innerHTML = `Time is ${dateFnsUtc.format(time, taint)}`; // NOT OK
    document.body.innerHTML = `Time is ${dateFnsFp.format(taint)(time)}`; // NOT OK
    document.body.innerHTML = `Time is ${dateFns.format(taint, time)}`; // OK - time arg is safe
    document.body.innerHTML = `Time is ${dateFnsFp.format(time)(taint)}`; // OK - time arg is safe
    document.body.innerHTML = `Time is ${moment(time).format(taint)}`; // NOT OK
    document.body.innerHTML = `Time is ${moment(taint).format()}`; // OK
}
