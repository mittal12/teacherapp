//
//  MultiSelectionTableView.swift
//
//

import UIKit

@objc
protocol MultiSelectionTableViewDelegate {
    func selectedValues(_ selectedValues: [MultiSelectionObject], delegate : MultiSelectionTableView)
}
class MultiSelectionTableView: UIViewController {
    
    @IBOutlet weak var cancelButtonOutLet: UIButton!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    var reuseIdentifier: String = "SelectContactTableViewCell"
    var selectionDelegate : MultiSelectionTableViewDelegate!
    var tempInt : Int?
    //    var delegate: CommonTableView?
    @IBOutlet weak var tableView: UITableView!
    var ObjArray: [MultiSelectionObject]!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let nib = nibNameOrNil ?? "MultiSelectionTableView"
        super.init(nibName: nib, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        cancelButtonOutLet.setTitle(LocalizedString("Cancel"), forState: .Normal)
//        doneButtonOutlet.setTitle(LocalizedString("Done"), forState: .Normal)
        // tableView.layer.borderColor = UIColor.grayColor().CGColor
        tableView.layer.borderWidth = 1;
        tableView.layer.borderColor = UIColor.lightGray.cgColor;
        
        tableView.register(UINib(nibName: "SelectContactTableViewCell", bundle:nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ObjArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SelectContactTableViewCell
        let obj = ObjArray[indexPath.row]
        cell.txtLabel?.text = obj.text_Description
//        cell.imgView.image = obj.isSelected == true ? kCheckImage : kUncheckImage
        if tempInt == indexPath.row {
            cell.isUserInteractionEnabled = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let obj = ObjArray[indexPath.row]
        obj.isSelected = !obj.isSelected
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func saveButtonAction(_ sender: AnyObject) {
        selectionDelegate.selectedValues(ObjArray, delegate: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }

    
}

//self.view.endEditing(true)
//
//var objArray = [MultiSelectionObject]()
//var selectedSite  = Int()
//autoreleasepool({ () -> () in
//    for(var i = 0; i < allSiteMainArray.count ; i++ ){
//        let empTypeEvalObj : MBDOSitesForCustApp = allSiteMainArray.objectAtIndex(i) as! MBDOSitesForCustApp
//        let multiSelectObj = MultiSelectionObject()
//        multiSelectObj.text_Description = empTypeEvalObj.title
//        multiSelectObj.primaryKey = empTypeEvalObj.primaryKey
//        multiSelectObj.isSelected = empTypeEvalObj.isSelected
//        if ModelManager.singleton.selectedObjectHash.valueForKey("ssPK")!.intValue == empTypeEvalObj.primaryKey.intValue {
//            selectedSite = i
//        }
//        objArray.append(multiSelectObj)
//    }
//})
//let commonTableView  = MultiSelectionTableView()
//commonTableView.view.tag = 9999
//commonTableView.tempInt = selectedSite
//commonTableView.selectionDelegate = self
//commonTableView.view.frame = self.view.bounds;
//commonTableView.ObjArray = objArray
//self.addChildViewController(commonTableView)
//self.view.addSubview(commonTableView.view)
//}
////MARK: - MultipleSelectionTableView Delegate
//
//func selectedValues(selectedValues: [MultiSelectionObject], delegate: MultiSelectionTableView) {
//    let multiSelectionTV : MultiSelectionTableView! = delegate
//    if multiSelectionTV.view.tag == 9998 {
//        autoreleasepool({ () -> () in
//            for(var i = 0; i < allJobPositionArray.count ; i++ ){
//                let empTypeEvalObj : EOLkJobPosition = allJobPositionArray.objectAtIndex(i) as! EOLkJobPosition
//                for(var j = 0; j < selectedValues.count ; j++ ){
//                    if empTypeEvalObj.primaryKey.integerValue == selectedValues[i].primaryKey.integerValue{
//                        empTypeEvalObj.isSelected = selectedValues[i].isSelected
//                    }
//                }
//            }
//        })
//    } else if multiSelectionTV.view.tag == 9999 {
//        autoreleasepool({ () -> () in
//            for(var i = 0; i < allSiteMainArray.count ; i++ ){
//                let empTypeEvalObj : MBDOSitesForCustApp = allSiteMainArray.objectAtIndex(i) as! MBDOSitesForCustApp
//                for(var j = 0; j < selectedValues.count ; j++ ){
//                    if empTypeEvalObj.primaryKey.integerValue == selectedValues[i].primaryKey.integerValue{
//                        empTypeEvalObj.isSelected = selectedValues[i].isSelected
//                    }
//                }
//            }
//        })
//    }
//}

