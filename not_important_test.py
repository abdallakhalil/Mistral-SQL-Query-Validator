import openai
import streamlit as st
from openai import OpenAI

# Set your OpenAI API key here
openai.api_key = ""

client = OpenAI(api_key=openai.api_key)

def append_to_conversation(sql_query):
    """Appends user query to conversation history and generates a response from OpenAI."""
    # Append user query to conversation history
    st.session_state.conversation_history.append({"role": "user", "content": sql_query})

    # Generate chat completions using the OpenAI API
    completion = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=st.session_state.conversation_history,
    )
    # Append AI's response to conversation history
    if completion.choices:
        st.session_state.conversation_history.append({"role": "assistant", "content": completion.choices[0].message.content})

# Custom CSS to style the chat
st.markdown("""
<style>
.chat-message {
    padding: 10px;
    border-radius: 25px;
}
.user-message {
    background-color: #f0f2f6;
    margin: 5px 0 20px 50px;
}
.bot-message {
    background-color: #e1f5fe;
    margin: 5px 50px 20px 0;
}
</style>
""", unsafe_allow_html=True)

# Streamlit app interface
st.title("Conversational SQL Query Validator")

# Initialize or retrieve the conversation history
if 'conversation_history' not in st.session_state:
    st.session_state.conversation_history = [
        {"role": "system", "content": "You are a SQL expert. Validate the user's SQL query. Provide explanations or corrections if needed."}
    ]

# Display formatted conversation
for exchange in st.session_state.conversation_history:
    if exchange['role'] == 'user':
        st.markdown(f"<div class='chat-message user-message'>{exchange['content']}</div>", unsafe_allow_html=True)
    elif exchange['role'] == 'assistant':
        st.markdown(f"<div class='chat-message bot-message'>{exchange['content']}</div>", unsafe_allow_html=True)

# Generate a unique key for the input box based on the conversation history length
input_key = "user_query_" + str(len(st.session_state.conversation_history))
user_query = st.text_input("Enter your SQL query or ask a follow-up question:", "", key=input_key)

if st.button("Validate/Ask"):
    with st.spinner('Processing...'):
        # Append query to conversation and get response
        append_to_conversation(user_query)
        
        # Clear the input by rerunning the app to refresh the input_key
        st.experimental_rerun()
