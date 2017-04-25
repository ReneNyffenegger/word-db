.mode column
.width 6 100
select
  first_name_cnt,
  word
from
  word
where
  first_name_cnt < 3 and
  first_name_cnt > 0
order by
  first_name_cnt;
