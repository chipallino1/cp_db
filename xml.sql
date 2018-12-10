create or replace procedure verify_xml_user (p_dir IN VARCHAR2, p_filename IN  VARCHAR2)
as
  l_bfile  BFILE := BFILENAME(p_dir, p_filename);
  l_clob   CLOB;
  l_dest_offset   INTEGER := 1;
  l_src_offset    INTEGER := 1;
  l_bfile_csid    NUMBER  := 0;
  l_lang_context  INTEGER := 0;
  l_warning       INTEGER := 0;
  temp xmltype;
  v_un varchar(15);
  v_pw varchar(15);
  cur sys_refcursor;
  exp sys_refcursor;
  rl varchar(15);
  usn varchar(20);
  psw varchar(20);
  my_error xmltype;
begin
  DBMS_LOB.createtemporary (l_clob, TRUE);
  DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
  DBMS_LOB.loadclobfromfile (dest_lob => l_clob, src_bfile => l_bfile, amount => DBMS_LOB.lobmaxsize,
    dest_offset => l_dest_offset, src_offset => l_src_offset, bfile_csid => l_bfile_csid ,
    lang_context => l_lang_context, warning => l_warning);
  DBMS_LOB.fileclose(l_bfile);
  COMMIT;
  temp := XMLTYPE.createXML(l_clob);
  for rec in (select extract(value(t), 'ROW/EMAIL') as res from table(XMLSequence(temp.extract('ROWSET/ROW')))t)
    loop
      select extractValue(value(t1), 'EMAIL') into v_un from table(XMLSequence(rec.res.extract('EMAIL')))t1;
    end loop;
  for rec in (select extract(value(t), 'ROW/PASSWORD') as res from table(XMLSequence(temp.extract('ROWSET/ROW')))t)
    loop
      select extractValue(value(t1), 'PASSWORD') into v_pw from table(XMLSequence(rec.res.extract('PASSWORD')))t1;
    end loop;
  dbms_output.put_line(v_un); 
  dbms_output.put_line(v_pw);
  DBMS_LOB.freetemporary (l_clob);
  
  verify_user(v_un,v_pw);
  
  commit;
  exception 
    when others then
      dbms_output.put_line(sqlerrm||' '||sqlcode); rollback;
end verify_xml_user;

exec verify_xml_user('XMLDIR_3','new_client.xml');

create directory XMLDIR_3 as 'c:/xml/';
create or replace procedure get_xml_clients is 
  cur sys_refcursor;
begin
  open cur for select * from clients;
  dbms_xslprocessor.clob2file( xmltype( cur ).getclobval( ) , 'XMLDIR_3','clients.xml');
  close cur;
  commit;
  exception 
    when others then
      dbms_output.put_line(sqlerrm||' '||sqlcode); rollback;
end get_xml_clients;

exec get_xml_clients();
