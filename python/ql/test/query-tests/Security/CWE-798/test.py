

HOST = "acme-trading.com"
PORT = 8000
USERNAME = "road_runner"
PASSWORD = "insecure_pwd"


def sell(client, units):

    conn = client.connect(
        host=HOST,
        port=PORT,
        username=USERNAME,
        password=PASSWORD)

    conn.cmd("sell", 1000)
    conn.close()

