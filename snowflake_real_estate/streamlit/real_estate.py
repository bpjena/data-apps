import streamlit as st
import altair as alt
import io
import pandas as pd
from snowflake.snowpark.context import get_active_session

# use the full page instead of a narrow central column
st.set_page_config(layout="wide")

# title and instruction
st.title("Real Estate Data Analysis")
tab1, tab2 = st.tabs(["City Comparison", "County Correlations"])

with tab1:
    # display instructions
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

with tab2:
    with st.container():
        st.write("Correlated Demographic Indicators")
        # let user enter county for demographic indicators
        county = st.text_input("Enter the County Name, such as 'San Francisco County':", value="San Francisco County",
                               max_chars=50, key="County Name")

        if st.button("Fetch"):
            # get the current credentials
            session = get_active_session()

            # query demographics data for county
            df_county = session.sql(
                f'SELECT DISTINCT COUNTY AS "County", DATE AS "Date", GROSS_INCOME_INFLOW AS "Gross Inflow Income", HOME_PRICE_INDEX AS "Home Price Index" FROM app_schema.COUNTY_CORR WHERE LOWER("County") = LOWER(\'{county}\') ORDER BY "Date" DESC, "County" DESC;'
            )

            # subheader
            st.subheader("Gross Income Inflow vs Home Price Index")

            # execute the query and convert it into a Pandas data frame
            queried_county_corr = df_county.to_pandas()

            gross_income = alt.Chart(queried_county_corr).mark_line(opacity=1).encode(
                x='Date', y='Gross Inflow Income')

            home_price = alt.Chart(queried_county_corr).mark_line(opacity=0.6).encode(
                x='Date', y='Home Price Index', color=alt.value("#FFAA00"))

            corr = alt.layer(gross_income, home_price)

            st.altair_chart(corr, use_container_width=True)

            # display the data frame.
            st.dataframe(queried_county_corr, use_container_width=True)

