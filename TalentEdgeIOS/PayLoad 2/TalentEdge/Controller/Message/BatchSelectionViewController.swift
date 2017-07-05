//
//  BatchSelectionViewController.swift
//  TalentEdge
//
//

import UIKit

class BatchSelectionViewController: UIViewController {
    
    @IBOutlet weak var recipientTableView: UITableView!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    var selectedBatch : TEBatchData!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonOutlet.setFAIcon(FAType.faArrowLeft, forState: UIControlState())
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Delegates
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelManager.singleton.batchList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BatchSelectTableCell", for: indexPath) as! BatchSelectTableCell
        cell.nameLabel.text = ModelManager.singleton.batchList[indexPath.row].name
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        //        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InboxDetailViewController") as! InboxDetailViewController
        //        self.navigationController?.pushViewController(detailVC, animated: true)
        selectedBatch.id = ModelManager.singleton.batchList[indexPath.row].id
        selectedBatch.name = ModelManager.singleton.batchList[indexPath.row].name
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}


class BatchSelectTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
}
