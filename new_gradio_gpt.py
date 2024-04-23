import gradio as gr
import streamlit as st
from langchain.callbacks.manager import CallbackManager
# from langchain.llms.openai import OpenAIChat
from langchain.chat_models import ChatOpenAI
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
# from langchain import PromptTemplate 
from langchain.chains import LLMChain
from langchain.prompts import (
    ChatPromptTemplate,
    HumanMessagePromptTemplate,
    MessagesPlaceholder,
)
from langchain_core.messages import SystemMessage
# from langchain_openai import ChatOpenAI
from langchain.memory import ConversationBufferMemory
import json
from dotenv import load_dotenv
import os

load_dotenv()

with open("questions.txt", 'r') as f:
    questions_list = f.readlines()

with open("schema_json2.json", 'r') as f:
    context_json = json.loads(f.read())


css = """
.container {
    justify-content: center;
    align-items: center;
}
"""


# Initialize LangChain model
llm = ChatOpenAI(model_name="gpt-3.5-turbo",  # Adjust model name as needed
                 openai_api_key=os.getenv("OPENAI_API_KEY"),
                 callback_manager=CallbackManager([StreamingStdOutCallbackHandler()]),
                 temperature=0.4)


prompt = ChatPromptTemplate.from_messages(
    [
        SystemMessage(
            content="""You are a powerful SQL validation model. 
    Your job is to, tell whether the user's SQL query is correct or incorrect.
      Keep your response consice, say 'Your query is correct' if the users query is completely correct and if the query is not completely correct respond with 'Your query is incorrect'. Make sure the syntax of the sql query is correct based on the Question provided and the context and schema in Correct Answer above the User_Answer, before giving a response. Ignore small errors like Capitalization and casing errors from the user's SQL Query. Let the user know if their query is correct or not. If the query is incorrect give useful hints to the user but do not give the user the correct SQL query. Do not provide any examples of the correct query.
      Only give hints limited to the syntax issues and business logic issues:"""
        ),  # The persistent system prompt
        MessagesPlaceholder(
            variable_name="chat_history"
        ),  # Where the memory will be stored.
        HumanMessagePromptTemplate.from_template(
            "{human_input}"
        ),  # Where the human input will injected
    ]
)

memory = ConversationBufferMemory(memory_key="chat_history", return_messages=True)
chain = LLMChain(llm=llm, prompt=prompt, memory=memory)


def page_load():
    global memory
    memory.clear()
    return memory


with gr.Blocks(css=css) as demo:
    ques_count = gr.State(value=0)
    # message_history_list = gr.State([])
    demo.load(fn=page_load)

    message_history_list = gr.State(memory)
    # LangChain LLM Chain

    def next_question(ques_count, message_history_list):
        """Increment the question count."""
        # print(message_history_list)
        if ques_count < len(questions_list):
            ques_count += 1
            message_history_list = []
            memory.clear()
        return ques_count, message_history_list, f"### {questions_list[ques_count]}", "", ""

    def previous_question(ques_count, message_history_list):
        """Increment the question count."""
        # print(message_history_list)
        if ques_count > 0:
            ques_count -= 1
            message_history_list = []
            memory.clear()
        return ques_count, message_history_list, f"### {questions_list[ques_count]}", "", ""

    def validate(sql_query, ques_count, message_history_list):
        formated_stream = {}
        system_prompt = ""
        question = questions_list[ques_count]
        context = context_json[str(ques_count)]
        if memory.dict()["chat_memory"]["messages"] == []:
            new_message = f"Question: {question}\nCorrect Answer: {context}\nUser_nswer: {sql_query}"
        else:
            new_message = f"Answer: {sql_query}"

        stream = chain.run(new_message)

        print()
        print(memory.dict())
        return stream.replace("\n", "", 1), message_history_list

    with gr.Row():
        with gr.Column():
            pass
        with gr.Column():
            gr.Markdown("# Conversational SQL Query Validator")
            with gr.Row():
                question_markdown = gr.Markdown(f"### {questions_list[0]}")
            with gr.Row():
                out = gr.Textbox()
            with gr.Row():
                inp = gr.Textbox(placeholder="Write your query here.")
            with gr.Row():
                with gr.Column():
                    prev_btn = gr.Button(value="previous_question", scale=1, min_width=60)
                    prev_btn.click(fn=previous_question, inputs=[ques_count, message_history_list], outputs=[ques_count, message_history_list, question_markdown, out, inp])
                    next_btn = gr.Button(value="next_question", scale=1, min_width=60)
                    next_btn.click(fn=next_question, inputs=[ques_count, message_history_list], outputs=[ques_count, message_history_list, question_markdown, out, inp])
                with gr.Column():
                    btn = gr.Button("validate")
                    btn.click(fn=validate, inputs=[inp, ques_count, message_history_list], outputs=[out, message_history_list])

        with gr.Column():
            pass

demo.launch()