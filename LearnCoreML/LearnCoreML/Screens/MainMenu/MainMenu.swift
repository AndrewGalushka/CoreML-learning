//
//  ViewController.swift
//  LearnCoreML
//
//  Created by Andrii Halushka on 17.04.2021.
//

import UIKit

protocol MainMenuViewRouter: AnyObject {
    func showCarClassifier()
}

class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var router: MainMenuViewRouter?
    private let tableView = UITableView()
    private var sections = MainMenuViewController.makeDefaultSectionsSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        tableView.register(MainMenuRow.self, forCellReuseIdentifier: "\(MainMenuRow.self)")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.embed(to: self.view)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sectionNumber: Int) -> Int {
        sections[sectionNumber].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        switch row {
        case .carClassifier:
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(MainMenuRow.self)") as! MainMenuRow
            cell.configure(title: "Car Classifier")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        switch sections[indexPath.section].rows[indexPath.row] {
        case .carClassifier:
            router?.showCarClassifier()
        }
    }
}

private extension MainMenuViewController {
    enum Section {
        case regular([Row])
        
        enum Row: CaseIterable {
            case carClassifier
            
            var id: String {
                "\(self)"
            }
        }
        
        var rows: [Row] {
            switch self {
            case .regular(let rows):
                return rows
            }
        }
    }
    
    static func makeDefaultSectionsSet() -> [Section] {
        [Section.regular([.carClassifier])]
    }
}
