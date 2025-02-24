drop table if exists models.user_win_share;
create table models.user_win_share
as

with get_user_metics as (
    select user_id,
           sum(matches_won) as n_matches_won,
           sum(matches_started) as n_matches_started
    from raw_data.user_activity
    group by 1
)

select user_id,
       n_matches_won / sum(n_matches_won) over () as win_share,
       n_matches_started / sum(n_matches_started) over () as play_share
from get_user_metics
order by win_share desc