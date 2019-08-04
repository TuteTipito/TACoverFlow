//
//  ViewController.swift
//  TACoverFlow
//
//  Created by matias.spinelli@gmail.com on 07/30/2019.
//  Copyright (c) 2019 matias.spinelli@gmail.com. All rights reserved.
//

import UIKit
import TACoverFlow

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(CoverflowCell.self, forCellReuseIdentifier: "CoverflowCell")
        }
    }
    
    lazy fileprivate var coverflowCell : CoverflowCell = {
        let cell : CoverflowCell = self.tableView.dequeueReusableCell(withIdentifier: "CoverflowCell") as! CoverflowCell
        cell.delegate = self
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let carouselUno = CarouselCard(titleText : "String", subtitleText : "String", pointsValue : 0, imageName: nil)
        
        var coverflowCards = [carouselUno]
        
        coverflowCell.set(CarouselItems: &coverflowCards, andTitle: "kCarouselTitleText")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return coverflowCell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: CarouselDelegate {
    
    func didSelectCarouselCell(_ index: Int) {
        
    }
    
}
