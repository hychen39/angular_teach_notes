# Unit 11 Reactive Programming: RxJS library 簡介

## 什麼是 Reactive Programming

Reactive Programming (回應式程式設計) , 是以非同步資料串流(asynchronous data stream)為形式的程式設計思維. 觀察者(Observer)透過訂閱可觀察的(Observable)物件, 成為該物件的訂閱者(Subscriber). 可觀察的物件產生的資料會主動推向訂閱者, 訂閱者便可以即時的反應資料的變化. Ref:Ref: [Reactive programming - Wikipedia](https://en.wikipedia.org/wiki/Reactive_programming)

![](https://res.cloudinary.com/practicaldev/image/fetch/s--HJ0-5sVo--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/7hevybycq37g57jgugx6.jpg)

Figure Source: [Reactive Programming in JavaScript with RxJS.](https://dev.to/sagar/reactive-programming-in-javascript-with-rxjs-4jom)



考慮底下的例子:
```
let a1 = 2;
let a2 = 4;
let b = a1 + a2; // b = 6
let a1 = 3  // b = ?
```

b 的值, 在命令式編程(imperative programming)的思維下, 為 6. 命令式編程指示函數何時啟用, 在 `b = a1 + a2` 時, 將運算的結果指派給 b.

當 a1 的值改變為 3 時, b 的值會是多少呢? 在命令式編程下, b 的值並不會改變, 因為 a1 的值改變後, 我們並沒有再次呼叫 `b = a1 + a2` 重新計算 b 的值.

回應式程式設計思維用不同的角度看 `b = a1 + a2`. `a1 + a2` 可視為一個可觀察的物件, 當有異動時, 運算的結果會自動送出(emit). `b` 是一個觀察者, 對 `a1 + a2` 運算結果有興趣. `=` 是訂閱動作, 將觀察者和可觀察物件繫結在一起, 讓觀查者變成訂閱者. 所以, 當 `a1` 的值變成為 3 時, `b` 的值自動變成 `7`, 我們不用再次呼叫 `b = a1 + a2` 進行計算.

Reactive Programming 可以讓應用程式具備非同步處理的能力, 或者事件導向式處理能力, 事件串流被主動推送到訂閱者處理事件.

應用舉例: 
- GUI 的 MVC 模型, 當 Model 的資料有異動時, View 會自動的更新. 
- 另一個最常見的例子是對後端提出 http request。Http Response 的等待時間受到眾多因素影響。
在 Reactive Programming 的思維下, 提出 Http Request 之後, 我們可以訂閱 Response 的結果。
Response 回來後, Response 的內容會直接推送給訂閱者。 在等待資料推送的過程中, 程式執行緒並不會被卡住, 可以執行其它程式。
換句話說, 程式不會因網路速度慢而造成 UI 的凍結。


## RxJS 術語(terminology)與舉例

Observable: 隨時間推送資料的資料串流
Observer: 資料串流的消費者(consumer), 對取得的資料做處理, 例如印出資料
Subscription: 表示 Observable 與 Observer 間的訂閱關係。
Operator: 串流資料轉換的函數

底下例子, 每隔 1 秒鐘印出計數的數字 0, 1, 2, 3..., 到第 5 秒的時候停止。

Reactive Programming 的思維下,

- Observable: 有個物件能夠每隔一秒產生一個數字
- Observer: 對 Observable 進行訂閱, 印出得到的數字
- Subscription: 描述 Observable 及 Observable 間的關係, 提供 unsubscribe() 取消訂閱, 結束關係。

Demo [u11-ex1 | StackBlitz](https://stackblitz.com/edit/u11-ex1?file=index.ts)

```typescript
import { interval, Observer, Subscription } from "rxjs";

// Observable 可觀察串流
const source$ = interval(1000);

// Observer 觀察者. 
// <T> 指定可處理的資料型態
let myObserver: Observer<number> = {
  // 取得下個數字後的處理方法
  next: value => console.log(value),
  // 發生錯誤時的處理方法
  error: err => console.log(err),
  // 串流推送完畢的處理方法
  complete: ()=> console.log('')
};

// 建立訂閱關係
const subscription: Subscription = source$.subscribe(myObserver);

// 5 秒後, 結束訂閱關係
setTimeout(() => {
  console.log("Unsubscribe");
  subscription.unsubscribe();
}, 5000);
```

Observable 物件提供 `subscribe()` 以訂閱該可觀察物件, 該方法的簽名如下:

```
subscribe(observer?: PartialObserver<T>): Subscription
```
Src: [Observable.subscribe() | RxJS](https://rxjs-dev.firebaseapp.com/api/index/class/Observable#subscribe-)

此方法的另一個多載可以直接傳入 `next`, `error`, `complete`三方法的個函數:

```
subscribe(next: null, error: null, complete: () => void): Subscription
```
Src: [Observable.subscribe() | RxJS](https://rxjs-dev.firebaseapp.com/api/index/class/Observable#subscribe-)
 

## RxJS Play Ground

[StackBlitz](https://stackblitz.com/) 提供線上撰寫 RxJS 的編輯器

![](img/u11-i01.png)
![](img/u11-i02.png)

## 訂閱 Observable: Observer 的建立


Observer (觀察者) 只是具有三個回呼方法(callbacks)的物件，每一個回呼方法對應到 Observable 可能傳遞的通知類型: 
- `next`: Observable 將串流中的下一個元素推向 Observer, Observer 提供方法進行處理
- `error`: 將錯誤訊息推向 Observer, Observer 提供方法進行處理
- `complete`: 通知 Observer 串流資料全部輸出完成, Observer 提供方法進行處理。

以下是 `Observer` 的介面定義:

```typescript
interface Observer<T> {
  closed?: boolean
  next: (value: T) => void
  error: (err: any) => void
  complete: () => void
}
```

參考: [Observer Interface | rxjs-dev](https://rxjs-dev.firebaseapp.com/api/index/interface/Observer)

再看另外一個例子。

這個例子將陣列資料轉成非同步的資料 `Observable<string>`。
此外, 在訂閱時, 可以傳入具有名稱的 Observer: `myObserver` 或者不具名的 Observer 物件。

Demo code [u11-ex2 | StackBlitz](https://stackblitz.com/edit/u11-ex2?file=index.ts)
```typescript
import { from, Observer, of, Subscription, Observable } from "rxjs";
import { map } from "rxjs/operators";

const disneyFriends = ['米老鼠', '高飛', '唐老鴨', '布魯托'];

// 建立 Observer
let myObserver: Observer<string> = {
  next: (friend) => console.log(friend),
  error: err => console.log(err),
  complete: () => console.log('所有的朋友都來了!!')
};

// 使用 from 運算子將陣例轉成 Observable 資料
// 向 Observable 進行訂閱, 訂閱時傳入有名稱的 Observer
from(disneyFriends).subscribe(myObserver);

// 使用不具名的 Observer 物件
from(disneyFriends).subscribe( {
  next: friend => console.log(friend, ' bye bye'),
  error: err => console.log(err),
  complete: () => console.log('所有朋友都離開了!!')
});
```


## Observable 的建立

有數種方式可以將一般的資料建立成 Observable Stream Data。

### `of()` RxJS function

使用 `of()` 將一連串的數字轉成串流:

```typescript
import { interval, Observer, of, Subscription } from "rxjs";
import { map } from "rxjs/operators";

// 建立 Observable Stream
const source = of(1, 2, 3, 5, 9, 10, 11);

let myObserver: Observer<number> = {
  next: value => console.log(value),
  error: err => console.log(err),
  complete: ()=> console.log('串流推送完成')
};

const subscription: Subscription = source.subscribe(myObserver);
```

### `from()` RxJS function

使用 [`from(myArray)`](https://rxjs-dev.firebaseapp.com/api/index/function/from) 將陣列或者 collection 變成串流:

```js
import { from, Observer, Subscription } from "rxjs";

const myArray = ['A', 'B', 'C', 'D', 'E'];
// const source = of(1, 2, 3, 5, 9, 10, 11);
 const source = from(myArray);

let myObserver: Observer<number> = {
  next: value => console.log(value),
  error: err => console.log(err),
  complete: ()=> console.log('串流推送完成')
};

const subscription: Subscription = source.subscribe(myObserver);
```

![](https://rxjs-dev.firebaseapp.com/assets/images/marble-diagrams/from.png)

### `interval()` RxJS function

Creates an Observable that emits sequential numbers every specified interval of time, on a specified SchedulerLike.

![](https://rxjs-dev.firebaseapp.com/assets/images/marble-diagrams/interval.png)

底下的例子取出前 5 個數字後即停止:

```typescript
import { from, Observer, of, Subscription, Observable, interval } from "rxjs";

import { take } from "rxjs/operators";

const take5Elements = interval(500).pipe(take(5));

take5Elements.subscribe( x => console.log(x));
```

[take pipe 運算子](https://rxjs-dev.firebaseapp.com/api/operators/take)

輸出結果:

![](img/u11-i04.png)

### new Observable() 方法

使用 `Observable` 的建構子建立 `Observable` 物件。

建立時, 要傳入方法, 該方法的參數為具 `Observer` 介面的物件。
此方法會呼叫傳入的 `Observer` 物件的 `next()`, `error()`, 及 `complete()` 方法。

Demo Code [u11-ex3 | StackBlitz](https://stackblitz.com/edit/u11-ex3?file=index.ts)
```typescript
import { from, Observer, of, Subscription, Observable } from "rxjs";
import { map } from "rxjs/operators";

// const subscription: Subscription = source.subscribe(myObserver);


// 建立
const myObservable = new Observable( function subscribe(subscriber){
  // subscriber is a observer
  const myArray = ['A1', 'B1', 'C1', 'D1', 'E1'];
  myArray.forEach( (element) => {
    // 呼叫 observable.next() 處理陣列中的元素
    subscriber.next(element);
  })
  // 完成後, 呼叫 observable.complete()
  subscriber.complete();
});

// 建立 Observer 物件提供 next, error, complete 等事件發生時的處理
let myObserver: Observer<number> = {
  next: value => console.log(value),
  error: err => console.log(err),
  complete: ()=> console.log('串流推送完成')
};


myObservable.subscribe(myObserver);
```

輸出結果

![](img/u11-i03.png)

## Pipeable Operators (可串接運算子)

Reactive Programming 中的運算子為函數, 將輸入依據規則轉換成輸出。


A Pipeable Operator is a function that takes an Observable as its input and returns another Observable. It is a pure operation: the previous Observable stays unmodified.
可串接運算子是一個函數, 將一個 Observable 作為其輸入並輸出另一個Observable。 這是一個單純操作：來源的 Observable 保持不變。

![](https://www.techgeeknext.com/img/rxjs/rxjs-operators.png)

Ref: [RxJS Operators Explained with Example (2020) | TechGeekNext >>](https://www.techgeeknext.com/angular/angular-rxjs-operators)

上述圖形的程式碼:
```typescript
import { Observer, of } from 'rxjs'; 
import { filter, map } from 'rxjs/operators';


const source$ = of(1,2,3).pipe(
  map(x => x*2),
  filter(x => x < 5)
);

const myObserver: Observer<number> = {
  next: value => console.log(value),
  error: err => console.log(err),
  complete: () => console.log('Complete!!')
}

source$.subscribe(myObserver);
```

![](img/u11-i05.png)

### Pipeable Operator 的類型

[RxMarbles: Interactive diagrams of Rx Observables](https://rxmarbles.com/#map) 提供各類 operators 的 marble diagram (彈珠圖)。

完整的類型請參考: [Operators | RxJS](https://rxjs-dev.firebaseapp.com/guide/operators)

![](img/u11-i06.png)

Marble Diagram 的閱讀方式:
- Input Observable: 輸入的 Observable (內容不受 Operator 的影響)
- Operator: 對 Observable 元素作用的運算子
- Output Observable: 運算後輸出的 Observable

#### FILTERING OPERATORS (過濾運算子)

##### Filter Operator
[filter](https://rxjs-dev.firebaseapp.com/api/operators/filter)
![](img/u11-i07.png)

```
filter<T>(predicate: (value: T, index: number) => boolean, thisArg?: any): MonoTypeOperatorFunction<T>
```

Example for the Filter operator:
```typescript
import { interval, Observable,  Observer, of, timer } from 'rxjs'; 
import { filter, map, take } from 'rxjs/operators';


const source$ = new Observable( function subscribe(subscriber){
  setInterval( ()=>{
    const rn: number = Math.round(Math.random() * 100);
    subscriber.next(rn);
  } , 1000)
});

const myObserver: Observer<number> = {
  next: value => console.log(value),
  error: err => console.log(err),
  complete: () => console.log('Complete!!')
}

const sourceFiltered$ = source$.pipe(take(5));

 sourceFiltered$.subscribe(myObserver);

```

![](img/u11-i11.png)

##### Take Operator

![](img/u11-i08.png)

Example of the Take Operator
```typescript
import { of, interval, Observer } from 'rxjs'; 
import { map, take, filter, reduce } from 'rxjs/operators';


const source$ = of(1,2,3,4).pipe(take(2));

const myObserver: Observer<number> = {
  next: value => console.log(value),
  error: err => console.log(err),
  complete: () => console.log('Complete!!')
}

source$.subscribe(myObserver);
```

#### Mathematical and Aggregate Operators (數學與聚合運算字)

reduce
![](img/u11-i09.png)


Example for the Reduced operator
```typescript
import { of, interval, Observer } from 'rxjs'; 
import { map, take, filter, reduce } from 'rxjs/operators';


const source$ = interval(500).pipe(
  filter (x => x > 0), 
  take(5), 
  reduce( (x, cumulation) => x + cumulation)
  );

const myObserver: Observer<number> = {
  next: value => console.log(value),
  error: err => console.log(err),
  complete: () => console.log('Complete!!')
}

source$.subscribe(myObserver);
```

#### TRANSFORMATION OPERATORS (轉換運算子)


map
![](img/u11-i10.png)

Example for the Map operator
```typescript
import { of, interval, Observer } from 'rxjs'; 
import { map, take, filter } from 'rxjs/operators';


const source$ = interval(500).pipe(
  filter (x => x > 0), 
  take(3), 
  map(x => 10 * x ));

const myObserver: Observer<number> = {
  next: value => console.log(value),
  error: err => console.log(err),
  complete: () => console.log('Complete!!')
}

source$.subscribe(myObserver);
```
