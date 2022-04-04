//
//  ViewController.swift
//  SegmentedControl
//
//  Created by Suha Baobaid on 4/4/22.
//

import UIKit

class ViewController: UIViewController {
    
    let items = ["Apple", "Banana", "Carrot"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureSegmentControl()
        
        
    }
    
    func configureSegmentControl() {
        let segmentControl = createView(imageFactory: UnderlinedSegmentedControlImageFactory(), items: items)
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segmentControl)
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            
        ])
        
    }
    
    private func createView(imageFactory: SegmentedControlImageFactory ,items: [String]) -> UIView {
        let builder = SegmentedControlBuilder(imageFactory: imageFactory)
        return builder.makeSegmentedControl(items: items)
    }


}

