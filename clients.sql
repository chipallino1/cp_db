--create a new simple user with params
create or replace procedure create_simple_user(
        login in varchar2,
        firstname in varchar2,
        lastname in varchar2,
        phone in varchar2,
        email in varchar2,
        password in varchar2
    )
   is
    begin
    encode(password);
    insert into clients(id,login,firstname,lastname,phone,email,type,id_password) 
        values(clients_id.nextval,login,firstname,lastname,phone,email,'SIMPLE_USER',passwords_id.currval);
    commit;
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end create_simple_user;

--get all clients by all params
create or replace procedure get_clients_by_all(
    login_prm in varchar2,
        firstname_prm in varchar2,
        lastname_prm in varchar2,
        phone_prm in varchar2,
        email_prm in varchar2
    )
    is
        cursor get_all_clients is select * from clients where clients.login=login_prm or clients.firstname=firstname_prm or clients.lastname=lastname_prm or clients.phone=phone_prm or clients.email=email_prm;
        currClient clients%rowtype;
     begin
        open get_all_clients;
        loop
        fetch get_all_clients into currClient;
        exit when get_all_clients%notfound;
        dbms_output.put_line(currClient.login||' '||currClient.firstname||' '||currClient.lastname||' '|| currclient.phone||' '||currclient.email);
        end loop;
     exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end get_clients_by_all;
