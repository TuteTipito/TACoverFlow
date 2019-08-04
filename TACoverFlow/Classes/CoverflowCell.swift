import UIKit

private let kCardSize : CGSize = CGSize(width: 259, height: 162)
private let baseScreenHeight : CGFloat = 736

class CenterAlignedCollectionViewFlowLayout : UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemSize = ((UIScreen.main.bounds.height * kCardSize.width) / baseScreenHeight)
        let numberOfLeftItems = Int(round((proposedContentOffset.x + ((UIScreen.main.bounds.width - itemSize) / 2)) / itemSize))
        var finalPosition = (CGFloat(numberOfLeftItems) * itemSize) - (UIScreen.main.bounds.width - ((UIScreen.main.bounds.height * kCardSize.width) / baseScreenHeight)) / 2
        if  finalPosition < 0 {
            finalPosition += ((UIScreen.main.bounds.width - itemSize) / 2) / itemSize
        }
        return CGPoint(x: finalPosition, y: proposedContentOffset.y)
    }
}

public final class CoverflowCell : UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource  {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var leftScrollOffsetToMiddleScreen : CGFloat = 0
    
    private var itemSize : CGSize = CGSize(
        width: (UIScreen.main.bounds.height * kCardSize.width) / baseScreenHeight,
        height: (UIScreen.main.bounds.height * kCardSize.height) / baseScreenHeight
    )
    
    private var scaleFactor : CGFloat = (UIScreen.main.bounds.width * 2) / 414
    
    private var isInfinite : Bool = false
    private var didSetupCell : Bool = false

    private var carouselArray : [CarouselCard] = []
    public var delegate : CarouselDelegate?

    // MARK :  Cell methods.
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if !didSetupCell {
            collectionView.contentOffset.x = -(UIScreen.main.bounds.width - ((UIScreen.main.bounds.height * kCardSize.width) / baseScreenHeight)) / 2
            didSetupCell = true
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK : Private methods.
    
    private func setup() {
        self.selectionStyle = .none

        let collectionLayout : CenterAlignedCollectionViewFlowLayout = CenterAlignedCollectionViewFlowLayout()
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.itemSize = itemSize
        collectionLayout.scrollDirection = .horizontal
        
        collectionView.setCollectionViewLayout(collectionLayout, animated: false)
        // Setting collection view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.gray
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        let coverflowItemNib = UINib.init(nibName: "CoverflowItemCell", bundle: Bundle(for: CoverflowCell.self))
        collectionView.register(coverflowItemNib, forCellWithReuseIdentifier: "CoverflowItemCell")
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: (UIScreen.main.bounds.width - itemSize.width) / 2,
            bottom: 0,
            right: (UIScreen.main.bounds.width - itemSize.width) / 2 + 1
        )
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        backgroundColor = UIColor.gray
        collectionViewHeightConstraint.constant = (UIScreen.main.bounds.height * 170) / baseScreenHeight
        
//        topLabel.font = UIFont.smallBold()
        topLabel.textColor = UIColor.white
        topLabel.textAlignment = .center
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = carouselArray.count
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.backgroundColor = UIColor.clear
        pageControl.isUserInteractionEnabled = false
    }
    
    private func calculateAllVisibleCellsSize() {
        for cell in collectionView.visibleCells {
            calculateCellsSize(cell as! CoverflowItemCell)
        }
    }
    
    private func calculateCellsSize(_ cell: CoverflowItemCell) {
        let vectorX : CGFloat = abs(leftScrollOffsetToMiddleScreen - (cell.frame.origin.x + (cell.frame.width / 2)))
        
        cell.transform = CGAffineTransform(
            scaleX: -(1/scaleFactor) * (pow((vectorX / UIScreen.main.bounds.width),2)) + 1,
            y: -(1/scaleFactor) * (pow((vectorX / UIScreen.main.bounds.width),2)) + 1
        )
    }
    
    // MARK : Collection view delegate and data source
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CoverflowItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoverflowItemCell", for: indexPath) as! CoverflowItemCell
        cell.setCellWithCarouselCard(carouselCard: carouselArray[indexPath.row],itemSize:itemSize)
        calculateCellsSize(cell)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectCarouselCell(indexPath.row)
        collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        leftScrollOffsetToMiddleScreen = (scrollView.contentOffset.x + UIScreen.main.bounds.width / 2)
        
        let numberOfLeftItems = Int(round((collectionView.contentOffset.x + ((UIScreen.main.bounds.width - itemSize.width) / 2)) / itemSize.width))
        pageControl.currentPage = numberOfLeftItems
        
        defer { calculateAllVisibleCellsSize() }
        
        guard isInfinite else { return }
        
        if scrollView.contentOffset.x >= CGFloat(itemSize.width * CGFloat(carouselArray.count - 2)) {
            let offset = (scrollView.contentSize.width - (itemSize.width - CGFloat(itemSize.width / 3)) ) - (scrollView.contentOffset.x + UIScreen.main.bounds.width)
            scrollView.contentOffset.x = itemSize.width + offset
        } else if scrollView.contentOffset.x <= itemSize.width {
            scrollView.contentOffset.x = CGFloat(itemSize.width * CGFloat(carouselArray.count - 2)) - (itemSize.width * 2)
        }
    }
    
    public func set( CarouselItems array: inout [CarouselCard], andTitle title:String) {
        
        self.setup()
        
        carouselArray = array
        let attributedString = NSMutableAttributedString(string: title.uppercased())
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.8), range: NSRange(location: 0, length: title.count))
        topLabel.attributedText = attributedString
        pageControl.numberOfPages = carouselArray.count
        
        // If the number of cards is 1 or lower the application
        // have to hide the page indicator.
        if carouselArray.count <= 1 {
            pageControl.isHidden = true
        }
        
        collectionView.reloadData()
    }
}
