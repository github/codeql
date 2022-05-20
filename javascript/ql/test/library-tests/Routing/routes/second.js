export default function second(req, res) {
    sink(req.tainted); // NOT OK
    sink(req.safe); // OK
}
