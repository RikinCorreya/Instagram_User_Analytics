#TASKS BY                                RIKIN CORREYA
use ig_clone;

#A) Marketing Analysis:   
# 1) Loyal User Reward: The marketing team wants to reward the most loyal users, i.e., those who have been using the platform for the longest time.
#    Task - Identify the five oldest users on Instagram from the provided database  RIKIN CORREYA
select id, username, created_at 
from users
order by created_at limit 5;

# 2) Inactive User Engagement: The team wants to encourage inactive users to start posting by sending them promotional emails.
#    Task - Identify users who have never posted a single photo on Instagram.      RIKIN CORREYA
select id, username from users 
where id not in (
select user_id 
from photos 
group by user_id
);

# 3) Contest Winner Declaration: The team has organized a contest where the user with the most likes on a single photo wins.
#    Task - Determine the winner of the contest and provide their details to the team.                                    RIKIN CORREYA
create view most_liked_photos as(
   select count(user_id) as total_likes,photo_id from likes group by photo_id 
);
select username, total_likes, inner_query_table.photo_id,inner_query_table.image_url from users inner join (
    select total_likes,user_id,photo_id,image_url  from most_liked_photos inner join photos
    on photos.id = most_liked_photos.photo_id 
    order by total_likes desc
    limit 1
) as inner_query_table
on users.id = inner_query_table.user_id;


# 4) Hashtag Research: A partner brand wants to know the most popular hashtags to use in their posts to reach the most people.
#    Task - Identify and suggest the top five most commonly used hashtags on the platform.                               RIKIN CORREYA
with comonly_used_tags as(
select count(*) as total_times_used,tag_id from photo_tags
group by tag_id order by total_times_used desc limit 5
) 
select tag_name,total_times_used from tags inner join comonly_used_tags 
on tags.id = comonly_used_tags.tag_id;


# 5) Ad Campaign Launch: The team wants to know the best day of the week to launch ads.                       RIKIN CORREYA
#    Task - Determine the day of the week when most users register on Instagram. Provide insights on when to schedule an ad campaign.
SELECT 
    COUNT(*) AS total_acc_created,
    DAYNAME(created_at) AS day_creation
FROM
    users
GROUP BY day_creation 
ORDER BY total_acc_created DESC; 


#B) Investor Metrics:   
# 1) User Engagement: Investors want to know if users are still active and posting on Instagram or if they are making fewer posts.
#    Task - Calculate the average number of posts per user on Instagram. Also, provide the total number of photos                  RIKIN CORREYA
#           on Instagram divided by the total number of users.
select count(*) as total_posts from photos;
select count(*) as total_users from users;
select 
round(((select count(*) as total_posts from photos) / (select count(*) as total_users from users)),2) as avg_posts_per_user
;

# 2) Bots & Fake Accounts: Investors want to know if the platform is crowded with fake and dummy accounts.                RIKIN CORREYA
#    Task - Identify users (potential bots) who have liked every single photo on the site, as this is not typically possible for a normal user.
select id, username,posts_liked from users inner join(
select count(*) as posts_liked, user_id from likes group by user_id having posts_liked = (select count(*) from photos)
) as posts_liked_table
  on users.id = posts_liked_table.user_id;
