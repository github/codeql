#Simple cases

"{name!r}, {0}".format()
"{0}, {1}".format()
"{}, {}".format()

#Complex cases
"<td class={}>{{}}></td>".format(html_class)

"{{0}}{0}".format("X")
"{{{}}}".format("X")

"{ {{ 0} }}".format("X")
"{ { { 0} }}".format("X")
"{{{{{}".format("X")
u'{}\r{}{:<{width}}'.format(1, 2, 3, width=msg_width)
u'{}\r{}{:<{}}'.format(1, 2, 3, 4)
#ODASA 6428
'{x:0.{decimals}f}'.format(x=x, decimals=int(decimals))

"invalid value of type {.__name__}: {}".format(int, 1)
