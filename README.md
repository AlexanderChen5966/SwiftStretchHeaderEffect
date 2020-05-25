# SwiftStretchHeaderEffect

### 效果
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/1.gif )

---
## 說明
試著自己製作類似Twitter會員資料頁面的效果時查了很多資料，
大多的資訊幾乎都是要使用第三方套件，或是使用純程式碼的方式建立UI。
較少看到用StoryBoard和Xib的方式來建立，所以這次挑戰把純程式碼改成用StoryBoard來建立同樣效果的UI。
這個範例只說明原理，並不表示為一個最佳的做法，純粹分享和交流。
當然如果有更好的方法還請不吝指教。


---
## 作法
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/%E5%AE%8C%E6%88%90%E5%9C%961.png )

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/TableView%E7%B4%84%E6%9D%9F.png )
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/TableView%20Content%20Insets.png )

1. 先做藍色區塊TableView的約束設定，將下、左、右的約束設為0，**上方約束設定方式會比較不一樣**，不要對齊Safe Area，對齊最底層的**UIView**上方設為0，然後這一步很重要在StroyBoard 選單中找出**Content  Insets參數**預設是*Automatic*，改成*Never*。

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/HeaderView%E8%88%87TableView%E7%9A%84%E9%9A%8E%E5%B1%A4.png )
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/HeaderView%E7%B4%84%E6%9D%9F.png )
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/%E5%8F%B3%E9%8D%B5%E6%8B%96%E6%9B%B3.png )
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/HeaderView%E5%B0%8DTableView%20Top%E5%B0%8D%E9%BD%8A.png )

2. 再來做紅色區塊的UI佈局，首先從StoryBoard UI工具中拖曳一個UIView元件，當作HeaderView，**記得不要放在TableView內部，要和TableView在同一個階層，並放在上層蓋過TableView**，接著設定該UIView的約束，只需要設定上、左、右的約束，左、右約束設為0，上邊約束對齊(Top Align)TableView上邊(右鍵從*HeaderView*拖曳到*TableView*上就可以看到設定選單)，然後高度要設定多少看個人需要，此範例設定為110，。


![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/ImageView%E9%9A%8E%E5%B1%A4.png )
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/ImageView%E7%B4%84%E6%9D%9F.png )
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/ImageView%20Content%20Model.png )

3. 將一個UIImageView放到步驟2的UIView當中，並設定四邊的約束都為0，並在StoryBoard選單找出**Content  Mode參數**改成*Aspect Fill*。。

4. 最後設定大頭照的部分，綠色區塊處，先拖曳一個UIView到TableView中，讓其成為TableView的HeaderView，接著把一個UIImageView放到該UIView中，最後固定寬度和高度，此範例設定為69 * 69，最後設定對齊左邊和上邊的約束，左邊為40、上邊為 **-40**，就完成畫面的佈局。

---
## 參考
1. [https://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/
](https://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/)
2. [http://nathanwhy.com/2015/03/02/2015-03-02-implementing-the-twitter-ios-app-ui/
](http://nathanwhy.com/2015/03/02/2015-03-02-implementing-the-twitter-ios-app-ui/)
