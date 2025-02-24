drop table if exists models.user_engagement;

create table models.user_engagement
as

select ui.user_id,
       ui.install_date,
       ua.play_date,
       date_diff(cast(ua.play_date as date), cast(ui.install_date as date),
               week) as n_weeks_from_install,
       ua.matches_started,
       ua.matches_completed,
       matches_won
from raw_data.user_installs ui
left join raw_data.user_activity ua
    on ui.user_id = ua.user_id
