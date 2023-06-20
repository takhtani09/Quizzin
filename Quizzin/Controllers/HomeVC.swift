//
//  HomeVC.swift
//  Quizzin
//
//  Created by IPS-108 on 15/06/23.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext!
    var users: [UserData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the managed object context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        navigationController?.isNavigationBarHidden = true
        
        tblView.delegate = self
        tblView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("ReloadTable"), object: nil)
        
        //deleteAllData(entity: "UserData")
        fetchData()
    }
    
    @objc func reload() {
        // Data is saved notification received
        tblView.isHidden = false
        fetchData()
        tblView.reloadData()
    }

    
    func deleteAllData(entity: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch {
            print("Failed to delete data for \(entity): \(error.localizedDescription)")
        }
    }

    
    @IBAction func btnStart(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NameVC") as! NameVC
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<UserData> = UserData.fetchRequest()
        
        do {
            users = try managedObjectContext.fetch(fetchRequest)
            tblView.reloadData()
        }
        catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }
    
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count == 0 {
             tblView.isHidden = true
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserDataTBVC
        
        let user = users[indexPath.row]
        
        cell.txtName.text = user.username
        cell.txtScore.text = "\(user.score)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Score"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.3248569876, green: 0.9803921569, blue: 0.9453674636, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textAlignment = .center
        header.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
    }
}
