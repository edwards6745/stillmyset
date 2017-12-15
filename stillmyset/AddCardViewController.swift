import UIKit

class AddCardViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var exerciseName: UITextField!
    @IBOutlet var exerciseSets: UITextField!
    @IBOutlet weak var exerciseReps: UITextField!
    
    @IBOutlet weak var saveExerciseButton: UIBarButtonItem!
    
    var workout: Workout!
    var exercise: Exercise!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if(exercise != nil)
        {
            exerciseName.text = exercise.name
            exerciseSets.text = exercise.sets
            exerciseReps.text = exercise.reps
            
            self.title = "Edit Exercise"
        }
    }
    
    @IBAction func cancelModal(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil )
    }
    
    @IBAction func saveExercise(_ sender: UIBarButtonItem) {
        if !((exerciseName.text?.isEmpty)!) && !(exerciseSets.text?.isEmpty)! && !(exerciseReps.text?.isEmpty)!
        {
            let AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = AppDelegate.persistentContainer.viewContext
            
            if(exercise != nil)
            {
                exercise.name = exerciseName.text
                exercise.sets = exerciseSets.text
                exercise.reps = exerciseReps.text
            }
            else
            {
                let exercise = Exercise(context: context)
                
                exercise.name = exerciseName.text
                exercise.sets = exerciseSets.text
                exercise.reps = exerciseReps.text
                
                exercise.workout = workout
            }
            
            AppDelegate.saveContext()
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Enter the card details", message: "You must enter both front and back text for your card", preferredStyle: UIAlertControllerStyle.alert)
            let dismissAction = UIAlertAction(title: "Got it!", style: .default, handler: { (UIAlertAction) -> Void in
            })
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
