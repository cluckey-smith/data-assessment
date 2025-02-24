drop table if exists models.rfm_model;

create table models.rfm_model
as

with get_player_installs_activities as (
    select ui.user_id,
           -- since we are fanning out here, take the minimum install_date to aggregate
           min(ui.install_date) as install_date,
           max(ua.play_date) as last_played,
           count(distinct ua.play_date) as n_days_played,
           -- assume that the most recent play date is our current date, given we don't know the age of this data
           date_diff((select max(play_date) from raw_data.user_activity), max(ua.play_date), day) as recency,
           sum(ua.matches_started) as n_matches_started,
           sum(ua.matches_completed) as n_matches_completed,
           sum(ua.matches_won) as n_matches_won
    from raw_data.user_installs ui
    left join raw_data.user_activity ua
        on ui.user_id = ua.user_id
    group by 1
 ),

get_recency as (
    select *,
           -- a high recency score is what we want
           ntile(4) over (order by recency desc) as recency_score,
           -- while we have the games a user started, going to instead use days here. This gives us the frequency they
           -- are returning to our game with
           ntile(4) over (order by n_days_played) as frequency_score,
           -- the more a player is completing games, the better opportunity to monetize. So we will user completions
           -- as a proxy metric.
           ntile(4) over (order by n_matches_completed) as games_completed_score
    from get_player_installs_activities
)

select *
from get_recency
order by install_date