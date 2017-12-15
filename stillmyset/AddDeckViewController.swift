import UIKit

class AddDeckViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var addDeckTextField: UITextField!
    @IBOutlet var workoutDate: UIDatePicker!
    @IBOutlet var bodyPart: UIPickerView!
    
    
    var pickerDataSource = ["Legs", "Back", "Shoulders", "Chest", "Abs"]
    var workout: Workout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        //calendar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar as Calendar
        components.month = 0
        let minDate: NSDate = calendar.date(byAdding: components as DateComponents, to: NSDate() as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        workoutDate.minimumDate = minDate as Date
        workoutDate.datePickerMode = UIDatePickerMode.date
        
        self.bodyPart.dataSource = self
        self.bodyPart.delegate = self
        
        if(workout != nil)
        {
            addDeckTextField.text = workout.name
            workoutDate.date = workout.workoutDate!
            
            if(workout.bodyPart == "Legs") {
                bodyPart.selectRow(0, inComponent: 0, animated: false)
            }else if(workout.bodyPart == "Back") {
                bodyPart.selectRow(1, inComponent: 0, animated: false)
            }else if(workout.bodyPart == "Shoulders") {
                bodyPart.selectRow(2, inComponent: 0, animated: false)
            }else if(workout.bodyPart == "Chest") {
                bodyPart.selectRow(3, inComponent: 0, animated: false)
            }else if(workout.bodyPart == "Abs") {
                bodyPart.selectRow(4, inComponent: 0, animated: false)
            }
            
            self.title = "Edit Workout"
        }
    }
    
    @IBAction func cancelAddDeck(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addDeck(_ sender: UIBarButtonItem) {
        
        if let deckTextField = addDeckTextField.text, !deckTextField.isEmpty
        {
            let AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = AppDelegate.persistentContainer.viewContext
            
            if(workout == nil)
            {
                workout = Workout(context: context)
            }
            
            workout.name = addDeckTextField.text
            workout.workoutDate = workoutDate.date
            workout.bodyPart = pickerDataSource[bodyPart.selectedRow(inComponent: 0)]
            
            //clear out the exercises if this is edited
            
            AppDelegate.saveContext()
            self.dismiss(animated: true)

        } else {
            let alert = UIAlertController(title: "Inserting Default Name", message: "Since you didn't enter a workout name, the default \"" + self.pickerDataSource[self.bodyPart.selectedRow(inComponent: 0)] + " Workout\" will be used.", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) -> Void in
                let AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = AppDelegate.persistentContainer.viewContext
                
                self.workout = Workout(context: context)
                self.workout.name = self.pickerDataSource[self.bodyPart.selectedRow(inComponent: 0)] + " Workout"
                self.workout.workoutDate = self.workoutDate.date
                self.workout.bodyPart = self.pickerDataSource[self.bodyPart.selectedRow(inComponent: 0)]
                AppDelegate.saveContext()
                self.dismiss(animated: true)
            })
            let dismissAction = UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) -> Void in
            })
            alert.addAction(defaultAction)
            alert.addAction(dismissAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    private func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
}
