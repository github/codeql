import gradio as gr
import os

with gr.Blocks() as demo:
    path = gr.Textbox(label="Path") # $ source=gr.Textbox(..)
    file = gr.Textbox(label="File") # $ source=gr.Textbox(..)
    output = gr.Textbox(label="Output Box")


	# path injection sink
    def fileread(path, file):
        filepath = os.path.join(path, file)
        with open(filepath, "r") as f:
                return f.read()


    # `click` event handler with `inputs` containing a list
    greet1_btn = gr.Button("Path for the file to display")
    greet1_btn.click(fn=fileread, inputs=[path,file], outputs=output, api_name="fileread")


demo.launch()
