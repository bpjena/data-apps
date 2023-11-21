# Release Note v3.0.0 (Current Version)

1) Snowsight now features an [**ETL monitoring**](https://github.com/bpjena/data-apps/tree/main/snowsight/ETL%20Monitoring) capability, extending its support to popular ETL tools such as **Matillion**, **DBT**, **Fivetran**, and **Snowflake tasks**.

2) Added **Query Analyzer** documentation as an [**extension**](https://github.com/bpjena/data-apps/tree/main/snowsight/Snowflake%20Monitoring/Extensions/Query%20Analyzer) to Watchkeeper, which helps in providing deeper insights of queries in regards to performance.

3) Introduced a new documentation resource to assist users in efficiently configuring snowflake [**Alerts and notifications**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Additional%20Documents/Snowflake%20Alerts%20_%20Notifications.docx).

4) Updates also include bug fixes and renaming adjustments in Snowflake's monitoring features, such as changing **Average Performance in Millisecond** KPI to **Average Runtime in Millisecond** in the Query Performance Dashboard and renaming with fixes in **Avg. Time per Query** KPI to **Avg. Execution Time per Query** in the User Adoption Dashboard.



## Installation Steps

To install the **Snowflake Monitoring** dashboards please follow the below steps:

1) (Optional) Uninstall exisitng Watchkeeper monitors. To do so refer the [**Uninstallation Guide**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Uninstall.txt) file above.

2) Run the [**Prerequisite**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Prerequisite.txt) file above, then follow [**Custom Filters in Snowsight Guide**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Additional%20Documents/Custom%20Filters%20in%20Snowsight%20Guide.docx) to assign permission for creating filters.

3) In order to create Compute monitor dashboard, navigate to the Compute monitor folder and execute the given [**Compute Monitor Query Development.docx**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Compute%20Monitor/Compute%20Monitor%20Query%20Development.docx) document to create custom tables followed by its [**Compute Monitor Snowsight Dashboard.docx**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Compute%20Monitor/Compute%20Monitor%20Snowsight%20Dashboard.docx) document to create KPIs on top of custom tables.

4) In order to create Storage monitor dashboard, navigate to the Storage monitor folder and execute the given [**Storage Monitor Query Development.docx**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Storage%20Monitor/Storage%20Monitor%20Query%20Development.docx) document to create custom tables followed by its [**Storage Monitor Snowsight Dashboard.docx**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Storage%20Monitor/Storage%20Monitor%20Snowsight%20Dashboard.docx) document to create KPIs on top of custom tables.

5) In the performance monitor, there are four dashboards namely **Query Performance**, **User Adoption**, **Short and Long running queries**, **Error tracking**. All the dashboards except from short and long queries dashboard can be created only by executing respective monitor snowsight query development docs and in order to create short and long running queries dashboard, first execute the its given [**Short and long query analysis monitor query development.docx**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Performance%20Monitor/Short%20and%20long%20query%20analysis%20monitor%20query%20development.docx) document to create custom tables followed by its [**Short and long query analysis snowsight dashboard.docx**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Performance%20Monitor/Short%20and%20long%20query%20analysis%20snowsight%20dashboard.docx) document to create KPIs on top of custom tables.

6) In order to create Security monitor dashboard, navigate to the Security monitor folder and execute the given [**Security Monitor Query Development.docx**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Security%20Monitor/Security%20Monitor%20Query%20Development.docx) document to create custom tables followed by its [**Security Monitor Snowsight Dashboard.docx**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Security%20Monitor/Security%20Monitor%20Snowsight%20Dashboard.docx) document to create KPIs on top of custom tables.

7) (Optional) To share a dashboard with another user in your account, follow the [**Dashboard Sharing Guide**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Additional%20Documents/Dashboard%20Sharing%20Guide.docx). 


## Version History

### Release Note v2.3.0 

1) Two new documents have been introduced: [**Custom Filters in Snowsight Guide**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Additional%20Documents/Custom%20Filters%20in%20Snowsight%20Guide.docx) and [**Dashboard Sharing Guide**](https://github.com/bpjena/data-apps/blob/main/snowsight/Snowflake%20Monitoring/Additional%20Documents/Dashboard%20Sharing%20Guide.docx).

2) The names of several KPIs have been revised in both the Compute Credit Monitor and Security Monitor dashboards.

3) Bug fixes have been implemented for the **Daily Average Compute Credits** KPI in the Compute Monitor, as well as for the **Organization Storage Usage**, **Account Storage Usage**, **Database Storage Usage**, and **Table Storage Usage** KPIs in the Storage Monitor. Additionally, the bug fixes have been also applied to the **Total AccountAdmin Users**, **Users with Most Privileges**, and **Ghost Role** KPIs in the Security Monitor.

4) Notable enhancements have been made to the **User Granting Accountadmin Privileges** and **To Whom is Accountadmin Privilege Granted?** KPIs in the Security Monitor.

### Release Note v2.2.0

1) All cost-related information has been replaced with **credit** on the **Compute Monitoring dashboard**, and it has also been removed from the code.

2) All cost-related information has been removed from both the dashboard and the code under **Storage Monitoring**.

3) Code for **incremental load** has been updated for **Compute and Performance dashboards**.

4) **Security monitoring dashboard** has been added containing all security related KPIs.

5) All objects like warehouse, database, roles which used the name **Mastiff** is now replaced with the name **Monitor**.

6) Added **Compute Credits by Month** KPI in the Compute credit monitor dashboard.

7) Added two new filters - Filter by **Year** and Filter by **Month**.
