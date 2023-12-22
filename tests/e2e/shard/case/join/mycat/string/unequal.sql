select count(id) as counts,date_format(MYDATE,'%Y-%m') as mouth from test8 where id>1 and id<50 group by 2 asc;
select sum(O_TOTALPRICE) as sums,id from test8 where id>1 and id<50 group by 2 asc;
select a.c_CUSTKEY,a.C_NAME,b.O_ORDERKEY from sbtest1.test6 as a left join test8 b on b.O_CUSTKEY=a.C_CUSTKEY and a.C_CUSTKEY<'CUSTKEY_300';
select a.c_CUSTKEY,a.C_NAME,b.O_ORDERKEY from test8 b right join sbtest1.test6 as a on b.O_CUSTKEY=a.C_CUSTKEY and a.c_CUSTKEY<'CUSTKEY_300';
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_003' and 'CUSTKEY_500' group by 2 asc having sums>400 order by o_custkey;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_003' and 'CUSTKEY_500' group by 2 asc having sums>400 order by 2;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_003' and 'CUSTKEY_500' group by 2 asc having sums>400 order by count(O_ORDERKEY), sums;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_003' and 'CUSTKEY_500' group by 2 asc having sums>400 order by counts asc,2 desc;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by 2;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by count(O_ORDERKEY);
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by counts asc,2 desc;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_003' and 'CUSTKEY_500' group by 2 asc having sums>400 order by count(O_ORDERKEY) asc,2 desc limit 2;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_003' and 'CUSTKEY_500' group by 2 asc having sums>400 order by count(O_ORDERKEY) asc,O_CUSTKEY desc limit 1,3;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_003' and 'CUSTKEY_500' group by 2 asc having sums>400 order by count(O_ORDERKEY) asc,O_CUSTKEY desc limit 10 offset 1;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by count(O_ORDERKEY) asc,2 desc limit 10;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by count(O_ORDERKEY) asc,O_CUSTKEY desc limit 1,10;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by count(O_ORDERKEY) asc,O_CUSTKEY desc limit 10 offset 1;
select a.c_CUSTKEY,a.C_NAME,b.O_ORDERKEY from sbtest1.test7 as a left join test9 b ignore index for join(ORDERS_FK1) on b.O_CUSTKEY=a.c_CUSTKEY and a.c_CUSTKEY<'CUSTKEY_300';
select a.c_CUSTKEY,a.C_NAME,b.O_ORDERKEY from sbtest1.test7 as a force index for join(primary) left join test9 b ignore index for join(ORDERS_FK1) on b.O_CUSTKEY=a.c_CUSTKEY and a.c_CUSTKEY<'CUSTKEY_300';
select O_ORDERKEY,O_CUSTKEY from test9 as a where a.O_CUSTKEY<=(select min(C_CUSTKEY)+1 from test7);
select count(*) from test9 as a where 56000< all(select id from test7);
SELECT /*+ MAX_EXECUTION_TIME(1000) */ * FROM t1 INNER JOIN t2 where t1.col1 = t2.col1;
SELECT * FROM t1, t2;
SELECT * FROM t1 AS u, t2;
SELECT * FROM t1, t2 AS u;
SELECT * FROM t1 AS u, t2 AS v;
SELECT * FROM t, t1, t2;
SELECT * from t1, t2, t3;
select * from t1 join t2 left join t3 on t2.id = t3.id;
select count(distinct col1, col2) from t;
select count(distinctrow col1, col2) from t;
select group_concat(col2,col1 SEPARATOR ';') from t group by col1;
select * from t full, t1 `row`, t2 abs;
select * from t use index for group by (idx1) use index for order by (idx2), t2;
select (select name from test1 limit 1);
select CURRENT_USER FROM test5;

