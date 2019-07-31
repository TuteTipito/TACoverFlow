import UIKit

class CoverflowItemCell : UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var statusBar : CoverflowItemCellBar = CoverflowItemCellBar()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: Private methods.
    
    func setup() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 3
        contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = true
       
        layer.addSublayer(statusBar)
    }
    
    private func getColorForPointsValue(points : Int) -> UIColor {
        if points >= 0 && points < 350 {
            return UIColor.blue
        } else if points >= 350 && points < 500 {
            return UIColor.blue
        } else if points >= 500 && points < 2000 {
            return UIColor.purple
        } else {
            return UIColor.magenta
        }
    }
    
    // MARK: Public methods.
    func setCellWithCarouselCard(carouselCard : CarouselCard, itemSize:CGSize) {
        titleLabel.text = carouselCard.titleText
        bannerImageView.image = carouselCard.image
        statusBar.set(frame: CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height))
        setBottomLabelText(text: carouselCard.pointsText, withNumberOfPoints:carouselCard.pointsValue)
    }
    
    func setBottomLabelText(text : String, withNumberOfPoints : Int) {
        statusBar.showPoints(state: text == "")
        statusBar.set(color: getColorForPointsValue(points: withNumberOfPoints))
        statusBar.set(text: text)
    }
}
