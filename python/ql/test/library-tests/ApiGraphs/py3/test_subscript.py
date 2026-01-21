import mypkg

def test_subscript():
    bar = mypkg.foo()["bar"] #$ use=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()
    mypkg.foo()["baz"] = 42 #$ def=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()
    mypkg.foo()["qux"] += 42 #$ use=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()
    mypkg.foo()["qux"] += 42 #$ def=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()
    mypkg.foo()[mypkg.index] = mypkg.value #$ def=moduleImport("mypkg").getMember("foo").getReturn().getASubscript()

import gradio as gr

def greet(name, surname):
        return "Hello " + name + surname + "!"

with gr.Blocks() as demo:
         name = gr.Textbox(label="Name")
         surname = gr.Textbox(label="Surname")
         output = gr.Textbox(label="Output Box")
         greet_btn = gr.Button("Greet")
         greet_btn.click(fn=greet, inputs=[name, surname], outputs=output, api_name="greet") #$ def=moduleImport("gradio").getMember("Button").getReturn().getMember("click").getKeywordParameter("inputs").getIntSubscript(1)

demo.launch()