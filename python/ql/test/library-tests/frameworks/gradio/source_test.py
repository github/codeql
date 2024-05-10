import gradio as gr


with gr.Blocks() as demo:
    name = gr.Textbox(label="Name")
    output = gr.Textbox(label="Output Box")
    # static block - not used as a source
    static_block = gr.HTML("""
    <div style='height: 100px; width: 800px; background-color: pink;'></div>
    """)
    greet_btn = gr.Button("Hello")

	# decorator
    @greet_btn.click(inputs=name, outputs=output)
    def greet(name): # $ source=name
        return "Hello " + name + "!"

    # `click` event handler with keyword arguments
    def greet1(name): # $ source=name
        return "Hello " + name + "!"

    greet1_btn = gr.Button("Hello")
    greet1_btn.click(fn=greet1, inputs=name, outputs=output, api_name="greet")

    # `click` event handler with positional arguments
    def greet2(name): # $ source=name
        return "Hello " + name + "!"

    greet2_btn = gr.Button("Hello")
    greet2_btn.click(fn=greet2, inputs=name, outputs=output, api_name="greet")


demo.launch()
