MTA Daily Ridership – Data Analysis & Interactive Chatbot Project

Overview
This project focuses on analyzing the MTA Daily Ridership dataset, which contains daily usage statistics for various transportation modes in New York City, including Subways, Buses, LIRR, Metro-North, Access-A-Ride, and Bridges & Tunnels traffic.
The goal of the project was to understand ridership patterns, extract meaningful insights, and build an interactive system that makes the data easier to explore.

Objectives
Analyze ridership trends over time.
Compare usage across different transportation modes.
Study the impact of events such as weekends, seasons, and the COVID-19 pandemic.
Build clear and meaningful visualizations to support data-driven insights.
Develop an AI-powered chatbot connected to the dataset for interactive data exploration.
Provide a structured analysis divided into clear categories to simplify understanding.
Dataset & Preparation
The dataset was clean and contained no missing values, which allowed for smooth transition into analysis.
Dates were processed and decomposed into Year, Month, and Day-of-Week to support advanced time-series analysis.
The data was validated and formatted to allow integration with analysis tools and the chatbot.
Analytical Structure
The analysis was divided into clear modules to ensure full coverage of the dataset:
General Questions
Basic exploration to understand overall ridership patterns.

Comparison Analysis
Comparing transportation modes across different periods.

Pandemic Analysis
Studying the effect of COVID-19 on ridership volumes.

Correlation Analysis
Exploring relationships between different columns and transportation types.

Time Series Analysis
Detecting long-term trends, seasonality, and recurring patterns.

Operational Analysis
Understanding daily operations, peak days, and weekly behavior.

Visualizations

Various charts were created to effectively communicate insights, including:

Line charts for long-term ridership trends.

Bar charts for comparisons across transportation types.

Distribution and correlation visuals for deeper relationships.

All visualizations were chosen to support clarity, readability, and insight generation.

Interactive Chatbot

A Streamlit-based chatbot was developed and connected directly to the dataset.
The chatbot can:

Answer questions about ridership numbers.

Retrieve specific data points.

Provide simple analytical outputs.

Help users interact with the dataset without manual searching.

This component combines data analysis with AI to create a dynamic and user-friendly experience.

Challenges & Solutions
1. Selecting the Right Visual for Each Question

Some questions required comparing columns with very small differences or subtle relationships that do not appear clearly in every chart.
Solution:

Tested multiple chart types for the same data.

Compared clarity and readability.

Used AI suggestions to choose the most suitable visual.

2. Avoiding Information Overload

Some visuals became cluttered due to many variables.
Solution:

Simplified designs using minimal layouts.

Used one clear idea per visual whenever possible.

3. Managing Multiple Columns and Long Time Series

The dataset covers long periods and many variables.
Solution:

Extracted features such as Year, Month, and Day-of-Week.

Organized analysis into structured modules.

4. Ensuring Chatbot Accuracy

The chatbot needed to interpret user queries and fetch correct values.
Solution:

Improved data retrieval logic.

Added validation to ensure consistent and context-aware responses.

Conclusion

This project presents a complete analytical workflow, combining data exploration, visualization, advanced analysis, and interactive AI tools.
By studying the MTA ridership data, we gained a deeper understanding of transportation behavior in New York City, and demonstrated how data-driven insights can support better planning and decision-making.

The integration of a chatbot adds an innovative interactive layer that makes accessing insights easier and more intuitive.
