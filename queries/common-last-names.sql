.mode column
.width 6 100
select
  last_name_cnt,
  word
from
  word
order by
  last_name_cnt desc
limit
  10000;
