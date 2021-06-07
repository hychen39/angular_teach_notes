--  PL/SQL Handler Code Used for a PUT Request
-- hychen39@gmail.com
-- 2021/05/29
-- Assuming JSON data 
-- {"id": 1, "name":"Santa Clause Junior"}

declare
    l_body_blob blob;
    l_body_clob clob;

    l_cust_rec demo_cust%rowtype;

    /** 
    * Convert the request data in JSON format to the record type of the target table.
    */
    function convert(p_body clob) return demo_cust%rowtype as
        cust_rec demo_cust%rowtype;
    begin
    -- apex_json package:
    --  https://docs.oracle.com/en/database/oracle/application-express/19.2/aeapi/APEX_JSON.html#GUID-11919ED6-CE3D-4497-8733-F56CD27B6BFF
        apex_json.parse(p_body);
        cust_rec.id := apex_json.get_number(p_path => 'id');
        cust_rec.name := apex_json.get_varchar2(p_path => 'name');
        cust_rec.updated := current_timestamp;
        return cust_rec;
    end;
begin
    -- Get the request body in blob
    
    l_body_blob := :body;
    -- Convert the body's data type from blob to clob
    l_body_clob := UTL_RAW.cast_to_varchar2(l_body_blob);

    -- Test data;
    --l_body_clob := '{"id": 1, "name":"Santa Clause Junior"}';

    if l_body_clob is null then
        -- raise_application_error(-20001, 'body_text is null');
        htp.print('l_body_clob is EMPTY');
    end if;   

    -- get the parsed result
    l_cust_rec := convert(l_body_clob);
    -- update
    update demo_cust
    set row = l_cust_rec
    where id = l_cust_rec.id;
    commit;
    -- Response the the request
    --:status_code := 200;
    htp.prn('{"id": ' || l_cust_rec.id || '}');
end;