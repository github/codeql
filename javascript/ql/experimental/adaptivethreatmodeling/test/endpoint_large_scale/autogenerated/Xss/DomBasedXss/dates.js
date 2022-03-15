import dateFns from 'date-fns';
import dateFnsFp from 'date-fns/fp';
import dateFnsEsm from 'date-fns/esm';
import moment from 'moment';
import dateformat from 'dateformat';

function main() {
    let time = new Date();
    let taint = decodeURIComponent(window.location.hash.substring(1));

    document.body.innerHTML = `Time is ${dateFns.format(time, taint)}`; // NOT OK
    document.body.innerHTML = `Time is ${dateFnsEsm.format(time, taint)}`; // NOT OK
    document.body.innerHTML = `Time is ${dateFnsFp.format(taint)(time)}`; // NOT OK
    document.body.innerHTML = `Time is ${dateFns.format(taint, time)}`; // OK - time arg is safe
    document.body.innerHTML = `Time is ${dateFnsFp.format(time)(taint)}`; // OK - time arg is safe
    document.body.innerHTML = `Time is ${moment(time).format(taint)}`; // NOT OK
    document.body.innerHTML = `Time is ${moment(taint).format()}`; // OK
    document.body.innerHTML = `Time is ${dateformat(time, taint)}`; // NOT OK
}
