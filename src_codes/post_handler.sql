--  PL/SQL Handler Code Used for a POST Request
-- hychen39@gmail.com
-- 2021/05/29
-- Assuming JSON data 
-- {"id": 1, "name":"Santa Clause"}

declare
l_body_blob blob;
l_body_clob clob;
l_content_type varchar2(200);

l_id number;
l_name varchar2(50);

begin

-- Get the request body from the implicit binding variable :body
l_body_blob := :body;
-- Get the content type
l_content_type := :content_type;

-- Convert the body's data type from blob to clob
l_body_clob := UTL_RAW.cast_to_varchar2(l_body_blob);

if l_body_clob is null then
    -- raise_application_error(-20001, 'body_text is null');
    htp.print('l_body_clob is EMPTY');
end if;

-- parse the payload using the APEX_JSON package
apex_json.parse(l_body_clob);

-- Get the fields
l_id := apex_json.get_varchar2( p_path => 'id');
l_name := apex_json.get_varchar2( p_path => 'name' );

-- check the not null 
if l_id is null then
    -- response to the request
    htp.prn('Cannot get either the user id or the token value');
end if;

-- insert data to table
insert into demo_cust
        values (l_id, l_name, default)
        RETURNing id into l_id;
commit;

-- Response the the request
--:status_code := 200;
htp.prn('{"id": ' || l_id || '}');

-- Exception handling
EXCEPTION
    when others then
      htp.prn(sqlerrm);

end;