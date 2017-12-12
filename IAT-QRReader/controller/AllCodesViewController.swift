//
//  AllCodesViewController.swift
//  IAT-QRReader
//
//  Created by Timon Sachweh on 11.12.17.
//  Copyright © 2017 Timon Sachweh. All rights reserved.
//

import UIKit
import CoreData

class AllCodesViewController: UITableViewController {
    
    var data: [ReadCode]?
    var minDate: Date?
    var maxDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        refreshControl = UIRefreshControl()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl!)
        }
        refreshControl?.addTarget(self, action: #selector(refreshTableViewData), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyFilter(_:)), name: NSNotification.Name(rawValue: "filterValues"), object: nil)

        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        minDate = nil
        maxDate = nil
        
        loadData()
    }
    
    @objc func refreshTableViewData() {
        self.loadData()
        self.refreshControl?.endRefreshing()
    }
    
    @objc func applyFilter(_ notification: NSNotification) {
        if let value = notification.object as? FilterValues {
            minDate = value.minDate
            maxDate = value.maxDate
        }
        loadData()
    }
    
    func loadData() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            if let _ = minDate, let _ = maxDate {
                let request: NSFetchRequest = ReadCode.fetchRequest()
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                        NSPredicate(format: "readingDate >= %@", minDate as! NSDate),
                        NSPredicate(format: "readingDate <= %@", maxDate as! NSDate)
                    ])
                data = try context.fetch(request)
            } else {
                data = try context.fetch(ReadCode.fetchRequest())
            }
        } catch {
            print("data loading did not work")
        }
        
        data = data?.sorted(by: {first, second in
            first.readingDate?.compare(second.readingDate! as Date) == .orderedDescending
        })
        
        if (data?.count)! > 0 {
            maxDate = data![0].readingDate! as! Date
            minDate = data![(data?.count)! - 1].readingDate! as! Date
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (data?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = data![indexPath.row].code

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationController = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "detailCodeViewController") as! CodeDetailsViewController
        destinationController.readCode = data![indexPath.row]
        
        self.navigationController?.pushViewController(destinationController, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                try context.delete(data![indexPath.row])
                
                try context.save()
            } catch {
                print("could not be deleted")
            }
        }
        loadData()
    }
    
    @IBAction func deletingAllCodesClicked(_ sender: Any) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try context.execute(NSBatchDeleteRequest(fetchRequest: ReadCode.fetchRequest()))
            try context.save()
        } catch {
            print("could not delete all items")
        }
        loadData()
    }
    
    // MARK: - Navigation
    @IBAction func filterButtonClicked(_ sender: Any) {
        let destination = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "filterViewController") as! FilterViewController
        
        destination.beginDate = minDate
        destination.endDate = maxDate
        
        self.navigationController?.present(destination, animated: true, completion: nil)
    }
    

}
