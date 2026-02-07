-- ==============================
-- Set up
-- ==============================
CREATE DATABASE IF NOT EXISTS haha_family;
USE haha_family;

SET SQL_SAFE_UPDATES = 0;


-- ==============================
-- Modify upload_date column
-- ==============================
UPDATE haha_family
SET upload_date = STR_TO_DATE(upload_date_raw, '%Y%m%d')
WHERE video_id IS NOT NULL;

ALTER TABLE haha_family
MODIFY upload_date DATE;


-- ==============================
-- Add some calculated column
-- ==============================
ALTER TABLE haha_family
  ADD COLUMN like_rate DECIMAL(6,4),
  ADD COLUMN comment_rate DECIMAL(6,4),
  ADD COLUMN engagement_rate DECIMAL(6,4),
  ADD COLUMN views_per_hour DECIMAL(20,4),
  ADD COLUMN likes_per_hour DECIMAL(20,4),
  ADD COLUMN comments_per_hour DECIMAL(20,4);

UPDATE haha_family
SET
  like_rate        = ROUND(like_count / view_count, 4),
  comment_rate     = ROUND(comment_count / view_count, 4),
  engagement_rate  = ROUND((like_count + comment_count) / view_count, 4),
  views_per_hour   = ROUND(view_count * 3600 / duration_seconds, 4),
  likes_per_hour   = ROUND(like_count * 3600 / duration_seconds, 4),
  comments_per_hour= ROUND(comment_count * 3600 / duration_seconds, 4);

# Auto calculation option
/*
ADD COLUMN like_rate DECIMAL(10,4)
    GENERATED ALWAYS AS (ROUND(like_count / view_count, 4)) STORED,

  ADD COLUMN comment_rate DECIMAL(10,4)
    GENERATED ALWAYS AS (ROUND(comment_count / view_count, 4)) STORED,

  ADD COLUMN engagement_rate DECIMAL(10,4)
    GENERATED ALWAYS AS (ROUND((like_count + comment_count) / view_count, 4)) STORED,

  ADD COLUMN views_per_hour DECIMAL(20,4)
    GENERATED ALWAYS AS (ROUND(view_count * 3600 / duration_seconds, 4)) STORED,

  ADD COLUMN likes_per_hour DECIMAL(20,4)
    GENERATED ALWAYS AS (ROUND(like_count * 3600 / duration_seconds, 4)) STORED,

  ADD COLUMN comments_per_hour DECIMAL(20,4)
    GENERATED ALWAYS AS (ROUND(comment_count * 3600 / duration_seconds, 4)) STORED;
*/

SET SQL_SAFE_UPDATES = 1;


-- ==============================
-- Briefly look into the dataset
-- ==============================

# Trip summary
SELECT
  titles,
  trip_number,
  trip,
  COUNT(*) AS episodes,

  AVG(view_count) AS avg_views,
  AVG(like_count) AS avg_likes,
  AVG(comment_count) AS avg_comments,

  AVG(like_rate) AS avg_like_rate,
  AVG(comment_rate) AS avg_comment_rate,
  AVG(engagement_rate) AS avg_engagement_rate,

  AVG(views_per_hour) AS avg_views_per_hour
FROM haha_family
GROUP BY titles, trip_number, trip
ORDER BY titles, avg_views DESC;
# Analyse:
# For the main TV show, it indicate that trip 1 which is Bien Lien has highest number average views and get second place in the mini stories.
# However, surprisingly the second trip which has least episode has highest view in mini series.


# Top 3 episodes per trip by views
SELECT
  titles,
  trip_number,
  trip,
  episode,
  episode_num,
  video_id,
  upload_date,
  view_count,
  like_count,
  comment_count
FROM (
  SELECT
    t.*,
    ROW_NUMBER() OVER (
      PARTITION BY titles, trip_number
      ORDER BY view_count DESC
    ) AS rn
  FROM haha_family AS t
) x
WHERE rn <= 3
ORDER BY titles, trip_number, rn;
# Analyse
# From both the Haha Family show and its mini series, the highest views belong to the first episode of each trip, except for the last trip.
# This indicate the audience pay more attention to new change (which is the beginning of each trip)


# Top 3 episodes per trip by engagement rate
SELECT
  titles,
  trip_number,
  trip,
  episode,
  episode_num,
  video_id,
  upload_date,
  view_count,
  engagement_rate
FROM (
  SELECT
    t.*,
    ROW_NUMBER() OVER (
      PARTITION BY titles, trip_number
      ORDER BY engagement_rate DESC
    ) AS rn
  FROM haha_family AS t
) x
WHERE rn <= 3
ORDER BY titles, trip_number, rn;
# Analyse
# Opposite with top 5 episode by view count, the engagement of audience toward the TV show reach the highest number in the last episode of each trip
# So, it illustrate that the first episode gain audience attention but from time to time they are more engage with the TV show and become loyal audience.



# Episode to episode by category
# Reach = number of people reach by view
# Engagement = how strong the engagement of audience toward the TV show
WITH av AS (
  SELECT
    titles,
    AVG(view_count) AS avg_views,
    AVG(engagement_rate) AS avg_eng
  FROM haha_family
  GROUP BY titles
)
SELECT
  t.titles,
  t.trip_number, t.trip,
  t.episode_num, t.video_id, t.upload_date,
  t.view_count, t.engagement_rate,

  CASE
    WHEN t.view_count >= av.avg_views AND t.engagement_rate >= av.avg_eng THEN 'High reach + High engagement'
    WHEN t.view_count >= av.avg_views AND t.engagement_rate <  av.avg_eng THEN 'High reach + Low engagement'
    WHEN t.view_count <  av.avg_views AND t.engagement_rate >= av.avg_eng THEN 'Low reach + High engagement'
    ELSE 'Low reach + Low engagement'
  END AS performance_bucket
FROM haha_family AS t
JOIN av ON t.titles = av.titles
ORDER BY t.titles, t.trip, t.episode_num;
# Analyse
# For Tv show (Haha Family), Ban Lien trip nearly all episode had high view with high engagement of audience, while other trips had mix signal
# For the HaHa mini series, it is more balance in the number of views and the engagement of audience.
# This shows that the show slowly lose it interest compared to first few episode, however, to truely reflect how it is, more analytic need to be conduct.







