create or replace procedure create_train(
        name in varchar2,
        numeration_from in varchar2,
        count_carriages in int,
        count_places_carriage in int,
        count_all in int
    )
    is
    begin
    insert into trains(id,name,numeration_from,count_carriages,count_places_carriage,count_all) 
        values(trains_id.nextval,name,numeration_from,count_carriages,count_places_carriage,count_all);
    commit;
    dbms_output.put_line('Train created');
    exception 
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end create_train;

create or replace procedure get_trains_by_all(
        name_prm in varchar2,
        numeration_from_prm in varchar2,
        count_carriages_prm in int,
        count_places_carriage_prm in int,
        count_all_prm in int
    )
    is
    cursor get_all is select * from trains where name=name_prm or numeration_from=numeration_from_prm or count_carriages=count_carriages_prm 
        or count_places_carriage=count_places_carriage_prm or count_all=count_all_prm;
    cursorRow trains%rowtype;
    begin
        open get_all;
        loop
        fetch get_all into cursorRow;
        exit when get_all%notfound;
        dbms_output.put_line(cursorRow.name ||' '|| cursorRow.numeration_from||' '||cursorRow.count_carriages||' '||
        cursorRow.count_places_carriage||' '||cursorRow.count_all);
        end loop;
    exception 
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end get_trains_by_all;

create or replace procedure update_train(
        name_before in varchar2,
        name_prm in varchar2,
        numeration_from_prm in varchar2,
        count_carriages_prm in int,
        count_places_carriage_prm in int,
        count_all_prm in int
    )
    is
        name_prm_into varchar2(45):=name_prm;
        numeration_from_prm_into varchar2(45):=numeration_from_prm;
        count_carriages_prm_into int:=count_carriages_prm;
        count_places_carriage_prm_into int:=count_places_carriage_prm;
        count_all_prm_into int:=count_all_prm;
    curr_row trains%rowtype;
    begin
        if  name_prm is NULL or numeration_from_prm is NULL or count_carriages_prm is NULL or count_places_carriage_prm is NULL 
        or count_all_prm is NULL
        then
            select * into curr_row from trains where name=name_before;
     end if;
     if name_prm is NULL
        then name_prm_into:=curr_row.name;
     end if;
     if numeration_from_prm is NULL 
        then numeration_from_prm_into:=curr_row.numeration_from;
     end if;
     if count_carriages_prm is NULL
        then count_carriages_prm_into:=curr_row.count_carriages;
     end if;
     if count_places_carriage_prm is NULL 
        then count_places_carriage_prm_into:=curr_row.count_places_carriage;
     end if;
     if count_all_prm is NULL
        then count_all_prm_into:=curr_row.count_all;
     end if;
        update trains set name=name_prm_into,
                          numeration_from=numeration_from_prm_into,
                          count_carriages=count_carriages_prm_into,
                          count_places_carriage=count_places_carriage_prm_into,
                          count_all=count_all_prm_into where name=name_before;
        commit;
        dbms_output.put_line('Train updated!');
    exception 
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end update_train;

create or replace procedure delete_train(
            name_prm in varchar2
        )
        is
        begin
        delete trains where name=name_prm;
        commit;
        dbms_output.put_line('Train deleted!');
        exception
            when others then dbms_output.put_line(sqlerrm);
                        rollback;
end delete_train;

create or replace procedure add_count_carriages(
    name_prm in varchar2,
    add_count in int
        )
        is
        begin
        update trains set count_carriages=count_carriages+add_count where name=name_prm;
        commit;
        dbms_output.put_line('Train updated!');
        exception
            when others then dbms_output.put_line(sqlerrm);
                        rollback;
end add_count_carriages;
select * from trains where id=145030


select * from trains where 
exec get_trains_by_all('Suka','he1ad',22,'','');
exec update_train('Train 2','Suka','head',23,23,23);
exec delete_train('Train 22');