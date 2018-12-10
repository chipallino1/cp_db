create or replace procedure create_ticket(
        place_num in int,
        carriage_num in int,
        id_route in int,
        id_train in int,
        type in varchar2
    )
   is
    begin
    insert into tickets(id,place_num,carriage_num,id_route,id_train,type)
        values(tickets_id.nextval,place_num,carriage_num,id_route,id_train,type);
    commit;
    dbms_output.put_line('Ticket created');
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end create_ticket;

create or replace procedure get_tickets_by_all(
            place_num_prm in int,
            carriage_num_prm in int,
            id_route_prm in int,
            id_train_prm in int,
            type_prm in varchar2
        )
        is
        cursor get_all is select * from tickets inner join (routes inner join points on(routes.id_from=points.id)
        inner join points on(routes.id_to=points.id)) on(routes.id=tickets.id_route)
        inner join trains on(trains.id=tickets.id_train)
        where id_train=id_train_prm or id_route=id_route_prm or place_num=place_num_prm 
        or carriage_num=carriage_num_prm or type=type_prm;
        type curr_row is record(
            id int,
            place_num int,
            carriage_num int,
            id_route int,
            id_train int,
            type varchar2(100),
            id_1 int,
            id_from int,
            id_to int,
            length int,
            date_start date,
            date_finish date,
            id_2 int,
            country varchar2(100),
            region varchar2(100),
            city varchar2(100),
            id_3 int,
            country_1 varchar2(100),
            region_1 varchar2(100),
            city_1 varchar2(100),
            id_4 int,
            name varchar2(100),
            numeration_from varchar2(100),
            count_carriages int,
            count_places_carriage int,
            count_all int
            
        );
        current_row curr_row;
    begin
    open get_all;
    loop
    fetch get_all into current_row;
    exit when get_all%notfound;
     dbms_output.put_line('Place num: '||current_row.place_num||' Carriage num: '||current_row.carriage_num||' Type: '||current_row.type);
     dbms_output.put_line('Train name: '||current_row.name || ' Num from: '||current_row.numeration_from);
    dbms_output.put_line('From: '||current_row.country||' '||current_row.region||' '||current_row.city||' To: '||current_row.country_1
    ||' '||current_row.region_1||' '||current_row.city_1);
    dbms_output.put_line('Length: '||current_row.length||' Date start: '||current_row.date_start||' '||current_row.date_finish);
    end loop;
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end get_tickets_by_all;




select * from tickets inner join (routes inner join points on(routes.id_from=points.id)
        inner join points on(routes.id_to=points.id)) on(routes.id=tickets.id_route)
        inner join trains on(trains.id=tickets.id_train)