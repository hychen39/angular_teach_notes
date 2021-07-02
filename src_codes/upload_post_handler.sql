declare
    l_image_id number :=0;  
    l_url varchar2(300);
    l_body blob;
    l_err_msg VARCHAR2(300);
begin
    -- uploaded file is placed in the body.
    -- Restful service does not support the multipart/form-data protocal
    l_body := :body;

    -- :body is defined by ORDS
    -- :file_name, :file_type are defined in the parameter panel.
    insert into demo_media
             values  ( DEMO_MEDIA_SEQ.nextval , :file_name, :file_type, l_body)
             RETURN id into l_image_id;
    commit;

    -- http status code that is defined in the parameter panel.
    :status := 201; 

    -- Set the Location parameter in the http request
    -- './' represents the module uri
    -- The URL for the resource URL template media/:id/content
    :location := './media/' || l_image_id || '/content'; 
    
--        l_url := 'Bind Variables: ' || :file_name || ' ' || :file_type;

        -- response body
--        htp.prn(l_url);
--     :location := APEX_UTIL.URL_ENCODE (p_url => l_url) ;
--      insert into demo_debug 
--            VALUES (demo_debug_seq.nextval, l_url , current_timestamp, l_body);
--    commit;
exception
    WHEN OTHERS then
        l_err_msg := sqlerrm;
        insert into demo_debug 
            VALUES (demo_debug_seq.nextval, l_err_msg, current_timestamp, l_body);
    commit;
end;

