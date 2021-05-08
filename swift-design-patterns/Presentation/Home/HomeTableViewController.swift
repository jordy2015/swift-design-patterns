//
//  HomeTableViewController.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 8/05/21.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var patternList = [(title: "MVP", description: "Model View Presenter"),
                       (title: "MVVM", description: "Model View ViewModel"),
                       (title: "Observer", description: "Observer pattern")]
      
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patternList.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "default")
        let pattern = patternList[indexPath.row]
        cell.textLabel?.text = pattern.title
        cell.detailTextLabel?.text = pattern.description
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("done!")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToMoviesViewControllerMVP", sender: nil)
    }
}
