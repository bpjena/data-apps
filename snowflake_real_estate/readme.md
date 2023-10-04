### 1. Real Estate Data Analysis
  - App Details -
    - uses `Streamlit` 
    - deployed through `Snowflake` `STAGE` object
    - accessed through `Snowsight`
  - App utilizes the [Knoema Real Estate Data Atlas from Snowflake Marketplace](https://app.snowflake.com/marketplace/listing/GZSTZ491W11/knoema-real-estate-data-atlas) 
    - App allows users to **compare the average single-family residence prices and average rent between two cities** in the United States for the past 12 months.
    - *additional usecase* :  use [US Housing & Real Estate Essentials data from Cybersyn, Inc available on Snowflake Marketplace](https://app.snowflake.com/marketplace/listing/GZTSZAS2KI6/cybersyn-inc-cybersyn-us-housing-real-estate-essentials) for **demographics overlay on housing prices** for a correlated view
  - `Summary` [implementation](https://drive.google.com/file/d/18rPdx2EWULMPbgNWEtaVZ8cAhKpWzDV7/view)
  - `Code` [Github](https://github.com/bpjena/data-apps/tree/main/snowflake_real_estate)
  - `Reference` [Building a Real Estate App with Snowflake Native App Framework](https://medium.com/snowflake/building-a-real-estate-app-with-snowflake-native-app-framework-68ee5d5ffe9a)