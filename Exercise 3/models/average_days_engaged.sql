with get_user_distinct_days as (
    select user_id,
           count(distinct play_date) as n_distinct_play_dates
    from raw_data.user_activity
    group by 1
)

select avg(n_distinct_play_dates)
from get_user_distinct_days