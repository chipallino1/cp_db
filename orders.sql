create or replace procedure create_order(
        id_ticket in int,
        id_client in int,
        cost in int,
        date_order in date,
        date_payment in date
    )
   is
    begin
    insert into orders(id,id_ticket,
        id_client,
        cost,
        date_order,
        date_payment)
        values(orders_id.nextval,id_ticket,
        id_client,
        cost,
        date_order,
        date_payment);
    commit;
    dbms_output.put_line('Order created');
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end create_order;

create or replace procedure get_orders_by_all(
           id_ticket_prm in int,
        id_client_prm in int,
        cost_prm in int,
        date_order_prm in date,
        date_payment_prm in date
        )
        is
        cursor get_all is select * from orders inner join clients on(orders.id_client=clients.id)
        inner join tickets on (orders.id_ticket=tickets.id)
        inner join (routes inner join points on(routes.id_from=points.id)
        inner join points on(routes.id_to=points.id)) on(routes.id=tickets.id_route)
        inner join trains on(trains.id=tickets.id_train)
        where id_ticket=id_ticket_prm or id_client=id_client_prm or cost=cost_prm or date_order=date_order_prm or date_payment=date_payment_prm;
        type curr_row is record(
            id int,
            id_ticket int,
            id_client int,
            cost int,
            date_order date,
            date_payment date,
            id_1 int,
            login varchar2(100),
            firstname varchar2(100),
            lastname varchar2(100),
            phone varchar2(100),
            email varchar2(100),
            type varchar2(100),
            id_password int,
            id_2 int,
            place_num int,
            carriage_num int,
            id_route int,
            id_train int,
            type_1 varchar2(100),
            id_3 int,
            id_from int,
            id_to int,
            length int,
            date_start date,
            date_finish date,
            id_4 int,
            country varchar2(100),
            region varchar2(100),
            city varchar2(100),
            id_5 int,
            country_1 varchar2(100),
            region_1 varchar2(100),
            city_1 varchar2(100),
            id_6 int,
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
    dbms_output.put_line('Login: '||current_row.login||' Fname: '||current_row.firstname||' Lname: '||current_row.lastname);
    dbms_output.put_line('Cost: '||current_row.cost|| ' Date order: '||current_row.date_order ||' Date payment: '|| current_row.date_payment);
     dbms_output.put_line('Place num: '||current_row.place_num||' Carriage num: '||current_row.carriage_num||' Type: '||current_row.type);
     dbms_output.put_line('Train name: '||current_row.name || ' Num from: '||current_row.numeration_from);
    dbms_output.put_line('From: '||current_row.country||' '||current_row.region||' '||current_row.city||' To: '||current_row.country_1
    ||' '||current_row.region_1||' '||current_row.city_1);
    dbms_output.put_line('Length: '||current_row.length||' Date start: '||current_row.date_start||' '||current_row.date_finish);
    end loop;
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end get_orders_by_all;


declare
i int :=0;
begin
loop
exit when i=100110;
if mod(i,2)=0 then 
create_order(i+1,i,i+2,TO_DATE('2018-'||round(dbms_random.value(1,12))||'-'||round(dbms_random.value(1,28))||' '
||round(dbms_random.value(0,23))||':'||round(dbms_random.value(0,59)),'YYYY-MM-DD HH24:MI'),NULL);
end if;
if mod(i,3)=0 then create_order(i,i+1,i+1,TO_DATE('2018-'||round(dbms_random.value(1,12))||'-'||round(dbms_random.value(1,28))||' '
||round(dbms_random.value(0,23))||':'||round(dbms_random.value(0,59)),'YYYY-MM-DD HH24:MI'),TO_DATE('2018-'||round(dbms_random.value(1,12))||'-'||round(dbms_random.value(1,28))||' '
||round(dbms_random.value(0,23))||':'||round(dbms_random.value(0,59)),'YYYY-MM-DD HH24:MI'));
end if;
i:=i+1;
end loop;
end;

select * from orders;

exec get_orders_by_all(null,null,null,'24.03.18','19.11.18');
