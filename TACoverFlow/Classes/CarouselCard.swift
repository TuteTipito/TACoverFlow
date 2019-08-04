import UIKit

public class CarouselCard : NSObject {
    var titleText : String
    var subtitleText : String
    var pointsText : String
    var pointsValue : Int!
    var image : UIImage!
    var type : String
    
    public init(titleText : String, subtitleText : String, pointsValue : Int, imageName : String? = nil) {
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.pointsText = (pointsValue==0) ? "" : "+\(pointsValue)"
        self.pointsValue = pointsValue
        self.type = ""
        
        if let validImageName = imageName {
            image = UIImage(named: validImageName)
        }
        
        super.init()
    }
    
    public init(titleText : String, subtitleText : String, pointsText : String, imageName : String? = nil) {
        self.titleText = titleText
        self.subtitleText = subtitleText
        self.pointsText = pointsText
        self.type = ""

        if let validImageName = imageName {
            image = UIImage(named: validImageName)
        }
        
        super.init()
        
        self.pointsValue = calculatePointsForText()
    }
    
//    init(dictionary: [String : Any]) {
//        self.titleText = dictionary.stringForKey("name")
//        self.subtitleText = dictionary.stringForKey("description")
//        self.pointsValue = dictionary.intForKey("points")
//        self.pointsText = (pointsValue == 0) ? "" : "+\(pointsValue!)"
//        self.type = dictionary.stringForKey("type")
//        super.init()
//    }
    
    // MARK: - Private
    
    fileprivate func calculatePointsForText() -> Int {
        guard
            pointsText != "",
            let points : Int = Int(pointsText.substring(from: pointsText.index(pointsText.endIndex, offsetBy: -3)))
        
        else {
            return 0
        }
        return points
    }
}
