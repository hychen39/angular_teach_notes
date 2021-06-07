
declare
  l_row_count number;
begin
    DELETE demo_cust where id = :id;
    l_row_count := sql%rowcount;

    commit;
    
    :status_code := 200;
    htp.prn('{"rowCount": ' || l_row_count || '}');
    
end;
