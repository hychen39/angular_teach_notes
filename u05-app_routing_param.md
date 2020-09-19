---
html:
  embed_local_images: true
  embed_svg: true
  offline: false
  toc: true
export_on_save:
    html: true
---


@import "./css/article_01.css"

# Unit 05 導向時傳遞參數

## 簡介

當從某個元件的 View 導向到另一個元件的 View 時, 會傳遞參數。

例如, 在「股票清單元件」中, 點選任一個股票, 接著導向到「股票詳細元件」查看該股票的細節。

`http://host:8080/#/stock-detail/100`

## Upgrading to Angular 9

Update Globally
```
npm uninstall --global angular-cli
npm cache verify
npm install -g @angular/cli@9
ng v
```

Update the project

- Make sure you are using Node 10.13 or later.
- Run ng update @angular/core@8 @angular/cli@8 in your workspace directory to update to the latest 8.x version of @angular/core and @angular/cli and commit these changes.
- Run ng update @angular/core@9 @angular/cli@9 which should bring you to version 9 of Angular.

Ref: https://update.angular.io/#8.0:9.1



Create a new component
```
ng g c stock/stock-details --module=app
```

## 功能需求

在 stock-list 元件顯示股票名稱連結, 點擊後, 導向至 stock-details 元件顯示方才點擊的股票名稱詳細資料。

## 實作

### 延續 `u04-myapp` 的成果

建立一個新的專案
```
ng new u05-myapp
```

將 `04-myapp` 的 `src/` 複製到 `u05-myapp` 的目錄下。

提交異動

```
cd u05-myapp
git commit -a -m 'u05 baseline'
```

### 建立新元件

建立元件 `stock/stock-details` 用以顯示股票細節。

在專案目錄下, 輸入指令:
```
ng g c stock/stock-details --module=app
```

將產生`stock/stock-details`並加入到 `app` 模組中:

![](img/u05-i01.png)


修改`stock/stock-details`的樣版(template)。
開啟 `src\app\stock\stock-details\stock-details.component.html`, 加入:

```
The product id is {{this.productId}}.
```

新增一元件特性 `productId` 到 `stock-details` 元件中:

```typescript
export class StockDetailsComponent implements OnInit {
  
  public productId: string;

  constructor(){... }

  ngOnInit(): void { ... }
```

### 在元件中注入(Inject) ActivatedRoute 物件

[`ActivatedRoute` 提供導向到目的元件的路徑資訊](https://v9.angular.io/api/router/ActivatedRoute)。

在此 `ActivatedRoute` 物件中, [`snapshot: ActivatedRouteSnapshot`](https://angular.tw/api/router/ActivatedRouteSnapshot#activatedroutesnapshot) 特性及 `paramMap: Observable<ParamMap>` 可以讓我們取得傳遞參數。

Angular 對導向到此元件的路徑組成進行快照, 說明了路徑和元件間的對應關係, 產生了目前可見的畫面。(Ref: [Angular Router: Understanding Router State](https://vsavkin.com/angular-router-understanding-router-state-7b5b95a12eab))。 例如: 路徑 `http://localhost:4200/stock/detail/100` 導向到 `stock-details` 元件, 該元件的路徑節段(segment)為 `stock/detail`(自行設定的路徑節段)對應到 `stock-details` 元件, `/100` 為傳遞給此元件的查詢參數。而路徑 `/` 則對應到 `app` 元件。

此快照是不可改變的資料結構(immutable structure), 導向到此元件後, 就無法修改快照內的資料, 此也稱為靜態的路由器(Static Router State)狀態。只有當路徑中的元件的組成結構改變時, Angular 才會對 Route 的進行另一次的快照。但是, 只改變傳遞參數並不會改變路徑結構。這是路徑快照的重要特性。

要從 `snapshot: ActivatedRouteSnapshot` 中取得參數, 步驟如下:
1. 注入 `ActivatedRoute` 物件到元件中
2. 在元件被載入時，取得`ActivatedRoute` 物件的查詢參數, 接著儲存到元件特性中供後續使用。

`StockDetailsComponent` 元件完整的程式碼:
```typescript
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-stock-details',
  templateUrl: './stock-details.component.html',
  styleUrls: ['./stock-details.component.css']
})
export class StockDetailsComponent implements OnInit {
  
  public productId: string;
  //  注入 `ActivatedRoute` 物件到元件中
  constructor(private activatedRoute: ActivatedRoute) { }

  ngOnInit(): void {
     // Get the query parameter from the activatedRoute
     // 在元件被載入時，取得`ActivatedRoute` 物件的查詢參數
     this.productId = this.activatedRoute.snapshot.paramMap.get('id');
     console.log(this.activatedRoute.snapshot);
  }
}
```
### 增加 Stock-Details 元件的導向路徑到 `app-routes` 模組中

開啟 `src\app\app-routes.module.ts`:

```typescript
const appRoutes: Routes = [
  {path: 'stock/list', component: StockListComponent},
  {path: 'stock/create', component: StockCreateComponent},
  // Stock-Details 元件的導向路徑
  {path: 'stock/detail/:id', component: StockDetailsComponent},
  {path: '', redirectTo: 'stock/stock-list', pathMatch:'full'}]
```

注意, 路徑中的參數名稱前使用冒號`:`, 以利區隔。

完成後的成果:

![](img/u05-i02.gif)






