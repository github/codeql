import { Client } from "pg";

function submitSomething(client: Client) {
    client.query('SELECT 123');
}
