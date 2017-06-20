//
//  TDetailDashBoardViewController.swift
//  TalentEdge
//
//  Created by Ashish Mittal  on 01/06/17.
//  Copyright © 2017 Aditya Sharma. All rights reserved.
//

import UIKit
import Charts

class TDetailDashBoardViewController: UIViewController , UIScrollViewDelegate{
    
    
    @IBOutlet weak var attendanceView: UIView!
    
    @IBOutlet weak var attLeftTopLabel: UILabel!
    
    
    @IBOutlet weak var attLeftBottomLabel: UILabel!
    
    
    @IBOutlet weak var attMiddleLabel: UILabel!
    
    
    @IBOutlet weak var attMiddleView: UIView!
    
    
    @IBOutlet weak var attRightTopLabel: UILabel!
    
    
    @IBOutlet weak var attRightBottomLabel: UILabel!
    
    
    @IBOutlet weak var notesView: UIView!
    
    
    @IBOutlet weak var notLeftTopLabel: UILabel!
    
    @IBOutlet weak var notLeftBottomLabel: UILabel!
    
    
    @IBOutlet weak var notMiddleLabel: UILabel!
    
    
    
    @IBOutlet weak var notMiddleView: UIView!
    
    
    @IBOutlet weak var notRightTopLabel: UILabel!
    
    
    @IBOutlet weak var notRightBottomLabel: UILabel!
    
    
    @IBOutlet weak var vidRightBottomLabel: UILabel!
    
    
    @IBOutlet weak var asiRightBottomLabel: UILabel!
    
    
    
    
    @IBOutlet weak var assRightBottomLabel: UILabel!
    
    
    
    @IBOutlet weak var queRightBottomLabel: UILabel!
    
    
    
    @IBOutlet weak var queRightTopLabel: UILabel!
    
    @IBOutlet weak var assRightTopLabel: UILabel!
    
    
    @IBOutlet weak var asiRightTopLabel: UILabel!
    
    
    @IBOutlet weak var vidRightTopLabel: UILabel!
    
    
    @IBOutlet weak var videoView: UIView!
    
    
    @IBOutlet weak var vidLeftTopLabel: UILabel!
    
    
    
 
    @IBOutlet weak var asiLeftTopLabel: UILabel!
    
    
    @IBOutlet weak var assLeftTopLabel: UILabel!
    
    
    @IBOutlet weak var queLeftTopLabel: UILabel!
    
    
    
    @IBOutlet weak var vidMiddleLabel: UILabel!
    
    
    
    @IBOutlet weak var vidMiddleView: UIView!
    
    
    @IBOutlet weak var asiMiddleView: UIView!
    
    
    
    
    
    
    
    
    @IBOutlet weak var assignmentView: UIView!
    
    @IBOutlet weak var asiMiddleLabel: UILabel!
    
    @IBOutlet weak var assMiddleLabel: UILabel!
    
    
    
    
    
    
    @IBOutlet weak var queryView: UIView!
    
    @IBOutlet weak var queMiddleLabel: UILabel!
    
    @IBOutlet weak var queMiddleView: UIView!
    
    
    @IBOutlet weak var assMiddleView: UIView!
    @IBOutlet weak var AssessmentView: UIView!
    
    @IBOutlet weak var vidLeftBottomLabel: UILabel!
    
    
    @IBOutlet weak var asiLeftBottomLabel: UILabel!
    
    
    @IBOutlet weak var assLeftBottomLabel: UILabel!
    
    
    
    @IBOutlet weak var queLEftBottomLabel: UILabel!
    
    
    @IBOutlet weak var scrollViewForImageSlider: UIScrollView!
    
    @IBOutlet weak var pageControlForImageSlider: PageControlForImagesInSignUpScreen!
    
    
    @IBOutlet weak var notesLabel: UILabel!
    
    
    @IBOutlet weak var notesChart: BarChartView!
    
    
    @IBOutlet weak var notesChartDescription: UIView!
    
    @IBOutlet weak var assignmentLabel: UILabel!
    
    
    @IBOutlet weak var assignementChart: LineChartView!
    
    @IBOutlet weak var assignemntDescription: UIView!
    
    
    
    @IBOutlet weak var assessmentLabel: UILabel!
    
    
    
    @IBOutlet weak var assessmentChart: LineChartView!
    
    
    @IBOutlet weak var assessmentDescription: UIView!
    
    
    var model:TDashboardData?
    
