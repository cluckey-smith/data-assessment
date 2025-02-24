create table models.user_activity_by_install_date
as

with get_user_agg_activities as (
    select user_id,
           sum(matches_started) as n_matches_started,
           sum(matches_completed) as n_matches_completed,
           sum(matches_won) as n_matches_won
    from raw_data.user_activity
    group by 1
)

select ui.user_id,
       ui.install_date,
       ui.country_code,
       sum(ua.n_matches_started) as n_matches_started,
       sum(ua.n_matches_completed) as n_matches_completed,
       sum(ua.n_matches_won) as n_matches_won
from raw_data.user_installs ui
left join get_user_agg_activities ua
    on ui.user_id = ua.user_id
group by 1,2,3
