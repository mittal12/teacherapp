//
//  ReferViewController.swift
//  TalentEdge
//
//
import UIKit

class ReferViewController: UIViewController {

    @IBOutlet weak var referalCodeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        referalCodeLabel.text = ModelManager.singleton.loginData.resultData.user.referral_code
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func referButtonAction(_ sender: AnyObject) {

        let activity = UIActivityViewController(activityItems: ["Swift"], applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)
//        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
//        [self presentViewController:activityController animated:YES completion:nil];
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