    var numberOFpagesForSliider : Int?

    
    
    @IBOutlet weak var notes1: UILabel!
    
    
    @IBOutlet weak var notes2: UILabel!
    
    
    @IBOutlet weak var notes3: UILabel!
    
    
    @IBOutlet weak var notes4: UILabel!
    
    
    @IBOutlet weak var notes5: UILabel!
    
    @IBOutlet weak var asi1: UILabel!
    
    
    @IBOutlet weak var asi2: UILabel!
    
    
    @IBOutlet weak var asi3: UILabel!
    
    
    @IBOutlet weak var asi4: UILabel!
    
    @IBOutlet weak var asi5: UILabel!
    
    
    
    @IBOutlet weak var ass1: UILabel!
    
    
    @IBOutlet weak var ass2: UILabel!
    
    @IBOutlet weak var ass3: UILabel!
    
    
    @IBOutlet weak var ass4: UILabel!
    
    
    @IBOutlet weak var ass5: UILabel!
    
    
    @IBOutlet weak var mainscrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.mainscrollView.addScalableCover(with: ModelManager.singleton.courseImage)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetctDataFromServer()
    }
    
    func fetctDataFromServer()
    {
    let headers : [String:String] = [
    "user_id": String(format: "%d", ModelManager.singleton.loginData.resultData.user.userId.intValue),
    "token": ModelManager.singleton.loginData.token,
    "deviceType": "IOS"
    ]
    let str = String(format: "batch_id=%d",self.selectedCourseObj.id.intValue)
    ServerCommunication.singleton.requestWithPost(T_API_GET_BATCH_ANALYTICS ,headerDict: headers, postString: str, success: { (successResponseDict) -> Void in
    print(successResponseDict)
    self.model = JSONOBJECTPARSER.parseJsonData(DataUtils.convertStringForAltaObjectParser("TDashboardData"), jsonData: successResponseDict.value(forKey: "resultData") as! NSDictionary) as? TDashboardData
        
    //self.modulesTableView.reloadData()
        
        // implement all the functionality after response comes elegently
        
        
        self.setUpLiveClasses((self.model?.batch_info.analytics)!)
        self.setUpNotes((self.model?.batch_info.analytics)!)
        self.setUpvideos((self.model?.batch_info.analytics)!)
        self.setUpAssignments((self.model?.batch_info.analytics)!)
        self.setUpAssessments((self.model?.batch_info.analytics)!)
        self.setUpqueries((self.model?.batch_info.queries)!)
        
        self.addImageInSlider()
        self.addPageControl()
        self.ImplementStackBar()  //uncomment
        self.implementChartLineForAssessment()   // uncomment
        self.implementChartLineForAssignment() // uncomment
        
    
    }) { (errorResponseDict) -> Void in
    DataUtils.showAlertMessage(errorResponseDict.value(forKey: "errDesc") as! String, withTitle: "", delegate: self)
    }
    }
    
   
    func setUpLiveClasses(_ model:Analytics)
    {
        self.attLeftTopLabel.text = model.total_live_class
        self.attLeftBottomLabel.text = "Live Classes"
        self.attMiddleLabel.text = model.avg_lc_comp_percent + "% Attendance"
        let l = Int(model.total_liveclass_minutes)!/60
        let r = Int(model.total_liveclass_minutes)!%60
        let str:String = "\(l):\(r) hrs"
        self.attRightTopLabel.text = str
        drawLineFromPoint(CGPoint(x: Double(self.attMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (self.attMiddleView ), model.avg_lc_comp_percent)
        //self.attMiddleView.isHidden = true
    }
    func setUpNotes(_ model: Analytics)
    {
        self.notLeftTopLabel.text = model.total_notes
        self.notLeftBottomLabel.text = "Notes"
        self.notMiddleLabel.text = model.avg_notes_comp_percent + "% Completed"
        self.notRightTopLabel.text = model.total_notes_pages + " Pages"
        
        drawLineFromPoint(CGPoint(x: Double(self.notMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (self.notMiddleView ), model.avg_notes_comp_percent)
        //self.notMiddleView.isHidden = true
    }
    
    func setUpvideos(_ model: Analytics)
    {
        
        self.vidLeftTopLabel.text = model.total_video
        self.vidLeftBottomLabel.text = "Videos"
        self.vidMiddleLabel.text = model.avg_intvideo_comp_percent + "% Completed"
       drawLineFromPoint(CGPoint(x: Double(self.vidMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (self.vidMiddleView ), model.avg_video_comp_percent)
        let l = Int(model.total_liveclass_minutes)!/60
        let r = Int(model.total_liveclass_minutes)!%60
        let str:String = "\(l):\(r) hrs"
        self.vidRightTopLabel.text = str
        //self.vidMiddleView.isHidden = true
    }
    
    func setUpAssignments(_ model: Analytics)
    {
        
        self.asiLeftTopLabel.text = model.total_assignment
        self.asiLeftBottomLabel.text = "Assignments"
        self.asiMiddleLabel.text = model.avg_assignment_comp_percent + "% Submitted"
       drawLineFromPoint(CGPoint(x: Double(self.asiMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (self.asiMiddleView ), model.avg_assignment_comp_percent)
        self.asiRightTopLabel.text = model.assignment_students_count + " Students"
        //self.asiMiddleView.isHidden = true

    }
    func setUpAssessments(_ model:Analytics)
    {
        
        self.assLeftTopLabel.text = model.total_assessment
        self.assLeftBottomLabel.text = "Assessments"
        self.assMiddleLabel.text = model.avg_assessment_comp_percent + "% Submitted"
        self.assRightTopLabel.text = model.assignment_students_count + " Students"
        
       drawLineFromPoint(CGPoint(x: Double(self.assMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (self.assMiddleView ),model.avg_assessment_comp_percent)
        //self.assMiddleView.isHidden = true

  
    }
    func setUpqueries(_ model: Queries)
    {
        
        self.queLeftTopLabel.text = model.num_queries
        self.queLEftBottomLabel.text = "Queries for Faculty"
        let per :Int
        if(Int(model.num_queries) != 0 ){
       per = Int(Int(model.num_queries_answered)! / Int(model.num_queries)!)*100
               }
        else
        {
            per = 0
        }
        self.queMiddleLabel.text = String(per) + "% Answered"

       // self.attRightTopLabel.text = str
        drawLineFromPoint(CGPoint(x: Double(self.queMiddleView.frame.size.width - 10) * (0/100), y: 20.0), ofColor: DataUtils.colorWithHexString("3bab14"), inView: (self.queMiddleView ), String(per) )
        self.queRightTopLabel.text  =  model.num_students + " Students"
       // self.queMiddleView.isHidden = true
 
    }
    
    func addImageInSlider(){
   // timer?.invalidate()
    let scrollViewWidth: CGFloat = self.scrollViewForImageSlider.frame.size.width
    // width of scrollView for images
    let scrollViewHeight: CGFloat = self.scrollViewForImageSlider.frame.size.height
        
    let modelArray  = self.model?.batch_info.live_classes
        numberOFpagesForSliider = self.model?.batch_info.live_classes.count

    for i in 0..<self.model!.batch_info.live_classes.count
    {
    let Sub = modelArray?[i] as! Live_Classes
  
        let viewForLiveClasses = Bundle.main.loadNibNamed("DetailDashBoardFirstView", owner: self, options: nil)?[0] as? UIView as! DetailDashBoardFirstView?
        viewForLiveClasses?.frame = CGRect(x:  CGFloat(CGFloat(i) * scrollViewWidth) , y:0, width: (self.scrollViewForImageSlider?.frame.size.width)!, height: (self.scrollViewForImageSlider?.frame.size.height)!)
        viewForLiveClasses?.setUpTheLabels(Sub)
        self.scrollViewForImageSlider.addSubview(viewForLiveClasses!)
    }
    self.scrollViewForImageSlider.showsVerticalScrollIndicator = false
    self.scrollViewForImageSlider.showsHorizontalScrollIndicator = false
    let count:CGFloat = CGFloat(self.model!.batch_info.live_classes.count)
    self.scrollViewForImageSlider.contentSize = CGSize(width: CGFloat(scrollViewWidth * count), height: CGFloat(scrollViewHeight))
    self.scrollViewForImageSlider.setContentOffset(CGPoint(x: CGFloat(0), y: CGFloat(0)), animated: true)
   
}

    func addPageControl() {
        self.pageControlForImageSlider.numberOfPages = (numberOFpagesForSliider)!
        self.pageControlForImageSlider.addTarget(self, action: #selector(self.onPageControlPageChanged), for: .valueChanged)
        let page: Int = Int(self.scrollViewForImageSlider.contentOffset.x) / Int(self.scrollViewForImageSlider.frame.size.width)
        self.pageControlForImageSlider.currentPage = page
        self.pageControlForImageSlider.setCurrentPageLocal(page)
        
        //page is set to current image in UIPageControl on changing image in scrollView for images
    }

    func onPageControlPageChanged(_ pageControl_: UIPageControl) {
        
        if let pageControlLocal : PageControlForImagesInSignUpScreen  = pageControl_ as? PageControlForImagesInSignUpScreen {
            let offsetX: CGFloat = CGFloat(pageControlLocal.currentPage) * self.scrollViewForImageSlider.frame.size.width
            let offset = CGPoint(x: CGFloat(offsetX), y: CGFloat(0))
            self.scrollViewForImageSlider.setContentOffset(offset, animated: true)
            //offset of scrollview for images is changed on changing pagecontrol
            pageControlLocal.setCurrentPageLocal(pageControl_.currentPage)
        }
        
        
    }
    
    
    
    
    func drawLineFromPoint(_ end:CGPoint, ofColor lineColor: UIColor, inView view:UIView, _ attendance_percentage : String = "0") {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 20))
        path.addLine(to: CGPoint(x: Double(view.frame.size.width ) * Double(attendance_percentage)!/100, y: 20))
        //
        //        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.strokeColor = UIColor.init(hexString: "2F9DD4").cgColor
        shapeLayer.lineWidth = 10.0
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 0, y: 20))
        path1.addLine(to: CGPoint(x: view.frame.size.width, y: 20))
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.path = path1.cgPath
        shapeLayer1.strokeColor = UIColor.init(hexString: "D2D4D6").cgColor
        shapeLayer1.lineWidth = 10.0
        //        shapeLayer1.addSublayer(shapeLayer)
        view.layer.addSublayer(shapeLayer1)
        view.layer.addSublayer(shapeLayer)
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView_: UIScrollView) {
        if(scrollView_.tag == 2){
        let page: Int = Int(self.scrollViewForImageSlider.contentOffset.x) / Int(self.scrollViewForImageSlider.frame.size.width)
        self.pageControlForImageSlider.currentPage = page
        self.pageControlForImageSlider.setCurrentPageLocal(page)
        
        //page is set to current image in UIPageControl on changing image in scrollView for images
        }
       // timer?.invalidate()
    }
    
    
    // for charts methods
    func ImplementStackBar()
    {
        //notesChart.description = ""
        //notesChart.description = ""
        notesChart.getAxis(.right).enabled = false
        notesChart.xAxis.labelPosition  = .bottom
        notesChart.drawGridBackgroundEnabled = true
        let l: Legend? = notesChart.legend
        l?.drawInside = false
        l?.form = .square
        notesChart.xAxis.centerAxisLabelsEnabled = false
        notesChart.xAxis.granularity = 1
        updateChartDataForStackedBar()
    }
    
    func updateChartDataForStackedBar()
    {
      setDataCountForStackedBar()
    }
    
    func setDataCountForStackedBar()
    {
        
            //        for i in 0..<count {
            //            let mult: Double = (range + 1)
            //            let val1 = Double(arc4random_uniform(UInt32(mult)) + mult / 3)
            //            let val2 = Double(arc4random_uniform(UInt32(mult)) + mult / 3)
            //            let val3 = Double(arc4random_uniform(UInt32(mult)) + mult / 3)
            //            yVals.append(BarChartDataEntry(x: i, yValues: [(val1), (val2), (val3)], icon: UIImage(named: "icon")))
            //        }
            var set1: BarChartDataSet? = nil
            //        if (chartView.data?.dataSetCount)! > 0 {
            ////            set1 = (chartView.data?.dataSets[0] as? BarChartDataSet)
            ////            set1?.values = yVals as! [ChartDataEntry]
            ////            chartView.data?.notifyDataChanged()
            ////            chartView.notifyDataSetChanged()
            //        }
            //        else {
            notesChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:["0","1","2","3","4"])
            
           // let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        
       let notes =  self.model?.batch_info.notes
        updateNotesLabel(notes!)
        
            var dataEntries: [BarChartDataEntry] = []
            for i in 0..<(notes?.count)! {
                // let dataEntry = BarChartDataEntry(x: values[i], y: Double(i))
                
                //          "completed": 0,
                
        let arrForY = [Double((notes?[i] as! NotesAndVideo).completed) ,Double((notes?[i] as! NotesAndVideo).not_started),Double((notes?[i] as! NotesAndVideo).in_progress)]
        let dataEntry = BarChartDataEntry(x: Double(i), yValues: arrForY as! [Double])
            
            // let dataEntry2 = BarChartDataEntry(
            dataEntries.append(dataEntry)
            }
            
            // let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
            //let chartData = BarChartData(dataSet: chartDataSet)
            
        
            set1 = BarChartDataSet(values: dataEntries, label: "")
            set1?.drawIconsEnabled = false
            //set1?.colors = [ChartColorTemplates.material[0], ChartColorTemplates.material[1], ChartColorTemplates.material[2]]
        
        //299DD5
        //F07A1A
        //3C4B5C
        
        set1?.colors = [UIColor.init(hexString:"299DD5") , UIColor.init(hexString:"F07A1A"),UIColor.init(hexString:"3C4B5C")]
        //ChartColorTemplates.colorful()
            set1?.stackLabels = ["Completed", "In-Progress", "Not Started"]
            var dataSets = [BarChartDataSet]()
            dataSets.append(set1!)
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            // formatter.negativeSuffix = " $"
            //formatter.positiveSuffix = " $"
            let data = BarChartData(dataSets: dataSets)
            
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: CGFloat(7.0))!)
            data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            data.setValueTextColor(UIColor.white)
            notesChart.fitBars = true
            notesChart.data = data
 
        }
    
    func updateNotesLabel(_ model:NSAMutableArray)
    {
        
        if model.count == 0 {
            notes1.text = ""
            notes2.text = ""
            notes3.text = ""
            notes4.text = ""
            notes5.text = ""
        }
        
        //"4) -> " +
        //
        if model.count == 1{
            notes1.text = "0) -> "  + (model[0] as! NotesAndVideo).title
            notes2.text = ""
            notes3.text = ""
            notes4.text = ""
            notes5.text = ""
        }
        if model.count == 2
        {   notes1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            notes2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            notes3.text = ""
            notes4.text = ""
            notes5.text = ""
        }
      


        
        if model.count == 3{
    notes1.text = "0) -> " + (model[0] as! NotesAndVideo).title
    notes2.text = "1) -> " + (model[1] as! NotesAndVideo).title
    notes3.text = "2) -> " + (model[2] as! NotesAndVideo).title
    notes4.text = ""
            notes5.text = ""
                            }
        
        if model.count == 4
        {   notes1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            notes2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            notes3.text = "2) -> " + (model[2] as! NotesAndVideo).title
            notes4.text = "3) -> " + (model[3] as! NotesAndVideo).title
            notes5.text = ""
        }
        
        if model.count == 5
        {
            notes1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            notes2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            notes3.text = "2) -> " + (model[2] as! NotesAndVideo).title
            notes4.text = "3) -> " + (model[3] as! NotesAndVideo).title
            notes5.text = "4) -> " + (model[4] as! NotesAndVideo).title
           // notes5.text = (model[4] as! NotesAndVideo).title
        }
    }
    
    func updateAssignmentLabel( model:NSAMutableArray)
    {
        if model.count == 0 {
            asi1.text = ""
            asi2.text = ""
            asi3.text = ""
            asi4.text = ""
            asi5.text = ""
        }
        
        
        if model.count == 1{
            asi1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            asi2.text = ""
            asi3.text = ""
            asi4.text = ""
            asi5.text = ""
        }
        if model.count == 2
        {   asi1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            asi2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            asi3.text = ""
            asi4.text = ""
            asi5.text = ""
        }
        
        
        if model.count == 3{
            asi1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            asi2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            asi3.text = "2) -> " +  (model[2] as! NotesAndVideo).title
            asi4.text = ""
            asi5.text = ""
        }
        
        
        if model.count == 4
        {   asi1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            asi2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            asi3.text = "2) -> " + (model[2] as! NotesAndVideo).title
            asi4.text = "3) -> " + (model[3] as! NotesAndVideo).title
           // asi5.text = "4) -> " + (model[4] as! NotesAndVideo).title
        }
        
        
        if model.count == 5
        {
            asi1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            asi2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            asi3.text = "2) -> " + (model[2] as! NotesAndVideo).title
            asi4.text = "3) -> " + (model[3] as! NotesAndVideo).title
            asi5.text   = "4) -> " + (model[4] as! NotesAndVideo).title
            // notes5.text = (model[4] as! NotesAndVideo).title
        }

    }
    
    func updateAssessmentLabel(_ model:NSAMutableArray)
    {
        if model.count == 0 {
            ass1.text = ""
            ass2.text = ""
            ass3.text = ""
            ass4.text = ""
            ass5.text = ""
        }
        
        
        if model.count == 1{
            ass1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            ass2.text = ""
            ass3.text = ""
            ass4.text = ""
            ass5.text = ""
        }
        if model.count == 2
        {   ass1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            ass2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            ass3.text = ""
            ass4.text = ""
            ass5.text = ""
        }
        
        
        if model.count == 3{
            ass1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            ass2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            ass3.text = "2) -> " + (model[2] as! NotesAndVideo).title
            ass4.text = ""
            ass5.text = ""
        }
        
        
        if model.count == 4
        {   ass1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            ass2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            ass3.text = "2) -> " + (model[2] as! NotesAndVideo).title
            ass4.text = "3) -> " + (model[3] as! NotesAndVideo).title
            //ass5.text = "4) -> " + (model[4] as! NotesAndVideo).title
        }
        
        
        if model.count == 5
        {
            ass1.text = "0) -> " + (model[0] as! NotesAndVideo).title
            ass2.text = "1) -> " + (model[1] as! NotesAndVideo).title
            ass3.text = "2) -> " + (model[2] as! NotesAndVideo).title
            ass4.text = "3) -> " + (model[3] as! NotesAndVideo).title
            ass5.text   = "4) -> " + (model[4] as! NotesAndVideo).title
            // notes5.text = (model[4] as! NotesAndVideo).title
        }
    }
    
    func implementChartLineForAssignment()
    {

        assignementChart.chartDescription?.text = ""
        assignementChart.dragEnabled = true
        assignementChart.setScaleEnabled(true)
        assignementChart.pinchZoomEnabled = true
        assignementChart.drawGridBackgroundEnabled = false
        assignementChart.rightAxis.enabled = false
     
        assignementChart.legend.form = .line
        updateChartDataForLineChart()

    }

    func updateChartDataForLineChart()
    {
        setDataCountForLineChartForAssignment()
    }
    
    func setDataCountForLineChartForAssignment()
    {
        var set1: LineChartDataSet? = nil
        //        if chartView.data.dataSetCount > 0 {
        //            set1 = (chartView.data.dataSets[0] as? LineChartDataSet)
        //            set1?.values = values
        //            chartView.data.notifyDataChanged()
        //            chartView.notifyDataSetChanged()
        //        }
        //        else {
        
        
        assignementChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:["0","1","2","3","4"])
        assignementChart.xAxis.labelPosition  = .bottom
        

        
        var dataEntries: [ChartDataEntry] = []
       // uncomment it

        var assignment  = self.model?.batch_info.assignment
        
        updateAssignmentLabel(model: assignment!)
        
        
        for i in 0..<(assignment?.count)! {
            // let dataEntry = BarChartDataEntry(x: values[i], y: Double(i))
            let obj = (assignment?[i]) as! NotesAndVideo
          let value:Double = Double(Int(obj.completed)/(Int(obj.completed) + Int(obj.not_started))*100)
            let dataEntry = ChartDataEntry(x: Double(i), y: value)
            
            
            // let dataEntry2 = BarChartDataEntry(
            dataEntries.append(dataEntry)
        }
        
        set1 = LineChartDataSet(values: dataEntries, label: "DataSet 1")
        set1?.drawIconsEnabled = false
        //set1?.lineDashLengths = [5.0, 2.5]
        //set1?.highlightLineDashLengths = [5.0, 2.5]
        set1?.colors = [UIColor.init(hexString:"299DD5")]
        set1?.circleColors = [UIColor.white]
        set1?.drawCircleHoleEnabled = true
        set1?.circleHoleColor = UIColor.blue
        set1?.lineWidth = 1.0
        set1?.circleRadius = 6.0
        set1?.circleHoleRadius = 2.0
        //set1?.drawCircleHoleEnabled = false
        set1?.valueFont = UIFont.systemFont(ofSize: CGFloat(9.0))
        //set1?.formLineDashLengths = [5.0, 2.5]
        //set1?.formLineWidth = 1.0
        set1?.formSize = 15.0
        let gradientColors: [Any]? = [(ChartColorTemplates.colorFromString("#00ff0000").cgColor), (ChartColorTemplates.colorFromString("#ffff0000").cgColor)]
        let gradient: CGGradient? = CGGradient(colorsSpace: nil, colors: (gradientColors)! as CFArray, locations: nil)
        set1?.fillAlpha = 0.8
       // set1?.fill = Fill(linearGradient: gradient!, angle: 90.0)
      //  set1?.fill = UIColor.init(hexString: "299DD5").cgColor
        set1?.fill = Fill(CGColor: UIColor.init(hexString:"B9DEF1").cgColor)
        set1?.drawFilledEnabled = true
        var dataSets = [LineChartDataSet]()
        dataSets.append(set1!)
        let data = LineChartData(dataSets: dataSets)
        assignementChart.xAxis.granularity = 1
        assignementChart.getAxis(.right).drawGridLinesEnabled = false
        assignementChart.getAxis(.left).drawGridLinesEnabled = false
        
        assignementChart.data = data

    }

    
    func implementChartLineForAssessment()
    {
        assessmentChart.chartDescription?.text = ""
        assessmentChart.dragEnabled = true
        assessmentChart.setScaleEnabled(true)
        assessmentChart.pinchZoomEnabled = true
        assessmentChart.drawGridBackgroundEnabled = false
        assessmentChart.rightAxis.enabled = false
        assignementChart.legend.form = .line
        updateChartDataForLineChartForAssessMent()
    }
    
    func updateChartDataForLineChartForAssessMent()
    {
        setDataCountForLineChartForAssessment()
    }
    
    func setDataCountForLineChartForAssessment()
    {
        var set1: LineChartDataSet? = nil
        //        if chartView.data.dataSetCount > 0 {
        //            set1 = (chartView.data.dataSets[0] as? LineChartDataSet)
        //            set1?.values = values
        //            chartView.data.notifyDataChanged()
        //            chartView.notifyDataSetChanged()
        //        }
        //        else {
        
        assignementChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:["0","1","2","3","4"])
        assignementChart.xAxis.labelPosition  = .bottom
        
      //  let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        var dataEntries: [ChartDataEntry] = []
        
        let assessment  = self.model?.batch_info.assessment
        
        updateAssessmentLabel(assessment!)
        
        for i in 0..<(assessment?.count)! {
            // let dataEntry = BarChartDataEntry(x: values[i], y: Double(i))
            let obj = (assessment?[i]) as! NotesAndVideo
          let value:Double = Double(Int(obj.completed)/(Int(obj.completed) + Int(obj.not_started))*100)
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(value))
            
            // let dataEntry2 = BarChartDataEntry(
            dataEntries.append(dataEntry)
        }
        
        set1 = LineChartDataSet(values: dataEntries, label: "DataSet 1")
        set1?.drawIconsEnabled = false
        //set1?.lineDashLengths = [5.0, 2.5]
        //set1?.highlightLineDashLengths = [5.0, 2.5]
        set1?.colors = [UIColor.init(hexString:"299DD5")]
        set1?.circleColors = [UIColor.white]
        set1?.drawCircleHoleEnabled = true
        set1?.circleHoleColor = UIColor.blue
        set1?.lineWidth = 1.0
        set1?.circleRadius = 6.0
        set1?.circleHoleRadius = 2.0
        //set1?.drawCircleHoleEnabled = false
        set1?.valueFont = UIFont.systemFont(ofSize: CGFloat(9.0))
        //set1?.formLineDashLengths = [5.0, 2.5]
        //set1?.formLineWidth = 1.0
        set1?.formSize = 15.0
        let gradientColors: [Any]? = [(ChartColorTemplates.colorFromString("#00ff0000").cgColor), (ChartColorTemplates.colorFromString("#ffff0000").cgColor)]
        let gradient: CGGradient? = CGGradient(colorsSpace: nil, colors: (gradientColors)! as CFArray, locations: nil)
        set1?.fillAlpha = 0.8
       // set1?.fill = Fill(linearGradient: gradient!, angle: 90.0)
        set1?.drawFilledEnabled = true
        set1?.fill = Fill(CGColor: UIColor.init(hexString: "B9DEF1").cgColor)
        var dataSets = [LineChartDataSet]()
        dataSets.append(set1!)
        let data = LineChartData(dataSets: dataSets)
        assessmentChart.xAxis.granularity = 1
        assessmentChart.getAxis(.right).drawGridLinesEnabled = false
        assessmentChart.getAxis(.left).drawGridLinesEnabled = false
        assessmentChart.data = data
    }
}

