.mode column
.width 6 100
select
  first_name_cnt,
  word
from
  word
order by
  first_name_cnt desc
limit
  1000;
