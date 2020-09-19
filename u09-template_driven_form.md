
# Unit 09 範本驅動式表單(template driven form)

## 匯入 `FormsModule` 到專案中

## 表單的結構

Angular 的表單由以下的[表單基礎類別](https://angular.tw/guide/forms-overview#common-form-foundation-classes)所組成:

- FormControl 實例用於追蹤單個表單控制元件的值和驗證狀態。(FormControl tracks the value and validation status of an individual form control.)
- FormGroup 用於追蹤一組表單控制元件的值和狀態。(FormGroup tracks the same values and status for a collection of form controls.) 當表單控制項(form control) 間有相關性必須一起控制時, 使用 FormGroup 將這些控制項分在同一群。或者也可以用於建立動態表單時
- FormArray 用於追蹤表單控制元件陣列的值和狀態。(FormArray tracks the same values and status for an array of form controls.)。FormArray 也可用來[建立動態表單](https://angular.tw/guide/reactive-forms#creating-dynamic-forms)。
- ControlValueAccessor 用於在 Angular 的 FormControl 實例和原生 DOM 元素之間建立一個橋樑。(ControlValueAccessor creates a bridge between Angular FormControl instances and native DOM elements.)

## 模板驅動式表單

模板驅動式表單中, 使用 `ngModel` 指令將 DOM 元素的 `value` 特性與元件特性繫結在一起。Angular 會自動同步 DOM 元素的 `value` 特性與其繫結的元件特性值。`ngModel` 指令(directive)是屬於「屬性型指令」。`ngModel` 指令會為對應的 DOM 元素自動建立一個 FormControl, 但我們無法直接以程式的方式存取表單上的 FormControl.

使用時, 要先對控制元件命名。 亦即, 設定控制元件的 `name` 屬性。如此,  `ngModel` 產生的 FormControl 實體才能註冊到 `ngForm` 實體。 參考 [Naming control elements](https://angular.tw/guide/forms#naming-control-elements)。若沒有設定, 將無法自動同步。

```typescript
import { Component } from '@angular/core';

@Component({
  selector: 'app-template-favorite-color',
  template: `
    Favorite Color: <input type="text" name="favoriteColor" [(ngModel)]="favoriteColor">
  `
})
export class FavoriteColorComponent {
  favoriteColor = '';
}
```

上前述例子為例, 若使用者在表單上的 `Favorite Color` 欄位輸入 `Blue`, 由 View 到 Model 的資料流向如下:

![](https://angular.tw/generated/images/guide/forms-overview/key-diff-td-forms.png)
Src: [建立範本驅動表單](https://angular.tw/guide/forms-overview#setup-in-template-driven-forms)

過程中, `ngModel` 指令會將使用者輸入的值指派到 DOM 元素對應的 FormControl 實體。之後，FormControl 實體內的值再被指派到元件的特性。


Data flow: Model to View

![](https://angular.tw/generated/images/guide/forms-overview/dataflow-td-forms-vtm.png)

若程式修改元件的 `favoriteColor` 特性值為 `red`, 則資料的流向如下:

Data flow: View to Model
![](https://angular.tw/generated/images/guide/forms-overview/dataflow-td-forms-mtv.png)

## 提交表單資料

Angular 為 `<form>` 元素附自動加上一個 [`NgForm` 指令](https://angular.io/api/forms/NgForm)，此指令會建立一個 `FormGroup` 實體來描述表單內控制項的結構, 並追縱表單的狀態, 以利進行表單驗證。

`NgForm`指令會抛出 `ngSubmit` 事件, 當按下 Submit 按鈕時。監聽此一事件, 進行表單處理。

例如, 有以下新增股票表單，按下 `Create` 按鈕後希望能夠新增一支股票到儲存庫中。

```
<form (ngSubmit)="createStock()">
    <div>
        <input type="text" placeholder="Stock Name" 
            name="stockName" [(ngModel)]="this.stock.name" />
    </div>
    <div>
        <input type="text" placeholder="Stock Code" 
        name="stockCode" [(ngModel)]="this.stock.code" />
    </div>
    <div>
        <input type="number" placeholder="Stock Price" 
        name="stockPrice" [(ngModel)]="this.stock.price" />
    </div>
    <div>
        <input type="number" placeholder="Previous Price" 
        name="previousPrice" [(ngModel)]="this.stock.previousPrice" />
    </div>
    <div>
        <button type="submit">Create</button>
    </div>
</form>
```

```
import { Stock } from 'src/app/model/stock';
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-stock-create',
  templateUrl: './stock-create.component.html',
  styleUrls: ['./stock-create.component.css']
})
export class StockCreateComponent implements OnInit {

  public stock: Stock;

  constructor() { }

  ngOnInit() {
    this.stock = new Stock('', '', 0, 0);
  }

  /**
   * Create a new stock using this.stock
   */
  createStock(){
    console.log('Put the stock: ', this.stock , 'into the StockService' );
  }
}
```

## 實作

### 需求 

![](img/u09-i01.png)

![](img/u09-i02.png)

![](img/u09-i03.png)

### 在專案中加入 FormsModule

```typescript
...

import {FormsModule} from '@angular/forms';


@NgModule({
  declarations: [
        ...
  ],
  imports: [
    ...
    FormsModule
  ],
  providers: [
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

### 為 StockService 服務新增建立股票的方法

`src\app\services\stock.service.ts`

```
...

@Injectable({
  providedIn: 'root'
})
export class StockService {
  private stocks: Stock[];

...
  
  public create(stock: Stock): void {
    this.stocks.push(stock);
  }
}
```

### 在 StockCreate 元件新增欄位儲存表單值及提交時的處理方法


`src\app\stock\stock-create\stock-create.component.ts`

```typescript
import { Stock } from 'src/app/model/stock';
import { Component, OnInit } from '@angular/core';
import { StockService } from 'src/app/services/stock.service';

@Component({
  selector: 'app-stock-create',
  templateUrl: './stock-create.component.html',
  styleUrls: ['./stock-create.component.css']
})
export class StockCreateComponent implements OnInit {
  // 儲存表單值的欄位
  public stock: Stock;

  constructor(private stockService: StockService) { }

  ngOnInit() {
    // 初始化欄位
    this.stock = new Stock('Cheshire Cat Company', 'CCC', 200, 220);
  }

  /** 表單 Submit 事件發生時呼叫
   * Create a new stock using this.stock
   */
  createStock(){
    console.log('Put the stock: ', this.stock , 'into the StockService' );
    // 呼叫 StockService 服務的 create() 將 stock 放到儲存庫中
    this.stockService.create(this.stock);
    // 重新初始化儲存表單值的欄位
    this.stock = new Stock('', '', 0, 0);
  }
}
```

### 在 StockCreate 元件的模版中建立表單

```html
<p>stock-create works!</p>

<form (ngSubmit)="createStock()">
    <div>
        <input type="text" placeholder="Stock Name" 
                name="stockName" [(ngModel)]="this.stock.name" />
    </div>
    <div>
        <input type="text" placeholder="Stock Code" 
                name="stockCode" [(ngModel)]="this.stock.code"/>
    </div>
    <div>
        <input type="number" placeholder="Stock Price" 
            name="stockPrice" [(ngModel)]="this.stock.price" />
    </div>
    <div>
        <input type="number" placeholder="Previous Price" 
            name="previousPrice" [(ngModel)]="this.stock.previousPrice" />
    </div>
    <div>
        <button type="submit">Create</button>
    </div>
</form>
```

執行程式