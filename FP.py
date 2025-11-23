import streamlit as st
import pandas as pd
import google.generativeai as genai
import matplotlib.pyplot as plt
import seaborn as sns
import os

# ================== 1. Setup API Key and Gemini ==================
api_key = os.getenv("GEMINI_API_KEY", "")
if not api_key:
    st.error("Please set the Gemini API key in the GEMINI_API_KEY environment variable.")
    st.stop()
else:
    genai.configure(api_key=api_key)

# ================== 2. Load Dataset ==================
try:
    df = pd.read_csv("MTA_Daily_Ridership.csv")
except FileNotFoundError:
    st.error("Could not find the file 'MTA_Daily_Ridership.csv'. Check the file path.")
    st.stop()

# Automatically detect key columns
date_col = next((col for col in df.columns if 'date' in col.lower()), None)
ridership_col = next((col for col in df.columns if 'ridership' in col.lower()), None)
station_col = next((col for col in df.columns if 'station' in col.lower()), None)

if date_col:
    df[date_col] = pd.to_datetime(df[date_col], errors='coerce')

# ================== 3. Gemini AI Query Function ==================
def ask_gemini(question, df):
    context = df.head(100).to_string(index=False)

    
    prompt = f"""
You are a helpful data analysis assistant.
The user asked a question about a sample dataset:

{context}

Answer the question clearly.
If the user asks for a chart or visual, return Python code using matplotlib or seaborn.
Do not leave the answer empty.

Question: {question}
"""
    model = genai.GenerativeModel("gemini-2.5-flash")
    response = model.generate_content(prompt)
    return response.text

# ================== 4. Streamlit UI ==================
st.set_page_config(page_title="MTA Ridership Chatbot", page_icon="📊", layout="wide")

st.markdown("""
<style>
.stApp { 
    background-image: url("https://i.postimg.cc/nLSV7sRF/Whats-App-Image-2025-11-23-at-12-01-57-AM.jpg");
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
    color: #FFD700;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
}
h1 { 
    color: #FFD700; 
    text-shadow: 2px 2px 5px #000000; 
    text-align:center;
}
.answer-card { 
    background-color: rgba(255,255,255,0.8); 
    border-radius: 15px; 
    padding: 20px; 
    margin-top: 20px; 
    box-shadow: 2px 2px 15px rgba(0,0,0,0.5); 
    color: #000000;
}

.stTextArea textarea { 
    background-color: rgba(255,255,255,0.8); 
    color: #000000; 
    border: 1px solid #FFD700; 
    border-radius: 10px; 
    padding: 10px; 
}

.stButton button { 
    background-color: #005f99; 
    color: white; 
    border-radius: 10px; 
    padding: 10px 25px; 
    font-weight: bold; 
    border: none; 
    transition: 0.3s; 
}

.stButton button:hover { 
    background-color: #004f80; 
    cursor: pointer; 
}
.stChatMessage p, 
.stChatMessage span, 
.stChatMessage div, 
.stChatMessage {
    color: white !important;
}

/* Markdown inside chat bubbles */
.stChatMessage .stMarkdown, 
.stChatMessage .stMarkdown p, 
.stChatMessage .stMarkdown span {
    color: white !important;
}

/* User/Assistant labels */
.stChatMessage [data-testid="stChatMessageAvatar"] + div span {
    color: white !important;
}

/* Chat bubble background */
.stChatMessage {
    background-color: rgba(0,0,0,0.4) !important;
    padding: 10px;
    border-radius: 15px;
}

.stChatMessage pre, 
.stChatMessage code {
    background-color: rgba(0,0,0,0.4) !important;     
    color: white !important;                          
    border-radius: 10px;                              
    padding: 5px 10px;                                 
    font-family: 'Courier New', Courier, monospace;
}

.stApp .css-1l02zno { 
    background-color: transparent !important; 
}
.stApp .stChatInput {
    background-color: transparent !important; 
    box-shadow: none !important;
    border: 1px solid #FFD700 !important;    
    border-radius: 10px;                      
}

</style>

<div style="text-align:center; margin-bottom:30px;">
    <h1>MTA Ridership Chatbot</h1>
    <p style="font-size:18px; color:#FFFFFF;">Ask questions about your dataset or pick one from the sidebar</p>
</div>
""", unsafe_allow_html=True)



# ================== 5. Store Chat Messages ==================
if "messages" not in st.session_state:
    st.session_state.messages = []

def add_message(role, content, fig=None):
    st.session_state.messages.append({"role": role, "content": content, "chart_figure": fig})

for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.write(message["content"])
        if message.get("chart_figure"):
            st.pyplot(message["chart_figure"])

# ================== 6. Sidebar ==================
st.sidebar.header("Pinned Questions")
pinned_questions = [
    "What is the total ridership by year?",
    "Show the top 5 busiest stations.",
    "Visualize ridership trends over time.",
    "Average daily ridership per month.",
    "Compare weekday vs weekend ridership."
]
selected_question = st.sidebar.radio("Select a question:", options=[""] + pinned_questions, index=0)

# ================== 7. Handle User Input ==================
user_prompt = st.chat_input("Write your question:")

if selected_question.strip():
    final_question = selected_question
elif user_prompt:
    final_question = user_prompt
else:
    final_question = None

if final_question:
    # Display user question
    with st.chat_message("user"):
        st.write(final_question)
    add_message("user", final_question)

    # Get AI response
    with st.chat_message("assistant"):
        with st.spinner("Bot is thinking..."):
            answer = ask_gemini(final_question, df)

            # Display the answer
            st.write(answer)
            add_message("assistant", answer)

