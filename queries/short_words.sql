.mode column
.width 4 4 40
select
  first_name_cnt,
  last_name_cnt,
  '>' || word || '<'
from
  word
where
  length(word) = 1;
