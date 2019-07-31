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

class CoverflowCell : UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource  {

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
    
    private var carouselArray : [CarouselCard] = []
    var delegate : CarouselDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK :  Cell methods.
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.contentOffset.x = -(UIScreen.main.bounds.width - ((UIScreen.main.bounds.height * kCardSize.width) / baseScreenHeight)) / 2
        calculateVisibleCellsSize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK : Private methods.
    
    private func setup() {
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
        collectionView.register(UINib(nibName: "CoverflowItemCell", bundle: nil), forCellWithReuseIdentifier: "CoverflowItemCell")
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: (UIScreen.main.bounds.width - itemSize.width) / 2,
            bottom: 0,
            right: (UIScreen.main.bounds.width - itemSize.width) / 2 + 1
        )
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        backgroundColor = UIColor.gray
        collectionViewHeightConstraint.constant = (UIScreen.main.bounds.height * 170) / baseScreenHeight
        
//        topLabel.font = UIFont.smallBold()
        topLabel.textColor = UIColor.gray
        topLabel.textAlignment = .center
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = carouselArray.count
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.backgroundColor = UIColor.clear
        pageControl.isUserInteractionEnabled = false
    }
    
    private func calculateVisibleCellsSize() {
        for cell in collectionView.visibleCells as [UICollectionViewCell]  {
            var vectorX : CGFloat = leftScrollOffsetToMiddleScreen - (cell.frame.origin.x + (cell.frame.width / 2))
            vectorX = vectorX < 0 ? -vectorX : vectorX
            
            cell.transform = CGAffineTransform(
                scaleX: -(1/scaleFactor) * (pow((vectorX / UIScreen.main.bounds.width),2)) + 1,
                y: -(1/scaleFactor) * (pow((vectorX / UIScreen.main.bounds.width),2)) + 1
            )
        }
    }
    
    // MARK : Collection view delegate and data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CoverflowItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoverflowItemCell", for: indexPath as IndexPath) as! CoverflowItemCell
        cell.setCellWithCarouselCard(carouselCard: carouselArray[indexPath.row],itemSize:itemSize)
        calculateVisibleCellsSize()
        return cell
    }
    
    private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectCarouselCell(indexPath.row)
        collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        leftScrollOffsetToMiddleScreen = (scrollView.contentOffset.x + UIScreen.main.bounds.width / 2)
        
        let numberOfLeftItems = Int(round((collectionView.contentOffset.x + ((UIScreen.main.bounds.width - itemSize.width) / 2)) / itemSize.width))
        pageControl.currentPage = numberOfLeftItems
        
        defer { calculateVisibleCellsSize() }
        
        guard isInfinite else { return }
        
        if scrollView.contentOffset.x >= CGFloat(itemSize.width * CGFloat(carouselArray.count - 2)) {
            let offset = (scrollView.contentSize.width - (itemSize.width - CGFloat(itemSize.width / 3)) ) - (scrollView.contentOffset.x + UIScreen.main.bounds.width)
            scrollView.contentOffset.x = itemSize.width + offset
        } else if scrollView.contentOffset.x <= itemSize.width {
            scrollView.contentOffset.x = CGFloat(itemSize.width * CGFloat(carouselArray.count - 2)) - (itemSize.width * 2)
        }
    }
    
    func set( CarouselItems array: inout [CarouselCard], andTitle title:String) {
        carouselArray = array
        let attributedString = NSMutableAttributedString(string: title.uppercased())
        attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(1.8), range: NSRange(location: 0, length: title.count))
        topLabel.attributedText = attributedString
        pageControl.numberOfPages = carouselArray.count
    }
}
