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
    

declare
i int :=0;
begin
loop
exit when i=100000;
exec create_point('Belarus 2','Minsk2','Minsk2');
exec delete_point('Belarus 2','Minsk2','Minsk2');
exec get_points_by_all('Belarus 2',NULL,NULL);
i:=i+1;
end loop;
end;
 

