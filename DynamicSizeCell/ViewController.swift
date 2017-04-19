//
//  ViewController.swift
//  DynamicSizeCell
//
//  Created by Jin Wang on 19/4/17.
//  Copyright © 2017 Jin Wang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private let initTextArray = [
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
        "when an unknown printer took a galley of type and scrambled it to make a type specimen book",
        "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested",
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)
        
        if let c = cell as? SimpleCell {
            c.configureWith(text: initTextArray[indexPath.row])
            c.delegate = self
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return initTextArray.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension ViewController: SimpleCellDelegate {
    func requestSizeRecalculate(cell: SimpleCell) {
        print("Size recalculating....")
        
        method1(cell: cell)
        //method2(cell: cell)
        //method3(cell: cell)
    }
    
    private func method1(cell: SimpleCell) {
        // Will not cause infinite loop but will have duplicates.
        cell.setNeedsUpdateConstraints()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func method2(cell: SimpleCell) {
        // Will cause infinite loop
        tableView.reloadData()
    }
    
    private func method3(cell: SimpleCell) {
        // This method works pretty well.
        if let indexPath = tableView.indexPath(for: cell) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

