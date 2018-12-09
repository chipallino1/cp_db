--for admin user application
create tablespace admin_rw_ts
    datafile 'c:\app\chipallino1\oradata\orcl\tablespaces\admin_rw_ts.dbf'
    size 10m
    autoextend on next 500k
    maxsize 100m
    extent management local;
create temporary tablespace admin_rw_temp_ts
    tempfile 'c:\app\chipallino1\oradata\orcl\tablespaces\admin_rw_temp_ts.dbf'
    size 10m
    autoextend on next 500k
    maxsize 100m
    extent management local;
--for simple user application
create tablespace simple_user_rw_ts
    datafile 'c:\app\chipallino1\oradata\orcl\tablespaces\simple_user_rw_ts.dbf'
    size 10m
    autoextend on next 500k
    maxsize 100m
    extent management local;
create temporary tablespace simple_user_rw_temp_ts
    tempfile 'c:\app\chipallino1\oradata\orcl\tablespaces\simple_user_rw_temp_ts.dbf'
    size 10m
    autoextend on next 500k
    maxsize 100m
    extent management local;
    

create role simple_user_role;
create role admin_user_role;

grant create session to simple_user_role;
grant create session to admin_user_role;

create profile railways_pf_core limit
    password_life_time 180
    SESSIONS_PER_USER 5
    FAILED_LOGIN_ATTEMPTS 10
    PASSWORD_LOCK_TIME 1
    PASSWORD_REUSE_TIME 1
    PASSWORD_GRACE_TIME DEFAULT
    CONNECT_TIME 500
    IDLE_TIME 100;

create user simple_user identified by 10101998
    default tablespace simple_user_rw_ts quota unlimited on simple_user_rw_ts
    temporary tablespace simple_user_rw_temp_ts
    profile railways_pf_core
    account unlock;

create user admin_user identified by 10101998
    default tablespace admin_rw_ts quota unlimited on admin_rw_ts
    temporary tablespace admin_rw_temp_ts
    profile railways_pf_core
    account unlock;
    
grant simple_user_role to simple_user;
grant admin_user_role to admin_user;



      