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
這種類型的UI畫面可以做很多種不同的變化，想自己挑戰的人可以自由發揮。

我這個範例參考的文章在最後有附連結，邏輯上我有修改一些，不過觀念上還是一樣的，如果不想用StoryBoard佈局可以參考他們的方式。

---
## 作法
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/%E5%AE%8C%E6%88%90%E5%9C%961.png )


#### 1. 先做藍色區塊TableView的約束設定

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/TableView%E7%B4%84%E6%9D%9F.png )

* 將下、左、右的約束設為0，**上方約束設定方式會比較不一樣**，不要對齊Safe Area，對齊最底層的**UIView**上方設為0。

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/TableView%20Content%20Insets.png )

* 然後這一步很重要在StroyBoard 選單中找出**Content  Insets參數**預設是*Automatic*，改成*Never*。


#### 2. 再來做紅色區塊的UI佈局

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/HeaderView%E8%88%87TableView%E7%9A%84%E9%9A%8E%E5%B1%A4.png )

* 首先從StoryBoard UI工具中拖曳一個UIView元件，當作HeaderView，**記得不要放在TableView內部，要和TableView在同一個階層，並放在上層蓋過TableView**。

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/HeaderView%E7%B4%84%E6%9D%9F.png )

* 接著設定該UIView的約束，只需要設定上、左、右的約束，左、右約束設為0，然後高度要設定多少看個人需要，此範例設定為110。

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/%E5%8F%B3%E9%8D%B5%E6%8B%96%E6%9B%B3.png )
![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/HeaderView%E5%B0%8DTableView%20Top%E5%B0%8D%E9%BD%8A.png )

* 上邊約束對齊(Top Align)TableView上邊(右鍵從*HeaderView*拖曳到*TableView*上就可以看到設定選單)。




![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/ImageView%E9%9A%8E%E5%B1%A4.png )

#### 3. 將一個UIImageView放到步驟2的UIView當中。

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/ImageView%E7%B4%84%E6%9D%9F.png )

* 並設定四邊的約束都為0。

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/ImageView%20Content%20Model.png )

* 然後在StoryBoard選單找出**Content  Mode參數**改成*Aspect Fill*。

#### 4. 最後設定大頭照的部分，綠色區塊處。

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/%E5%A4%A7%E9%A0%AD%E7%85%A7%E9%9A%8E%E5%B1%A4.png )

* 先拖曳一個UIView到TableView中，讓其成為TableView的HeaderView，接著把一個UIImageView放到該UIView中。

![Alt text](https://github.com/AlexanderChen5966/SwiftStretchHeaderEffect/blob/dev/Screenshots/%E5%A4%A7%E9%A0%AD%E7%85%A7%E7%B4%84%E6%9D%9F.png )

* 最後固定寬度和高度，此範例設定為69 * 69，最後設定對齊左邊和上邊的約束，左邊為40、上邊為 **-40**，就完成畫面的佈局。


#### 5. 說明程式碼
offsetHeaderStop是設定希望將HeaderView上推倒多少高度停止所使用的變數，範例中會停止在和Navigation Bar 加上StatusBar一樣的高度，當然如果有其他高度想要使用可直接針對這個變數修改。

```
private var offsetHeaderStop:CGFloat = 0 //Header上推到多少高度停止

//在ViewDidLoad中
override func viewDidLoad() {
    super.viewDidLoad()
    
    //navigationBar高度(44)+ statusBar高度(20或44)
    //navigationBar在有無瀏海的機種都一樣是44
    //statusBar在無瀏海的機種是20、有瀏海的機種是44

    let offsetGap = (navigationController?.navigationBar.frame.height)! + (UIApplication.shared.statusBarFrame.height) // navigationBar高度 (44)+ statusBar高度(20或44)
    
    //110 - 64或88
    offsetHeaderStop = headerView.frame.height - offsetGap
    
    ........
    //TableView contentInset的Top需要設定和HeaderView的高度一樣畫面才會正常
    tableView.contentInset.top = headerView.frame.height
    ........
}
```

接著就是*UITableViewDelegate*或是*UIScrollViewDelegate*的scrollViewDidScroll方法，需要自行寫滑動的轉換行為。

```
func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    //多加headerView的height是因為tableView的contentInset top並不是0，所以在Scroll的時候起始位置還是從0開始scrollView contentOffset y與內容物起始點的位置不同，才導致動畫會很不順暢
    //使用TableView會和ScrollView會有些在offset會有不同的位移需要

    let offset = scrollView.contentOffset.y + headerView.bounds.height 
    
    //分別要給HeaderView和大頭照用的transformation
    var headerTransform = CATransform3DIdentity
    var avatarTransform = CATransform3DIdentity

    // PULL DOWN(下拉)
    // 下拉到頂部後繼續下拉，HeaderView的圖片會有放大的效果
    if offset < 0 {
        
        let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
        let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0

        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)

        // Hide views if scrolled super fast
        headerView.layer.zPosition = 0

    } else { // SCROLL UP/DOWN ------------
    
        // Header View -----------
        headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offsetHeaderStop, -offset), 0)


        //大頭照 -----------
        //大頭照在滑動到HeaderView固定時的交界處，大頭照會縮小而且會交換圖層順序
        let avatarScaleFactor = (min(offsetHeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
        let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
        avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
        avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)

        // headerView 和 avatarImage 的 z-position 位置調動
        if offset <= offsetHeaderStop {
            if avatarImage.layer.zPosition < headerView.layer.zPosition{
                headerView.layer.zPosition = 0
            }

        }else if avatarImage.layer.zPosition >= headerView.layer.zPosition {
            headerView.layer.zPosition = 2
        }

    }
    
    // Apply Transformations
    headerView.layer.transform = headerTransform
    avatarImage.layer.transform = avatarTransform

}

```

#### 6. NavigationBar
上面都做完之後應該會發現，在有NavigationController的時候，NavigationBar會蓋住範例中的畫面，那麼就需要去隱藏或是修改顏色之類的屬性，將NavigationBar原本的背景色、下邊線等等屬性隱藏


關於官方提供的方法來NavigationBar的屬性，在換頁的時候會有一些問題存在。

最好是使用*Method Swizzling*來修改轉場效果與屬性會更適合。

**這裡要注意，如果NavigationBar是使用Large Title模式的話，這個修改屬性的方法並不適用。**

附上我參考的文章，或是可以看我整理在Extension檔案夾當中的UINavigationControllerExtension檔案

[https://tomatosx.github.io/2018/07/06/2018-07-06-NavigationBar%20%E4%B8%8D%E5%90%8C%E9%A2%9C%E8%89%B2%E6%97%B6%E7%9A%84%E8%BD%AC%E5%9C%BA/
](https://tomatosx.github.io/2018/07/06/2018-07-06-NavigationBar%20%E4%B8%8D%E5%90%8C%E9%A2%9C%E8%89%B2%E6%97%B6%E7%9A%84%E8%BD%AC%E5%9C%BA/)

---

## 參考
1. [https://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/
](https://www.thinkandbuild.it/implementing-the-twitter-ios-app-ui/)
2. [http://nathanwhy.com/2015/03/02/2015-03-02-implementing-the-twitter-ios-app-ui/
](http://nathanwhy.com/2015/03/02/2015-03-02-implementing-the-twitter-ios-app-ui/)


如果要找一些第三方套件和英文的文章可以搜尋下列的關鍵字

關鍵字:Stretchy Header Effect、Twitter Effect、Parallax Effect、Sticky View、下拉圖片放大
