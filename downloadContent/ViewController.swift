//
//  ViewController.swift
//  downloadContent
//
//  Created by Yair Hernandez on 27/05/16.
//
//

import UIKit
import Alamofire
import Zip

class ViewController: UIViewController {
    
    @IBOutlet weak var progressLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func downloadContent(sender: UIButton) {
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        let download = Alamofire.download(.GET, "https://s3.amazonaws.com/applicadosunits/ABC/NIVEL+1/Unidad1.zip", destination: destination)
        
        download.progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
            print(totalBytesRead)
            print(bytesRead)
            
            // This closure is NOT called on the main queue for performance
            // reasons. To update your ui, dispatch to the main queue.
            dispatch_async(dispatch_get_main_queue()) {
                let progress: Double = (Double(totalBytesRead) / Double(totalBytesExpectedToRead)) * 100
                print("Total bytes read on main queue: \(totalBytesRead)")
                print("PROGRESS: \(progress)")
                self.progressLbl.text = String(progress.format(".0")) + "%"
//                self.progressLbl.text = String(progress.format(".2"))
            }
        }
        download.response { _, _, _, error in
            if let
                resumeData = download.resumeData,
                resumeDataString = NSString(data: resumeData, encoding: NSUTF8StringEncoding)
            {
                print("Resume Data: \(resumeDataString)")
            } else {
                print("Resume Data was empty")
            }
            if let error = error {
                print("Failed with error: \(error)")
            } else {
                print("Downloaded file successfully")
            }
        }
    }
    
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

