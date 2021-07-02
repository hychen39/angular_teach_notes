
# Unit 21 使用 Oracle ORDS 提供 Restful Service

@import "css/images.css"
@import "css/header_numbering.css"
@import "css/step_numbering.css"

## 簡介

Outlines:
- What is the Oracle ORDS?
- 使用 SQLDeveloper 設定資料庫的 ORDS 
  - Module and its url prefix
  - resource template and its uri pattern
  - resource handler
- 帶參數的 GET 操作

- Parse the JSON data
- 範例程式
  - Post
  - Get 
  - Put
  - Delete
- 測試工具
- ORDS-Specific Bind Variables


### Restful service 的觀念回顧

[Unit 10: RESTful Service 使用 JAX-RS 2.0 – Basic Concepts @ hychen39.github.io](https://hychen39.github.io/jsf_teaching/2019/03/11/JSF_Unit10.html)

### What is the Oracle ORDS?

- ORDS = Oracle Rest Data Service
- 為 Table 及 View 提供  Restful service

More Info: [Oracle REST Data Services - REST APIs for Oracle Database @ THAT JEFF SMITH](https://www.thatjeffsmith.com/oracle-rest-data-services-ords/)

 **Architecture**
![](img/u21-i01.png)

Src: https://www.oracle.com/technetwork/developer-tools/apex/learnmore/apex-ebs-extension-white-paper-345780.pdf




## ORACLE REST URL structure

### 結構
Oracle ORDS 的 Resource 結構: 從 Schema 到 Resource handler
`schema --(0..n) module --(0..n)resource template--(0..n)resource handler`

ORACLE REST URL 結構:
`POST http://<HOST>:<PORT>/ords/<schema>/<module_prefix>/<resource_uri>`

-  schema: DB Schema 的名稱
-  module_prifix: modules 的 URI 前置(URI prefix)符號
-  resource_uri: resource template 的 URI Pattern


### 範例

![](img/u21-i02.png)
  
- `oracle.example.hr` module 的 uri prifix 為 `/hr/`, 此 module 所在的 schema 為 `cyutim`
- employees resource template 的 URI pattern 為 `employees/`
- employees resource template 下有一個處理 `GET` http 方法的 handler

此 resource 的 url 為: `http://<HOST>:1521/ords/cyutim/hr/employees`

handler 內的程式碼:
```sql{class=line-numbers}
select empno "$uri", rn, empno, ename, job, hiredate, mgr, sal, comm, deptno
  from (
       select emp.*
            , row_number() over (order by empno) rn
         from emp
       ) tmp;
```

使用 Talent API Tester 測試的結果: 
![](img/u21-i03.png)

Request and Response:
![](img/u21-i04.png)


## 使用 SQLDeveloper 建立 ORDS module 及其 resource

### 使用 Wizard 建立 module and resource template 

- Create the module `demo` with the uri prefix `/demo/`  in the schema cyutim
- Create the resource `customers` with the uri patterm `customers/`

Path to invoke the Wizard: 
- REST Data Service > Module > Right Click Menu > New Module

![](img/u21-i05.png)

![](img/u21-i06.png)
![](img/u21-i07.png)
![](img/u21-i08.png)

The result:
![](img/u21-i09.png)




### 建立 resource handler: GET

Path: REST Data Services > Modules > demo > customers > Mouse Right Click Menu > Add Handler > Get

![](img/u21-i10.png)

Set parameters for the handler of GET method

![](img/u21-i11.png)

Source Type:
- Collection Query: Executes a SQL query and transforms the result set into a JSON representation. Available when the HTTP method is GET.

Ref: [Using Oracle Database Actions for Oracle Cloud](https://docs.oracle.com/en/database/oracle/sql-developer-web/sdwad/creating-restful-services.html#GUID-1F2C44F8-CE37-4A7C-82C0-FA012F6CE4DD)


完成後, 撰寫 Handler 內的程式碼:
![](img/u21-i12.png)

點選 (T)Details 查看完整的 URL:
![](img/u21-i13.png)

點選上方圖片中的 Disk 圖示, 儲存程式碼. 

之後, `customer` resource template 下會出現一個 `GET` 方法的 handler:
![](img/u21-i14.png)



測試 URL: http://host/ords/cyutim/demo/customers

![](img/u21-i15.png)

完成的 Response 內容:

```json{class=line-numbers}
{
    "items": [
        {
            "customer_id": 1,
            "cust_first_name": "John",
            "cust_last_name": "Dulles",
            "cust_street_address1": "45020 Aviation Drive",
            "cust_street_address2": null,
            "cust_city": "Sterling",
            "cust_state": "VA",
            "cust_postal_code": "20166",
            "cust_email": "john.dulles@email.com",
            "phone_number1": "703-555-2143",
            "phone_number2": "703-555-8967",
            "url": "http://www.johndulles.com",
            "credit_limit": 1000,
            "tags": null
        },...
    ],
    "hasMore": false,
    "limit": 25,
    "offset": 0,
    "count": 7,
    "links": [
        {
            "rel": "self",
            "href": "http://host/ords/cyutim/demo/customers"
        },
        {
            "rel": "describedby",
            "href": "http://host/ords/cyutim/metadata-catalog/demo/item"
        },
        {
            "rel": "first",
            "href": "http://host/ords/cyutim/demo/customers"
        }
    ]
}
```

### 在 url 中使用 filter clause 限制回傳資料

回傳 `customer_id` 大於或等於 3 之後的顧客資料:

```
http://imsys/ords/cyutim/demo/customers?q={"customer_id":{"$gte":3}}
```
Ref: https://docs.oracle.com/database/ords-17/AELIG/developing-REST-applications.htm#AELIG90103


## 帶參數的 GET 操作

User Case: 查詢顧客編號 1 的資料

建立 Resource template with the URI Pattern: `customer/:id`
- 其中 `:id` 為查詢參數, 在 SQL 中使用相同名稱的 binding variable 取得傳入的參數.

![](img/u21-i16.png)
![](img/u21-i17.png)

此 Template 的 `GET` method handler 的程式碼:

```sql{class=line-numbers}
select * from demo_customers cust
    where cust.customer_id = :id;
```

回傳結果:
```json{class=line-numbers}
{
    "items": [
        {
            "customer_id": 1,
            "cust_first_name": "John",
            "cust_last_name": "Dulles",
            "cust_street_address1": "45020 Aviation Drive",
            "cust_street_address2": null,
            "cust_city": "Sterling",
            "cust_state": "VA",
            "cust_postal_code": "20166",
            "cust_email": "john.dulles@email.com",
            "phone_number1": "703-555-2143",
            "phone_number2": "703-555-8967",
            "url": "http://www.johndulles.com",
            "credit_limit": 1000,
            "tags": null
        }
    ],
    "hasMore": false,
    "limit": 25,
    "offset": 0,
    "count": 1,
    "links": [
        {
            "rel": "self",
            "href": "http://163.17.9.165/ords/cyutim/demo/customer/1"
        },
        {
            "rel": "describedby",
            "href": "http://163.17.9.165/ords/cyutim/metadata-catalog/demo/customer/item"
        },
        {
            "rel": "first",
            "href": "http://163.17.9.165/ords/cyutim/demo/customer/1"
        }
    ]
}
```

### Optional Query parameters 的技巧

Resource Template (test module in cyutim schema):
`cyutim/test/emp/:job/:deptno`

```sql{class=line-numbers}
select * from emp e 
    where e.job = :job 
        and e.deptno = :deptno   -- required parameter
        and e.mgr = NVL (:mgr, e.mgr)  -- optional parameter
        and e.sal = NVL (:sal, e.sal)   -- optional parameter
```

URI pattern: 
- 只有 required parameter
`http://localhost:8080/ords/ordstest/test/emp/SALESMAN/30`
- 加上兩個 optional parameters
`http://localhost:8080/ords/ordstest/test/emp/SALESMAN/30?mgr=7698&sal=1500.`

`:mgr` 及 `:sal` 不需要額外在 Get Handle 中設定 parameters, 可直接使用


另外一個例子:

Resource Template (demo module in cyutim schema)
`cyutim/demo/customers`

GET Handler 

```sql {class=line-numbers}
SELECT * from 
    (select c.* ,
            ROW_NUMBER() OVER (ORDER BY customer_id asc)
    from demo_customers c
    where c.credit_limit = nvl(:credit, c.credit_limit)
    )
```

Without the optional parameter:
`http://imsys/ords/cyutim/demo/customers/`

With the optional parameter:
`http://imsys/ords/cyutim/demo/customers/?credit=1500`

Ref: [3.2.6.1.3 Using Query Strings for Optional Parameters](https://docs.oracle.com/database/ords-17/AELIG/developing-REST-applications.htm#AELIG-GUID-C9D763FD-9B74-4A27-9B80-6E500756E464)

### 使用 FilterObject 篩選查詢資料

如果不想修改 Resource Template, 但仍想使用條件查詢, 此時 FilterObject 是很有彈性的工具。

Resource URL 
`https://example.com/ords/scott/emp/`

使用 query parameter 傳遞 FilterObject
`https://example.com/ords/scott/emp/?q={"ENAME":"JOHN"}`


Example: 加入 CUST_LAST_NAME 及 CUST_EMAIL 兩個欄位的查詢條件的 FilterObject 的 JSON 表示式: 

```
{
    "CUST_LAST_NAME": {
        "$and": [
            {"$like": "%l%"},
            {"CUST_EMAIL": {"$like": "%@%"}}
        ]
    }
}
```

URL: 
```
http://imsys/ords/cyutim/demo/customers/?q={"CUST_LAST_NAME":{"$and":[{"$like":"%l%"},{"CUST_EMAIL": {"$null": null}}]}}
```

FilterObject 

Ref [3.2.5.2 Filtering in Queries](https://docs.oracle.com/database/ords-17/AELIG/developing-REST-applications.htm#GUID-091748F8-3D14-402B-9310-25E6A9116B47)




## 使用 POST 新增資料至表格

### 建立測試表格及資源

建立測試表格
```sql
create table demo_cust (id number, 
        name varchar2(50), 
        updated TIMESTAMP default systimestamp);
```

建立 resource template with URI pattern `cust`。

建立 POST handler:
![](img/u21-i18.png)
![](img/u21-i19.png)


POST handler 的程式碼:

@import "./src_codes/post_handler.sql" {class=line-numbers}

執行結果:
![](img/u21-i20.png)
![](img/u21-i21.png)


使用 `:body` 的注意事項:
- The `:body` bind variable can be accessed, or de-referenced, only once. Subsequent accesses return a NULL value. 
- So, you must first assign the `:body` bind variable to the local L_PO variable before using it in the two JSON_Table operations.

- The `:body` bind variable is a BLOB datatype and you can assign it only to a BLOB variable.

Ref: [3.2.6.2.1.1 Usage of the :body Bind Variable @ Developing Oracle REST Data Services Applications](https://docs.oracle.com/database/ords-17/AELIG/developing-REST-applications.htm#GUID-4A7F4425-61DF-4290-AED0-05DC2EF77158)


Implicit Parameters in ORDS 參考: 
[Implicit Parameters @ Installation, Configuration, and Development Guide](https://docs.oracle.com/en/database/oracle/oracle-rest-data-services/18.3/aelig/implicit-parameters.html#GUID-E7716042-B012-4E44-9F4C-F8D3A1EDE01C)

## 使用 PUT 更新

Handler 的處理程序

Use case: Request 內有更新的一筆記錄, 需要更新到 database

URI pattern: `cust/`
HTTP Method: PUT
Payload: Complete record to be updated in the JSON format

程序:
1. 取得 Request Body
2. 取得 Body 內的 JSON 的內容.
3. 將 JSON 內容轉成 Record
4. 補足其 record 中的欄位
5. Update by using the record
6. 回傳 response

程式碼

@import "./src_codes/put_handler.sql" {class=line-numbers}


## 使用 DELTE 刪除

Use case: Request 內有要刪除的記錄的 primary key.

URI Pattern: `customer/:id`
HTTP Method: DELETE

程序:

1. Delete with the binding variable `:id`
2. 回傳 response

程式碼
@import "./src_codes/delete_handler.sql" {class=line-numbers}


## Upload and Download files

Main Ref: [Building a Web Service for Uploading and Downloading Files: The Video!](https://www.thatjeffsmith.com/archive/2018/11/building-a-web-service-for-uploading-and-downloading-files-the-video/)


### 操作情境

上傳:
- file_name 欄位
- file_type 欄位
- 圖片或檔案

之後, 回覆圖片存取的 URL

### 上傳時的 request 設定
- 欄位要放在 request header 
- 圖片或檔案要放在 request body

![](img/i57.png)

### Resource template 的設定

Steps:

1. 增加並設定 resource template 的 uri pattern
2. 加入 POST handler 到 resource template 中
3. 設定 Request header parameters 與 binding Variables 的對應關係.
4. 撰寫 POST handler 的程式碼

### 增加並設定 resource template 的 uri pattern

![](img/u21-i22.png)

### 加入 POST handler 到 resource template 中

![](img/u21-i18.png)

### 設定 Request header parameters 與 binding Variables 的對應關係.

Request 的 http header 的兩個(自定)參數:
- `file_name`, 對應 bind variable `file_name`
- `file_type`, 對應 bind variable `file_typw`

上述參數的資料型態皆為 string, Access Method 為 IN.

Response 的 http header 的參數:
- `X-ORDS-STATUS-CODE`: 為 ORDS 使用的參數, 用來表示回應狀態, 對應到 bind variable `status`.
- `location`: 對應到 http header 中的 `Location` 參數. 當回應狀態碼(status code) 為 201 時, Location 參數表示新建立資源的 URL [6]. 

![](img/u21-i23.png)

Client 上傳的檔案或圖片儲存在 http body 中.

目前 Reseful service 不支援 multipart/form-data 上傳, 因為資安的問題. 參考 [7]

### Post Handler 程式碼

@import "./src_codes/upload_post_handler.sql"{class=line-numbers}

### 測試

Request:
![](img/u21-i25.png)

Response:
回傳 location 應為: `http://imsys/ords/cyutim/demo/media/21/content`
![](img/u21-i24.png)


## References
1. [Developing Oracle REST Data Services Applications](https://docs.oracle.com/database/ords-17/AELIG/developing-REST-applications.htm#AELIG90011)
2. [Lab 4: Insert, Update, and Delete Data Using RESTful Services @ Oracle.com](https://www.oracle.com/webfolder/technetwork/tutorials/obe/db/ords/r30/Insert_Update_Delete/Insert_Update_Delete.html)
3. [ORDS 101 Video and Slides @ ThatJeffSmith](https://www.thatjeffsmith.com/archive/2020/05/ords-101-video-and-slides/)
4. [Building a Web Service for Uploading and Downloading Files: The Video! @ ThatJeffSmigh](https://www.thatjeffsmith.com/archive/2018/11/building-a-web-service-for-uploading-and-downloading-files-the-video/)
5. [REST Data Services Developers Guide](https://www.oracle.com/application-development/technologies/rest-data-services/listener-dev-guide.html#about_uris)
6. [HTTP headers | Location - GeeksforGeeks](https://www.geeksforgeeks.org/http-headers-location/)
7. [has ORDS supported multipart form data Request](https://community.oracle.com/tech/developers/discussion/4132424/has-ords-supported-multipart-form-data-request)