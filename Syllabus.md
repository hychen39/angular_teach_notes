
# Syllabus

[Unit 01 Angular 開發環境設置](./u01-dev_env_setup.md)

[Unit 02 使用 CLI 建立第一個 Angular 專案](./u02-first_project.md)
    - 專案結構
    - 程式執行過程 - 從載入到顯示
    - 資料連結(Data binding)

[Unit 03 DOM 元素與元件間的連結](./u03-data_binding.md)
    - 元素屬性連結(Attribute binding)
    - 事件連結(Event binding)
  

[Unit 04 應用程式內切換不同元件的樣版 (Application routing)](./u04-app_routing.md)
    - 匯入 `AppRoutes` 模組
    - 設定各元件的導航路徑
    - 設定要切換顯示的地方
    - 使用樣版進行導航
    - 使用程式進行導航


[Unit 05 導向時傳遞參數](./u05-app_routing_param.md)
    - 取得目前的導向路徑值 `ActivatedRoute`
    - 取得傳入之參數(Query Parameters)


[Unit 06 Angular MVC 模式: 建立 model](./u06-domain_model_class.md)
    - 建立股票模型

[Unit 07 Service ](./u07-service.md)
    - 提供股票資料
    - 產生 Injectable Service
    - 注入器與注入器的層級
    - 使用服務提供者(Service Provider)設罝注入器


[Unit 08 在元件內使用其它元件顯示資料: 父、子元件的溝通](./08-components_inputs_outputs.md)
    - UI 開發元件化
    - 由父元件輸入資料到子元件
    - 子元件輸出事件, 由父元件處理



[Unit 09 範本驅動式表單(template driven form)](./u09-template_driven_form.md)


[Unit 10 範本驅動表單驗證](./u10-form_validation.md)

[Unit 11 RxJS (1): Observable, Observer, and Subscriber](./u11_Rxjs.md)

[Unit 12 與 Server 互動: 使用 HTTP ](./u12_http_service.md)
- JSON Parsing and serialization
- HttpClient Service
- Read data from the server
- Post data to the server

[Unit 13 在導向中使用 Observables 及導向到子元件的 `<router-outlet>` (TBD)]
- Observables and the router (Section 6.6)
- Child route (Section 3.6)

[Unit 14 Feature Module 及其導向]
- Section 2.5 Feature Module. [Feature Module | Angular](https://angular.tw/guide/feature-modules)
- Section 4.2 Lazy-Loading modules. [Lazy-loading module | Angular](https://angular.tw/guide/lazy-loading-ngmodules)