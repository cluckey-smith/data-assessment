with get_download_rate as (
  select date,
         variant,
         downloads / visits as download_rate
  from `eg-data-assessment.models.web_table_flat`
),

get_variant_cvr_by_date as (
  select date,
         sum(case when variant = 'A' then download_rate end) as var_a_download_rate,
         sum(case when variant = 'B' then download_rate end) as var_b_download_rate
  from get_download_rate
  group by 1
)

select date,
       var_b_download_rate / var_a_download_rate - 1 as var_b_download_rate_lift
from get_variant_cvr_by_date


