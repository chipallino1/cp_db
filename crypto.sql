create or replace procedure encode(
        password_string in varchar2
    )
   is
    output_string      VARCHAR2 (200);
    encrypted_raw      RAW (2000);             -- stores encrypted binary text
    decrypted_raw      RAW (2000);             -- stores decrypted binary text
    num_key_bytes      NUMBER := 256/8;        -- key length 256 bits (32 bytes)
    key_bytes_raw      RAW (32);               -- stores 256-bit encryption key
    encryption_type    PLS_INTEGER ; 
    begin
    encryption_type:=          -- total encryption type
                            DBMS_CRYPTO.ENCRYPT_AES256
                          + DBMS_CRYPTO.CHAIN_CBC
                          + DBMS_CRYPTO.PAD_PKCS5;
     --DBMS_OUTPUT.PUT_LINE ( 'Original string: ' || password_string);
     key_bytes_raw := DBMS_CRYPTO.RANDOMBYTES (num_key_bytes);
     encrypted_raw := DBMS_CRYPTO.ENCRYPT
      (
         src => UTL_I18N.STRING_TO_RAW (password_string,  'AL32UTF8'),
         typ => encryption_type,
         key => key_bytes_raw
      );
      insert into passwords(id,encrypted,random)
        values(passwords_id.nextval,encrypted_raw,key_bytes_raw); 
      commit;
      output_string := UTL_I18N.RAW_TO_CHAR(encrypted_raw, 'AL32UTF8');
      --DBMS_OUTPUT.PUT_LINE ( 'Encrypted string: ' || output_string);
 
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end encode;


create or replace procedure decode(
        encoded in raw,
        random in raw
    )
   is
    output_string      VARCHAR2 (200);
    encrypted_raw      RAW (2000);             -- stores encrypted binary text
    decrypted_raw      RAW (2000);             -- stores decrypted binary text
    num_key_bytes      NUMBER := 256/8;        -- key length 256 bits (32 bytes)
    key_bytes_raw      RAW (32);               -- stores 256-bit encryption key
    encryption_type    PLS_INTEGER ; 
    begin
    encryption_type:=          -- total encryption type
                            DBMS_CRYPTO.ENCRYPT_AES256
                          + DBMS_CRYPTO.CHAIN_CBC
                          + DBMS_CRYPTO.PAD_PKCS5;
    
     --DBMS_OUTPUT.PUT_LINE ( 'Encrypted string: ' || encoded);
      decrypted_raw := DBMS_CRYPTO.DECRYPT
      (
         src => encoded,
         typ => encryption_type,
         key => random
      );
      output_string := UTL_I18N.RAW_TO_CHAR (decrypted_raw, 'AL32UTF8');
      --DBMS_OUTPUT.PUT_LINE ( 'Encrypted string: ' || output_string);
      output_string := UTL_I18N.RAW_TO_CHAR(encrypted_raw, 'AL32UTF8');
 
    exception
        when others then dbms_output.put_line(sqlerrm);
                         rollback;
end decode;

