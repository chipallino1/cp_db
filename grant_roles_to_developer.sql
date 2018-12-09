create role railways_admin_developer_role;
grant all privileges,execute on sys.dbms_crypto to railways_admin_developer_role;
      
grant railways_admin_developer_role to railways_admin;
grant execute on sys.dbms_crypto to railways_admin;

alter user railways_admin QUOTA unlimited on simple_user_rw_ts;
alter user railways_admin QUOTA unlimited on admin_rw_ts;