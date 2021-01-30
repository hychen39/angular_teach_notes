# Unit 15 子路徑 (Child Route)


@import "css/images.css"
@import "css/header_numbering.css"
@import "css/step_numbering.css"


## 子路徑的應用

Angular 允許元件樣版有自己的路徑導向器出口 (router outlet), 換句話說根元件(root component)下的子元件也可以有 router outlet.

應用的例子。在 `ProductDetail` 的區域可以切換顯示 `ProductDescription` 或者 `SellerInfo`.

![](img/u15-i01.png)

Fig Source: [Fain, Y. and Mosieev, A., Angular Development with TypeScript 2nd Edition @ Amazon.com](https://www.amazon.com/Angular-Development-Typescript-Yakov-Fain/dp/1617295345)

顯示於 router outlet 元件路徑會附加在上層的 router outlet 之後。

舉例來說, 顯示產品 123 的 `ProductDetail` 的路徑為 `product/123`. 當在 `ProductDetail` 的 router outlet 顯示路徑為 `seller/456`的 `SellerInfo` 元件時, 該元件的完整路徑為 `product/123/seller/456`。

## 子路徑的使用程序

在父元件樣版中加入 `<router-outlet>` 的標籤. 假若 `FirstComponent` 是我們的父元件, 則該元件的樣版為:

```html
<h2>First Component</h2>

<nav>
  <ul>
    <li><a [routerLink]="['child-a', 0]">Child A</a></li>
    <li><a [routerLink]="['child-b', 1]">Child B</a></li>
  </ul>
</nav>

<!-- 父元件中的 router outlet -->
<router-outlet></router-outlet>
```
Source codes are from: [Nesting Routes @ Angular](https://angular.io/guide/router#nesting-routes)

設定父元件的子路徑。在父元件的 [`Route`](https://angular.io/api/router/Route) 中, 使用 `children?: Routes` 特性子路徑所導向的元件樣版:

```js
const routes: Routes = [
  {
    path: 'first-component',
    component: FirstComponent, // this is the component with the <router-outlet> in the template
    children: [
      {
        path: 'child-a/:id', // child route path
        component: ChildAComponent, // child route component that the router renders
      },
      {
        path: 'child-b/:id',
        component: ChildBComponent, // another child route component that the router renders
      },
    ],
  },
];
```
Source codes are from: [Nesting Routes @ Angular](https://angular.io/guide/router#nesting-routes)

所以, 點選元件視域中的 `Child A` 連結所產生的路徑為 `first-component/child-a/0`, 該路徑會導向 `ChildAComponent` 元件, 用該元件產生一個視域。點選元件視域中的 `Child B` 連結所產生的路徑為 `first-component/child-b/1`, 該路徑會導向 `ChildBComponent` 元件。

## 實作 1 

### 操作案例

![](img/u15-i02.png)

![](img/u15-i03.png)

### 建立提供新聞快訊的服務器

<span class="step"></span> 建立 `NewsSourceService` 服務器。

在 `StockNewModule` 中加入 `NewsSourceService` 服務器:

```
ng g service stock-news/NewSource
```

指令會在 `StockNewModule` 所在的目錄內新增服務器的檔案:

![](img/u15-i04.png)

<span class="step"></span> 建立 `News` 介面。

在此服務器中建立 `News` 介面, 以規範快訊資料的結構:

```js
export interface News {
  title: string,
  body: string
}
```

<span class="step"></span> 建立新聞快訊資料。

加入類別成員欄位 `public newsList: News[];` 到服務器中, 並在建構子內初始化 `newsList` 欄位的資料。 完整的 `NewsSourceService` 服務器程式碼:
```js
import { Injectable } from '@angular/core';

export interface News {
  title: string,
  body: string
}


@Injectable()
export class NewsSourceService {
  // 1. Added member field
  public newsList: News[];

  constructor() {
    // 2. Populate the data in the constructor
    this.newsList = [];
    this.newsList.push({
      title: "Officials face barrage of cyberthreats",
      body: "BACKBONE HACKED: ..."},
      {
        title: "Vietnam’s leaders look to Biden to offset rising China",
        body: "As officials in the Communist..."
      },
      {
        title: "Virus Outbreak: Nearly 3,000 in home isolation",
        body: "‘INCREASED VIGILANCE ..."
      }
    );

   }
}

```



### 顯示新聞快訊標題清單

<span class="step"></span> 注入NewsSourceService` 服務器到 `StockNewsList` 元件。

我們要使用 `StockNewsList` 元件顯示 `NewsSourceService` 服務器所提供的新聞快訊。所以, 要注入 `NewsSourceService` 服務器到 `StockNewsList`元件, 注入點為該元件的建構子參數:


```js
import { NewsSourceService } from './../news-source.service';
import { Component, OnInit } from '@angular/core';


@Component({
  selector: 'app-stock-news-list',
  templateUrl: './stock-news-list.component.html',
  styleUrls: ['./stock-news-list.component.css']
})
export class StockNewsListComponent implements OnInit {

  // 注入 `NewsSourceService` 服務器 
  constructor(public newSource: NewsSourceService) {
   }

  ngOnInit(): void {
  }

}
```

<span class="step"></span> 使用 Flex-Layout 模組切割版面

`StockNewList` 的樣版分成兩個顯示區域, 左邊顯示快訊標題, 右邊顯示快訊內容, 使用 Flex-Box 分割版面, 左邊和右邊縮放比例相同。

我們使用 Flex-Layout 模組提供的 flex-box directive 切割版面。 

使用底下的指令在專案中安裝 Flex-Layout 模組:

```
npm i -s @angular/flex-layout @angular/cdk
```

安裝完成後, 匯入該模組到 `StockNewsModule` 特性模組中:

![](img/u15-i05.png)


<span class="step"></span> 元件樣版設定

完成 Flex-Layout 模組的匯入後, 可設`StockNewList` 的樣版版面:
- 在一般的情況下, 以 row 的方式顯示 flex-box 內的 flex-item, 每個 flex-item 佔螢幕寬度的 50%。
- 當螢幕寬度小於 `sm` 時, 改用 column 的方式顯示, 每個 flex-item 的寬度為 100%.


在左邊顯示的 `div` 區塊, 我們還使用 `*ngFor` directive 動態的產生新聞快訊的標題。每個標題要加上導向路徑 `detail/:id`, 其中 `:id` 為快訊標題的索引值。

在右邊顯示的 `div` 區塊, 加入 `<router-outlet>`, 做為該元件的子路徑導向的出口。

`StockNewList`元件的樣版如下:
```html
<div fxLayout="row"
     fxLayout.lt-sm="column">
     <!-- 左邊顯示的 `div` 區塊  -->
    <div fxFlex="1 1 50%"
         fxFlex.fxLayout.lt-sm="100%"
         class="newsList">
        <ul>
            <li *ngFor="let news of newSource.newsList; index as idx">
                <a [routerLink]="['detail', idx ]">{{news.title}} </a>
            </li>
        </ul>
    </div>

    <!-- 在右邊顯示的 `div` 區塊  -->
    <div fxFlex="1 1 50%" 
         fxFlex.fxLayout.lt-sm="100%"
         class="newsDetails">
        <router-outlet></router-outlet>
    </div>
</div>
```

有關 Flex-Layout API 進一步參考:
- [fxLayout API @ angular/flex-layout](https://github.com/angular/flex-layout/wiki/fxLayout-API)
- [fxFlex API @ angular/flex-layout](https://github.com/angular/flex-layout/wiki/fxFlex-API)

### 設定快訊標題內容的顯示子路徑

完成前述的設定後, 接著設定 `StockNewsModule` 特性模組內的導向路徑。

<span class="step"></span> 設定點選新聞快訊標題後顯示快訊內容的子路徑。

路徑 `news/list` 會在最上層的 `<router-outlet>` 顯示 `StockNewsListComponent` 元件的樣板. 快訊內容是在 `StockNewsListComponent` 內的 `<router-outlet>` 顯示。所以, 在路徑 `news/list` 下使用 `children` 指定該路徑下的子路徑要顯示的元件:

```js
const routes: Routes = [
    {path: 'news/detail/:id', component: StockNewsDetailComponent},
    {path: 'news/list', 
     component: StockNewsListComponent,
     // 子路徑
     children: [{path: "detail/:id", component: StockNewsDetailComponent}]
    }
];
```

因此, `StockNewsDetailComponent` 的完整路徑為 `news/list/detail/:id`, 其中 `:id` 為路徑參數, 以區辨要顯示的是那個快訊標題的內容。

### 顯示快訊的內容



