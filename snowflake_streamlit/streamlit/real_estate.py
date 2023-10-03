import streamlit as st
import altair as alt
from snowflake.snowpark.context import get_active_session

# use the full page instead of a narrow central column
st.set_page_config(layout="wide")

# title and instruction
st.title("Real Estate Data Analysis")
st.write(
    """Enter two cities (with two-letter states) in the United States to start, for example: "San Francisco, CA" and "New York, NY".
    """
)

# split UI into two columns
col1, col2 = st.columns(2)

# let user enter the two cities for comparison
city1 = col1.text_input("Enter the first city, such as 'San Francisco, CA':", value="San Francisco, CA", max_chars=30,
                        key="city1")
city2 = col2.text_input("Enter the second city, such as 'New York, NY':", value="New York, NY", max_chars=30,
                        key="city2")

if st.button("Compare"):
    if city1 and city2:
        # get the current credentials
        session = get_active_session()

        # query data for both housing and rental
        df_housing = session.sql(
            f'SELECT TOP 24 "Region Name", "Date", "Value" FROM app_schema.ZRHVI2020JUL WHERE (LOWER("Region Name") = LOWER(\'{city1}\') OR LOWER("Region Name") = LOWER(\'{city2}\')) AND "Indicator Name" = \'ZHVI - Single Family Residence\' ORDER BY "Date" DESC, "Region Name" DESC;')
        df_rental = session.sql(
            f'SELECT TOP 24 "Region Name", "Date", "Value" FROM app_schema.ZRRENTVI2020JUL WHERE (LOWER("Region Name") = LOWER(\'{city1}\') OR LOWER("Region Name") = LOWER(\'{city2}\')) AND "Indicator Name" = \'ZORI (Smoothed) : All Homes Plus MultiFamily\' ORDER BY "Date" DESC, "Region Name" DESC;')

        # subheader for housing
        col1.subheader("Average single-family residence values")

        # execute the query and convert it into a Pandas data frame
        queried_data_housing = df_housing.to_pandas()

        # add bar chart
        chart_housing = alt.Chart(queried_data_housing).mark_bar().encode(
            x=alt.X('Date:T'),
            y=alt.Y('Value:Q'),
            color=alt.Color("Region Name:N")
        )
        col1.altair_chart(chart_housing, use_container_width=True)

        # display the data frame.
        col1.dataframe(queried_data_housing, use_container_width=True)

        # subheader for rental
        col2.subheader("Average rent (for all homes plus multiFamily)")

        # execute the query and convert it into a Pandas data frame
        queried_data_rental = df_rental.to_pandas()

        # add line chart
        chart_rental = alt.Chart(queried_data_rental).mark_line().encode(
            x=alt.X('Date:T'),
            y=alt.Y('Value:Q'),
            color=alt.Color("Region Name:N")
        )
        col2.altair_chart(chart_rental, use_container_width=True)

        # display the data frame.
        col2.dataframe(queried_data_rental, use_container_width=True)