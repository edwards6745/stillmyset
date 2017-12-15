//
//  ExerciseViewController.swift
//  stillmyset
//
//  Created by Austin Edwards on 12/13/17.
//  Copyright © 2017 Austin Edwards. All rights reserved.
//

import UIKit

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}

class ExerciseViewController: UIViewController {

    @IBOutlet var exerciseName: UILabel!
    @IBOutlet var numOfReps: UILabel!
    @IBOutlet var numOfSets: UILabel!
    @IBOutlet var maxWeightText: UITextField!
    @IBOutlet var saveMaxButton: UIButton!
    
    var workout: Workout!
    var exercises: [Exercise] = []
    var pageIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseName.text = exercises[pageIndex!].name!
        exerciseName.addBottomBorderWithColor(color: UIColor.black, width: 2)
        
        guard let maxWeight = exercises[pageIndex!].maxWeight else {
            maxWeightText.text = ""
            numOfSets.text = exercises[pageIndex!].sets!
            numOfReps.text = exercises[pageIndex!].reps!
            return
        }
        
        maxWeightText.text = maxWeight
        numOfSets.text = exercises[pageIndex!].sets!
        numOfReps.text = exercises[pageIndex!].reps!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func saveMax(_ sender: Any) {
        let AppDelegate = UIApplication.shared.delegate as! AppDelegate
        exercises[pageIndex!].maxWeight = maxWeightText.text
        AppDelegate.saveContext()
        
        let alert = UIAlertController(title: "Max Weight Saved!", message: "The max weight for \"" + (exercises[pageIndex!].name!) + "\" has been saved!", preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "Got it!", style: .default, handler: { (UIAlertAction) -> Void in
        })
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
}
