import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        // 有無#
        let skipStartIndex = hexString.hasPrefix("#") ? 1 : 0
        let start = hexString.index(hexString.startIndex, offsetBy: skipStartIndex)
        var hexColor = hexString[start...]
        
        if hexColor.count == 6 {
            hexColor = "FF" + hexColor
        }
        
        if hexColor.count == 8 {
            let scanner = Scanner(string: String(hexColor))
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        
        return nil
    }
    
    /**
     整數 RGB 0~255
     */
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {

        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}
