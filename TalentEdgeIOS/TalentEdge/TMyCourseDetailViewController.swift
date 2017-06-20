//
//  MyCourseViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 31/05/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit

class TMyCourseDetailViewController: UIViewController {

    //
    //  MyCourseDetailViewController.swift
    //  TalentEdge
    //
    //
    
        var moduleArray = ["DASHBOARD","MODULES", "LIVE CLASSES","ATTENDANCE","ASSIGNMENTS","ASSESSMENTS","DISCUSSIONS","BATCHMATES","TESTIMONIALS"]
        var moduleControllerArray = ["TDetailDashBoardViewController","ExpandableModuleViewController","TLiveClassesViewController","TAttendenceViewController","TAssignmentViewController","TAssessmentViewController","DiscussionViewController","BachmatesViewController","TestimonialViewController"]
        
        @IBOutlet weak var mainSubView: UIView!
        var selectedTabIndex : Int!
        @IBOutlet weak var topCollectionView: UICollectionView!
        var isCourseCompleted : Bool!
        @IBOutlet weak var navTitleLabel: UILabel!
    
    //    var selectedCourseObj : TECourseData!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            isCourseCompleted = isCourseCompleted == nil ? true : isCourseCompleted
            //        DataUtils.addBackArrow(self.navigationItem, withTitle: "Module Details", target: self)
            selectedTabIndex = selectedTabIndex  == nil ? 0 : selectedTabIndex
            loadUI()
            // Do any additional setup after loading the view.
        }
        
        fileprivate func loadUI () {
            if self.selectedCourseObj.name == "" {
                DataUtils.sendToLoginScreenWithAlert(self)
                return
            }
            navTitleLabel.text = self.selectedCourseObj.name
            let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: moduleControllerArray[selectedTabIndex]) as UIViewController
            featuredVC.selectedCourseObj = self.selectedCourseObj
            featuredVC.view.frame = mainSubView.bounds
            featuredVC.view.tag = 9998
            self.addChildViewController(featuredVC)
            self.mainSubView.addSubview(featuredVC.view)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            //        topCollectionView.reloadData()
            self.view.layoutIfNeeded()
            let tempPath : IndexPath = IndexPath(item: selectedTabIndex, section: 0)
            
            topCollectionView.scrollToItem(at: tempPath, at: .left, animated: true)
            
        }
        
        @IBAction func backButtonAction(_ sender : AnyObject){
            self.navigationController?.popViewController(animated: true)
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        //MARK:- UICollectionView Delegates
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return isCourseCompleted == true ? 9 : 8
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
            let cell : MyCourseDetailCollecionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCourseDetailCollecionCell",for:indexPath) as! MyCourseDetailCollecionCell
            if indexPath.row == selectedTabIndex {
                cell.bottomView.backgroundColor = kBarButtonBottomSelectedColor
                cell.moduleNameLabel.textColor = kBarButtonBottomSelectedColor
            } else {
                cell.bottomView.backgroundColor = UIColor.clear
                cell.moduleNameLabel.textColor = kBarButtonDefaultTextColor
            }
            cell.moduleNameLabel.text = moduleArray[indexPath.row]
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
            selectedTabIndex = indexPath.row
            collectionView.reloadData()
            collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            self.mainSubView.removeAllSubviews()
            let featuredVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: moduleControllerArray[indexPath.row]) as UIViewController
            featuredVC.selectedCourseObj = self.selectedCourseObj
            //        featuredVC.selectedCourseObjImage = self.selectedCourseObjImage
            featuredVC.view.layer.add(DataUtils.getPushAnimation(), forKey: nil)
            featuredVC.view.frame = mainSubView.bounds
            featuredVC.view.tag = 9998
            self.addChildViewController(featuredVC)
            self.mainSubView.addSubview(featuredVC.view)
        }
        
    }


