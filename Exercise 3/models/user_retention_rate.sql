drop table if exists models.user_retention;
create table models.user_retention
as

with get_user_installs_activities as (
    select ui.user_id,
           ui.country_code,
           ui.install_date,
           ua.play_date,
           date_diff(cast(ua.play_date as date), cast(ui.install_date as date),
                   day) as n_days_from_install,
           ua.matches_started,
           ua.matches_completed,
           ua.matches_won,

    from raw_data.user_installs ui
    left join raw_data.user_activity ua
        on ui.user_id = ua.user_id
           -- technically in this dataset, a user activity can occur before the install.
           -- this needs more investigation, for now, discount them from the retention calc
           and cast(ui.install_date as date) <= cast(ua.play_date as date)
)

select install_date as cohort_date,
       country_code,
       count(distinct user_id) as n_users_in_cohort,
       count(distinct case when n_days_from_install >= 7 then user_id end) as n_users_engaged_first_week,
       count(distinct case when n_days_from_install >= 30 then user_id end) as n_users_engaged_first_month,
       count(distinct case when n_days_from_install >= 60 then user_id end) as n_users_engaged_second_month
from get_user_installs_activities
group by 1,2
