
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
- Parse the JSON data
- 範例程式
  - Post
  - Get 
  - Put
  - Delete
- 測試工具
- ORDS-Specific Bind Variables


## Restful service 的觀念回顧

[Unit 10: RESTful Service 使用 JAX-RS 2.0 – Basic Concepts @ hychen39.github.io](https://hychen39.github.io/jsf_teaching/2019/03/11/JSF_Unit10.html)

## What is the Oracle ORDS?

- ORDS = Oracle Rest Data Service
- 為 Table 及 View 提供  Restful service

More Info: [Oracle REST Data Services - REST APIs for Oracle Database @ THAT JEFF SMITH](https://www.thatjeffsmith.com/oracle-rest-data-services-ords/)

### Architecture
![](img/u21-i01.png)

Src: https://www.oracle.com/technetwork/developer-tools/apex/learnmore/apex-ebs-extension-white-paper-345780.pdf

