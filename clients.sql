--create a new simple user with params
create or replace procedure create_simple_user(
        login in varchar2,
        firstname in varchar2,
        lastname in varchar2,
        phone in varchar2,
        email in varchar2,
        type in varchar2,
        password in varchar2
    )
   is
    begin
    encode_crypto(password);
    insert into clients(id,login,firstname,lastname,phone,email,type,id_password) 
        values(clients_id.nextval,login,firstname,lastname,phone,email,type,passwords_id.currval);
    commit;
    dbms_output.put_line('User created');
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
        email_prm in varchar2,
        type_prm in varchar2
    )
    is
        cursor get_all_clients is select * from clients where clients.login=login_prm
        or clients.firstname=firstname_prm
        or clients.lastname=lastname_prm
        or clients.phone=phone_prm
        or clients.email=email_prm
        or clients.type=type_prm;
        currClient clients%rowtype;
     begin
        open get_all_clients;
        loop
        fetch get_all_clients into currClient;
        exit when get_all_clients%notfound;
        dbms_output.put_line(currClient.login||' '||currClient.firstname||' '||currClient.lastname||' '|| currclient.phone||' '||currclient.email ||' '||currclient.type);
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
        email_prm in varchar2,
        type_prm in varchar2
    )
    is 
        login_prm_into varchar2(45):=login_prm;
        firstname_prm_into varchar2(45):=firstname_prm;
        lastname_prm_into varchar2(45):=lastname_prm;
        phone_prm_into varchar2(45):=phone_prm;
        email_prm_into varchar2(45):=email_prm;
        type_prm_into varchar2(45):=type_prm;
        curr_row clients%rowtype;
     begin
     if  login_prm is NULL or firstname_prm is NULL or lastname_prm is NULL or phone_prm is NULL or email_prm is NULL or type_prm is NULL
        then
            select * into curr_row from clients where email=email_before;
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
     if type_prm is NULL
        then type_prm_into:=type_prm;
     end if;
     update clients set email=email_prm_into,
                        login=login_prm_into,
                        firstname=firstname_prm_into,
                        lastname=lastname_prm_into,
                        phone=phone_prm_into,
                        type=type_prm_into where email=email_before;
    commit;
    dbms_output.put_line('User updated');
     exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end update_current_client_by_email;

create or replace procedure delete_current_client(
            email_prm in varchar2
        )
        is
        begin
            delete clients where email=email_prm;
            commit;
            dbms_output.put_line('User deleted');
        exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end delete_current_client;

create or replace procedure make_simple_user_as_admin(
            email_prm in varchar2
        )
        is
        begin
        update clients set type='ADMIN_USER' where email=email_prm;
        commit;
        dbms_output.put_line('User made as admin');
         exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end make_simple_user_as_admin;

create or replace procedure verify_user(
            email_prm in varchar2,
            password_prm in varchar2 
        )
        is
            type login_params is record(
            email varchar2(45),
            encrypted raw(2000),
            random raw(32)
            );
            params login_params;
            decoded_string varchar2(100);
            pw_incorrect_exc exception;
            pragma exception_init(pw_incorrect_exc,-20001);
        begin
            select email,encrypted,random into params from clients inner join passwords on(clients.id_password=passwords.id)
            where email=email_prm;
            decode_crypto(params.encrypted,params.random,decoded_string);
            if decoded_string=password_prm
                then dbms_output.put_line('User logined');
            else
              raise_application_error(-20001,'Password definitely incorrect.');
            end if;
                
        exception
        when pw_incorrect_exc then dbms_output.put_line(sqlerrm);
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end verify_user;


declare
i int :=160000;
begin
loop
exit when i=170110;
if mod(i,2)=0 then 
create_simple_user('chip '||i,'Egor '|| i,'Skorupich '||i,'91272'||i,'egor'||i||'@mail.ru','SIMPLE_USER','egor'||i);
end if;
if mod(i,3)=0 then create_simple_user('makina '||i,'Misha '|| i,'Kaminskiy '||i,'1272'||i,'mk'||i||'@mail.ru','SIMPLE_USER','lexa'||i);
end if;
i:=i+1;
end loop;
end;


select * from clients;