drop table if exists models.user_performance_by_cohort;
create table models.user_performance_by_cohort
as

with get_user_installs_and_activities as (
    select ui.install_date,
           ui.user_id,
           ui.country_code,
           ua.matches_completed,
           ua.matches_started,
           ua.matches_won
    from raw_data.user_installs ui
    left join raw_data.user_activity ua
        on ui.user_id = ua.user_id
)

select install_date,
       country_code,
       count(distinct user_id) as n_users,
       sum(matches_completed) as matches_completed,
       sum(matches_started) as n_matches_started,
       sum(matches_won) as n_matches_won
from get_user_installs_and_activities
group by 1,2