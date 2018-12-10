create or replace procedure create_point(
        country in varchar2,
        region in varchar2,
        city in varchar2
    )
   is
    begin
    insert into points(id,country,region,city) values(points_id.nextval,country,region,city);
    commit;
    dbms_output.put_line('Point created');
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end create_point;

create or replace procedure get_points_by_all(
        country_prm in varchar2,
        region_prm in varchar2,
        city_prm in varchar2
    )
   is
   cursor get_all is select * from points where country=country_prm or region=region_prm or city=city_prm;
   curr_row points%rowtype;
    begin
    open get_all;
    loop
    fetch get_all into curr_row;
    exit when get_all%notfound;
    dbms_output.put_line(curr_row.country||' '||curr_row.region||' '||curr_row.city);
    end loop;
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end get_points_by_all;

create or replace procedure delete_point(
        country_prm in varchar2,
        region_prm in varchar2,
        city_prm in varchar2
    )
    is
    begin
    delete from points where country=country_prm and region=region_prm and city=city_prm;
    commit;
    dbms_output.put_line('Point deleted!');
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end delete_point;
    
create or replace function get_curr_point_id(
        country_prm varchar2,
        region_prm varchar2,
        city_prm varchar2
        ) return number
        is 
        id_return number(10);
        begin
        select id into id_return from points where country=country_prm and region=region_prm and city=city_prm;
        return id_return;
end get_curr_point_id;

declare
i int :=99904;
begin
loop
exit when i=100110;
if mod(i,2)=0 then 
create_point('Belarus '||i,'Minsk '||i,'Zhodino '||i);
end if;
if mod(i,3)=0 then create_point('Belarus '||i,'Grodno '||i,'Lida '||i);
end if;
i:=i+1;
end loop;
end;
select * from points;
 delete points;

