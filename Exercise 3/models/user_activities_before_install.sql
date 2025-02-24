-- get activities that occurred before the install. This is unusual behavior
select *
from raw_data.user_installs ui
left join raw_data.user_activity ua
    on ui.user_id = ua.user_id
       and cast(ui.install_date as date) > cast(ua.play_date as date)
where ua.user_id is not null