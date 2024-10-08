select a.id,b.id,b.pad,a.t_id from (select id,t_id from test1) a,(select * from sbtest.test2) b where a.t_id=b.o_id;
select test1.id,test1.t_id,test1.name,test1.pad,test2.id,test2.o_id,test2.name,test2.pad from test1 inner join test2 order by test1.id,test2.id;
select test1.id,test1.t_id,test1.name,test1.pad,test2.id,test2.o_id,test2.name,test2.pad from test1 cross join test2 order by test1.id,test2.id;
select test1.id,test1.t_id,test1.name,test1.pad,test2.id,test2.o_id,test2.name,test2.pad from test1 join test2 order by test1.id,test2.id;
select test1.id,test1.t_id,test1.name,test1.pad,sbtest.test2.id,sbtest.test2.o_id,sbtest.test2.name,sbtest.test2.pad from test1 straight_join sbtest.test2 order by test1.id,test2.id;
select test1.id,test1.t_id,test1.name,test1.pad,sbtest.test2.id,sbtest.test2.o_id,sbtest.test2.name,sbtest.test2.pad from test1 left join sbtest.test2 on test1.pad=sbtest.test2.pad order by test1.id,test2.id;
select test1.id,test1.t_id,test1.name,test1.pad,sbtest.test2.id,sbtest.test2.o_id,sbtest.test2.name,sbtest.test2.pad from test1 right join sbtest.test2 on test1.pad=sbtest.test2.pad order by test1.id,test2.id;
select test1.id,test1.t_id,test1.name,test1.pad,sbtest.test2.id,sbtest.test2.o_id,sbtest.test2.name,sbtest.test2.pad from test1 left outer join sbtest.test2 on test1.pad=sbtest.test2.pad order by test1.id,test2.id;
select test1.id,test1.t_id,test1.name,test1.pad,sbtest.test2.id,sbtest.test2.o_id,sbtest.test2.name,sbtest.test2.pad from test1 right outer join sbtest.test2 on test1.pad=sbtest.test2.pad order by test1.id,test2.id;
select test1.id,test1.t_id,test1.name,test1.pad,sbtest.test2.id,sbtest.test2.o_id,sbtest.test2.name,sbtest.test2.pad from test1 left join sbtest.test2 using(pad) order by test1.id,test2.id;
select test1.id,test1.t_id,test1.name,test1.pad,sbtest.test2.id,sbtest.test2.o_id,sbtest.test2.name,sbtest.test2.pad from test1 left join sbtest.test2 on test1.pad=sbtest.test2.pad and test1.id>3 order by test1.id,test2.id;
select id,O_ORDERKEY,O_TOTALPRICE from test8 where id>36900 and id<36902 group by O_ORDERKEY  having O_ORDERKEY in (select O_ORDERKEY from test8 group by id having sum(id)>10000);
select test8.O_ORDERKEY,test8.O_CUSTKEY,C_NAME from test6 CROSS join sbtest.test8 using(id) order by test8.O_ORDERKEY,test8.O_CUSTKEY,C_NAME;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_013' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by o_custkey;   
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by 2;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by count(O_ORDERKEY);
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by counts asc,2 desc;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by count(O_ORDERKEY) asc,2 desc limit 10;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by count(O_ORDERKEY) asc,O_CUSTKEY desc limit 1,10;
select sum(O_TOTALPRICE) as sums,O_CUSTKEY,count(O_ORDERKEY) counts from test9 where O_CUSTKEY between 'CUSTKEY_002' and 'CUSTKEY_050' group by 2 asc having O_CUSTKEY<(select max(c_custkey) from test7) order by count(O_ORDERKEY) asc,O_CUSTKEY desc limit 10 offset 1;
select UPPER((select C_NAME FROM test7 limit 1)) FROM test7 limit 1;
select O_ORDERKEY,O_CUSTKEY from test9 as a where a.O_CUSTKEY=(select min(C_CUSTKEY) from test7);
select O_ORDERKEY,O_CUSTKEY from test9 as a where a.O_CUSTKEY<=(select min(C_CUSTKEY) from test7);
select O_ORDERKEY,O_CUSTKEY from test9 as a where a.O_CUSTKEY<=(select min(C_CUSTKEY)+1 from test7);
select count(*) from sbtest.test7 as a where a.c_CUSTKEY=(select max(C_CUSTKEY) from test9 where C_CUSTKEY=a.C_CUSTKEY);
select C_CUSTKEY  from sbtest.test7 as a where (select count(*) from test9 where O_CUSTKEY=a.C_CUSTKEY)=2;
select count(*) from test9 as a where a.id <> all(select id from test7);
select count(*) from test9 as a where 56000< all(select id from test7);
select count(*) from sbtest.test7 as a where 2>all(select count(*) from test9 where O_CUSTKEY=C_CUSTKEY);
select id,O_CUSTKEY,O_ORDERKEY,O_TOTALPRICE from test9 a where (a.O_ORDERKEY,O_CUSTKEY)=(select c_ORDERKEY,c_CUSTKEY from test7 where c_name='yanglu');
select id,pad from test1 where pad>(select pad from test1 where id=2);
select id,pad from test1 where pad<(select pad from test1 where id=2);
select id,pad from test1 where pad=(select pad from test1 where id=2);
select id,pad from test1 where pad>=(select pad from test1 where id=2);
select id,pad from test1 where pad<=(select pad from test1 where id=2);
select id,pad from test1 where pad<>(select pad from test1 where id=2);
select id,pad from test1 where pad !=(select pad from test1 where id=2);
select id,t_id,name,pad from test1 where exists(select * from test1 where pad>1);
select id,t_id,name,pad from test1 where not exists(select * from test1 where pad>1);
select id,t_id,name,pad from test1 where pad=some(select id from test1 where pad>1);
select id,t_id,name,pad from test1 where pad=any(select id from test1 where pad>1);
select id,t_id,name,pad from test1 where pad !=any(select id from test1 where pad=3);
select id,t_id,name,pad from test1 where pad>(select pad from test1 where pad=2);
select id,t_id,name,pad from test1 where 2 >any(select id from test1 where pad>1);
select id,t_id,name,pad from test1 where 2<>some(select id from test1 where pad>1);
select id,t_id,name,pad from test1 where 2>all(select id from test1 where pad<1);
select co1,co2,co3 from (select id as co1,name as co2,pad as co3 from test1)as tb where co1>1;
