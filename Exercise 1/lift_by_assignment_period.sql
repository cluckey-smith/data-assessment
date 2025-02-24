with get_assignment_rates as (
  select a.date,
         a.variant,
         a.visits,
         a.downloads,
         round(b.pct_total_visits, 2) pct_total_visits
  from `eg-data-assessment.models.web_table_flat` as a
  left join `eg-data-assessment.models.web_pct_assignment` as b
    on a.date = b.date
       and a.variant = b.variant
)

select variant,
       sum(visits) as visits,
       sum(downloads) as downloads
from get_assignment_rates
where pct_total_visits in (0.8, 0.2)
group by 1

