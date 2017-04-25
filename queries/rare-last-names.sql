.mode column
.width 6 100
select
  last_name_cnt,
  word
from
  word
where
  last_name_cnt < 3 and
  last_name_cnt > 0
order by
  last_name_cnt;

