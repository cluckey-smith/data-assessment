with get_visits as (
    select date,
           variant,
           sum(visits) as n_visits
    from `eg-data-assessment.models.web_table_flat`
    group by 1,2
),

get_total_visits as (
  select date,
         variant,
         n_visits,
         sum(n_visits) over (partition by date) as n_total_visits
  from get_visits
)

select date,
       variant,
       n_visits,
       n_total_visits,
       cast(n_visits as float64) / n_total_visits as pct_total_visits
from get_total_visits
