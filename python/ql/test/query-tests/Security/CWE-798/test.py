

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


# Ignored
test(password='short')
test(password='Capitalized')
test(password='  whitespace') # too much whitespace
test(password='insecure__') # too many underscores
test(password='aaaaaaaaaa') # too repetitive
test(password='format_string_{}')

# TODO: we think this is a format string :\
test(password='''U]E8FPETCS_]{,y>bgyzh^$yC5>SP{E*2=`;3]G~k&+;khy3}4]jdpu;D(aP$SCFA{;hh4n46pUJ%+$nEP_gqNq#X!2$%*C-6y6%''')
