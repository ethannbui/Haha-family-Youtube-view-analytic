# Project: Pipeline Analytics for YouTube TV Series and its Mini Series (Haha Family, 2026)
Built an end-to-end analytics pipeline to measure content performance and engagement for the Haha Family TV series on YouTube using 2026 raw video data (views, likes, duration, publish time, etc.).

**Haha Family** is a reality program about cultural exploration and heartfelt connection, airing on VTV3 since June 14, 2025. It follows artists living together in Vietnam’s rural regions, that share daily work and simple joys, and build bonds that feel like family. Its message, “Finding Joy in Simple Days Under the Open Sky,” captures the spirit of warmth, togetherness, and belonging.

- **Data Collection (Python):** Programmatically gathered video-level metrics from YouTube, cleaned and standardized fields (dates, durations, missing values), and exported curated datasets for analysis.

- **Data Modeling & Analytics (SQL):** Loaded data into SQL and created reusable queries to compute KPIs such as engagement rate, views per hour, like-to-view ratio, and performance comparisons across episodes/time periods.

- **Visualization (Power BI):** Delivered an interactive Power BI dashboard with trends, KPI cards, episode rankings, and time-based breakdowns to support content and marketing decisions.

**Tech stack:** Python (data extraction + cleaning), SQL (KPI modeling + analytics), Power BI (dashboard + storytelling)

## Delivery:
- From the dashboard and information from SQL, the show in general is successful. The main reason is that it reaches a large audience with many millions of views episode and the views-per-hour KPI is very high, which shows strong demand. Engagement is pretty good but not always strong, meaning viewers do interact but some episodes perform better than others. In short, the show is strong at attracting viewers, and the biggest opportunity is improving likes/comments on high-view episodes by using call-to-actions strategy or uploading shorts/ reels from Youtube.

- The first episode of each trip usually gets the most views, while the last episodes often have the highest engagement rate (likes + comments compared to views). From that, we can use the last episodes to build community. Ask viewers a clear question, encourage comments, and post polls. This works because loyal viewers are more active at the end of a trip from the dashboard.
