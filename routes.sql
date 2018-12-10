create or replace procedure create_route(
        id_from in int,
        id_to in int,
        length in int,
        date_start in date,
        date_finish in date
    )
   is
    begin
    insert into routes(id,id_from,id_to,length,date_start,date_finish) 
        values(routes_id.nextval,id_from,id_to,length,date_start,date_finish);
    commit;
    dbms_output.put_line('Route created');
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end create_route;

create or replace procedure get_routes_by_all(
            id_from_prm in int,
            id_to_prm in int,
            length_prm in int,
            date_start_prm in date,
            date_finish_prm in date
        )
        is
        cursor get_all is select * from routes inner join points on(routes.id_from=points.id)
        inner join points on(routes.id_to=points.id)
        where id_from=id_from_prm or id_to=id_to_prm or length=length_prm 
        or date_start=date_start_prm or date_finish=date_finish_prm;
        type curr_row is record(
            id int,
            id_from int,
            id_to int,
            length int,
            date_start date,
            date_finish date,
            id_1 int,
            country varchar2(100),
            region varchar2(100),
            city varchar2(100),
            id_2 int,
            country_1 varchar2(100),
            region_1 varchar2(100),
            city_1 varchar2(100)
        );
        current_row curr_row;
    begin
    open get_all;
    loop
    fetch get_all into current_row;
    exit when get_all%notfound;
    dbms_output.put_line('From: '||current_row.country||' '||current_row.region||' '||current_row.city||' To: '||current_row.country_1
    ||' '||current_row.region_1||' '||current_row.city_1);
    dbms_output.put_line('Length: '||current_row.length||' Date start: '||current_row.date_start||' '||current_row.date_finish);
    end loop;
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end get_routes_by_all;

create or replace procedure delete_route(
        id_prm int
    )
    is
    begin
        delete routes where id=id_prm;
        commit;
        dbms_output.put_line('Route deleted!');
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end delete_route;

declare
i int :=0;
begin
loop
exit when i=100110;
if mod(i,2)=0 then 
create_route(i+103251,i+103251+1,i*10,TO_DATE('2018-'||round(dbms_random.value(1,12))||'-'||round(dbms_random.value(1,28))||' '
||round(dbms_random.value(0,23))||':'||round(dbms_random.value(0,59)),'YYYY-MM-DD HH24:MI')
,TO_DATE('2018-'||round(dbms_random.value(1,12))||'-'||round(dbms_random.value(1,28))||' '
||round(dbms_random.value(0,23))||':'||round(dbms_random.value(0,59)),'YYYY-MM-DD HH24:MI'));
end if;
if mod(i,3)=0 then create_route(i+103251+2,i+103251+3,i*10,TO_DATE('2018-'||round(dbms_random.value(1,12))||'-'||round(dbms_random.value(1,28))||' '
||round(dbms_random.value(0,23))||':'||round(dbms_random.value(0,59)),'YYYY-MM-DD HH24:MI')
,TO_DATE('2018-'||round(dbms_random.value(1,12))||'-'||round(dbms_random.value(1,28))||' '
||round(dbms_random.value(0,23))||':'||round(dbms_random.value(0,59)),'YYYY-MM-DD HH24:MI'));
end if;
i:=i+1;
end loop;
end;
        
exec get_routes_by_all(170121,170124,668660,NULL,NULL);
exec delete_route(145000);
select * from routes where id=145000;