//
//  ViewController.swift
//  TACoverFlow
//
//  Created by Matías Spinelli on 07/30/2019.
//  Copyright (c) 2019 Dalmunc. All rights reserved.
//

import UIKit
import TACoverFlow

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            let coverFlowNib = UINib.init(nibName: "CoverflowCell", bundle: Bundle(for: CoverflowCell.self))
            tableView.register(coverFlowNib, forCellReuseIdentifier: "CoverflowCell")
        }
    }
    
    lazy fileprivate var coverflowCell : CoverflowCell = {
        let cell : CoverflowCell = self.tableView.dequeueReusableCell(withIdentifier: "CoverflowCell") as! CoverflowCell
        cell.delegate = self
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let carouselUno = CarouselCard(titleText : "Uno", subtitleText : "Uno", pointsValue : 0, imageName: "ios8")
        let carouselDos = CarouselCard(titleText : "Dos", subtitleText : "Dos", pointsValue : 2, imageName: "ios8")
        let carouselTres = CarouselCard(titleText : "Tres", subtitleText : "Tres", pointsValue : 1, imageName: "ios8")
        let carouselCuatro = CarouselCard(titleText : "Cuatro", subtitleText : "Cuatro", pointsValue : 10, imageName: "ios8")

        var coverflowCards = [carouselUno, carouselDos, carouselTres, carouselCuatro]
        
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
