
drop table clients;
drop table tickets;
drop table routes;
drop table points;
drop table orders;
drop table passwords;
drop table trains;

drop sequence clients_id;
drop sequence tickets_id;
drop sequence routes_id;
drop sequence points_id;
drop sequence orders_id;
drop sequence passwords_id;
drop table trains_id;

create table clients(
  id int not null primary key,
  login varchar2(45) UNIQUE not null,
  firstname varchar2(45) not null,
  lastname varchar2(45) not null,
  phone varchar2(45) unique not null,
  email varchar2(45) unique not null,
  type varchar2(45) not null,
  id_password int not null
) tablespace simple_user_rw_ts;
create sequence clients_id
    increment by 1
    start with 1
    nomaxvalue
    nominvalue
    nocycle
    order;
create table tickets(
  id int not null primary key,
  place_num int not null,
  carriage_num int not null,
  id_route int not null,
  id_train int not null,
  type varchar2(45)
) tablespace admin_rw_ts;
create sequence tickets_id
    increment by 1
    start with 1
    nomaxvalue
    nominvalue
    nocycle
    order;
create table routes(
  id int not null primary key,
  id_from int not null,
  id_to int not null,
  length int not null,
  date_start date not null,
  date_finish date not null
  
)tablespace admin_rw_ts;
create sequence routes_id
    increment by 1
    start with 1
    nomaxvalue
    nominvalue
    nocycle
    order;
create table points(
  id int not null primary key,
  country varchar2(100) not null,
  region varchar2(100) not null,
  city varchar2(100) not null
)tablespace admin_rw_ts;
create sequence points_id
    increment by 1
    start with 1
    nomaxvalue
    nominvalue
    nocycle
    order;
create table orders(
  id int not null primary key,
  id_ticket int not null,
  id_client int not null,
  cost int not null,
  date_order date,
  date_payment date
)tablespace admin_rw_ts;
create sequence orders_id
    increment by 1
    start with 1
    nomaxvalue
    nominvalue
    nocycle
    order;
create table passwords(
  id int not null primary key,
  encrypted raw(2000) not null,
  random raw(32) not null
) tablespace simple_user_rw_ts;
create sequence passwords_id
    increment by 1
    start with 1
    nomaxvalue
    nominvalue
    nocycle
    order;
create table trains(
  id int not null primary key,
  name varchar2(45) unique not null,
  numeration_from varchar2(45),
  count_carriages int not null,
  count_places_carriage int not null,
  count_all int not null
)tablespace admin_rw_ts;
create sequence trains_id
    increment by 1
    start with 1
    nomaxvalue
    nominvalue
    nocycle
    order;


alter table clients add foreign key (id_password) references passwords(id);

alter table tickets add foreign key (id_route) references routes(id);

alter table orders add foreign key (id_client) references clients(id);

alter table orders add foreign key (id_ticket) references tickets(id);

alter table routes add foreign key (id_from) references points(id);

alter table routes add foreign key (id_to) references points(id);

alter table tickets add foreign key (id_train) references trains(id);