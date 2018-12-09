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

--update current client by email (we can update email too)
create or replace procedure update_current_client_by_email(
        email_before in varchar2,
        login_prm in varchar2,
        firstname_prm in varchar2,
        lastname_prm in varchar2,
        phone_prm in varchar2,
        email_prm in varchar2
    )
    is 
        login_prm_into varchar2(45):=login_prm;
        firstname_prm_into varchar2(45):=firstname_prm;
        lastname_prm_into varchar2(45):=lastname_prm;
        phone_prm_into varchar2(45):=phone_prm;
        email_prm_into varchar2(45):=email_prm;
        curr_row clients%rowtype;
     begin
     dbms_output.put_line(login_prm||'hui'||email_before || length(login_prm));
     if  login_prm is NULL or firstname_prm is NULL or lastname_prm is NULL or phone_prm is NULL or email_prm is NULL
        then
            dbms_output.put_line('hui');
            select * into curr_row from clients where email='egor@mail.ru';
     end if;
     if login_prm is NULL
        then login_prm_into:=curr_row.login;
     end if;
     if firstname_prm is NULL 
        then firstname_prm_into:=curr_row.firstname;
     end if;
     if lastname_prm is NULL
        then lastname_prm_into:=curr_row.lastname;
     end if;
     if phone_prm is NULL 
        then phone_prm_into:=curr_row.phone;
     end if;
     if email_prm is NULL
        then email_prm_into:=email_before;
     end if;
     dbms_output.put_line(email_prm_into || '111'||curr_row.email);
     update clients set email=email_prm_into,
                        login=login_prm_into,
                        firstname=firstname_prm_into,
                        lastname=lastname_prm_into,
                        phone=phone_prm_into where email=email_before;
    commit;
     exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end update_current_client_by_email;

declare
curr_row clients%rowtype;
begin
    select * into curr_row from clients where email='egor@mail.ru';
    dbms_output.put_line(curr_row.email);
   -- create_simple_user('chipallino1','egor','skorupich','9172224','egor@mail.ru','egor');
    --exec update_current_client_by_email('egor@mail.ru',NULL,NULL,NULL,NULL,NULL);
end;