create table models.completion_rate_by_user
as

with get_summed_user_activity as (
    select user_id,
           sum(matches_completed) as n_matches_completed,
           sum(matches_started) as n_matches_started,
           sum(matches_won) as n_matches_won
    from raw_data.user_activity
    group by 1
)

select n_matches_completed / nullif(n_matches_started, 0) as completed_rate,
       count(distinct user_id) as n_users
from get_summed_user_activity
group by 1



