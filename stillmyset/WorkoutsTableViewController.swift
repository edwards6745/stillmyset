import UIKit
import CoreData
import CardStyleTableView

class WorkoutsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var workoutsTable: UITableView!
    
    let dateFormatter = DateFormatter()
    var workouts : [Workout] = []
    let cellSpacingHeight: CGFloat = 20
    var workoutNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutsTable.rowHeight = 50.0
        workoutsTable.backgroundColor = UIColor.clear
        workoutsTable.dataSource = self
        workoutsTable.delegate = self
        dateFormatter.dateFormat = "M/d/yyyy"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDecks()
        workoutsTable.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "toDeck" {
            if let cell = sender as? UITableViewCell, let indexPath = workoutsTable.indexPath(for: cell) {
                let exerciseViewController = segue.destination as! ExercisePageViewController
                let workout = workouts[indexPath.section]
                exerciseViewController.workout = workout
            }
        }
        if segue.identifier == "toAddDeck" {
            
            if let cell = sender as? UITableViewCell, let indexPath = workoutsTable.indexPath(for: cell)
            {
                let destinationNavigationController = segue.destination as! UINavigationController
                let addDeckViewController = destinationNavigationController.topViewController as! AddDeckViewController
                let workout = workouts[indexPath.section]
                addDeckViewController.workout = workout
            }
        }
        if segue.identifier == "toAddCard" {
            if let cell = sender as? UITableViewCell, let indexPath = workoutsTable.indexPath(for: cell)
            {
                let destinationNavigationController = segue.destination as! UINavigationController
                let addDeckViewController = destinationNavigationController.topViewController as! AddCardViewController
                let workout = workouts[indexPath.section]
                addDeckViewController.workout = workout
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return workouts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deckCell") as! WorkoutsTableViewCell
        
        let workout = workouts[indexPath.section]
        
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = false
        cell.title.text = workout.name!
        cell.desc.text = dateFormatter.string(from: workout.workoutDate!)
        cell.badge.text = getBadgeNumberString(workout: workout)
        
        if(getBadgeNumberString(workout: workout) > "1") {
            cell.badge.isHidden = false
            cell.exerciseLabel.isHidden = false
            cell.swipeLeft.isHidden = true
            cell.exerciseLabel.text = "exercises"
        } else if (getBadgeNumberString(workout: workout) == "0") {
            cell.badge.isHidden = true
            cell.exerciseLabel.isHidden = true
            cell.swipeLeft.isHidden = false
        }else {
            cell.badge.isHidden = false
            cell.exerciseLabel.isHidden = false
            cell.swipeLeft.isHidden = true
            cell.exerciseLabel.text = "exercise"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: self.cellSpacingHeight/2))
        customView.backgroundColor = UIColor.clear
        return customView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = workoutsTable.cellForRow(at: indexPath) as? WorkoutsTableViewCell {
            self.performSegue(withIdentifier: "toDeck", sender: cell)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addCard = UITableViewRowAction(style: .normal, title: "Add\nExercise") { (action, indexPath) in
            
            let cell = self.workoutsTable.cellForRow(at: indexPath)
            self.performSegue(withIdentifier: "toAddCard", sender: cell)
        }
        addCard.backgroundColor = UIColor.init(red: 80/255, green: 181/255, blue: 113/255, alpha: 1.0)
        
        let editCard = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let cell = self.workoutsTable.cellForRow(at: indexPath)
            self.performSegue(withIdentifier: "toAddDeck", sender: cell)
        }
        editCard.backgroundColor = UIColor.darkGray
        let deleteCard = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to delete this deck? All included cards will also be deleted.", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let deck = self.workouts[indexPath.row]
                
                context.delete(deck)
                AppDelegate.saveContext()
                
                self.fetchDecks()
                self.workoutsTable.reloadData()
            })
            alertController.addAction(deleteAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                self.workoutsTable.setEditing(false, animated: true)
            })

            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)

        }
        return [deleteCard, editCard, addCard]
    }
    
    func getBadgeNumberString(workout: Workout) -> String {
        let calendar = Calendar.current
        let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: Date())
        let tomorrowTimestamp = calendar.startOfDay(for: tomorrowDate!).timeIntervalSince1970
        let datePredicate = NSPredicate(format: "nextShown < %f", tomorrowTimestamp)
        let filteredDeck = workout.exercises?.filtered(using: datePredicate) as NSSet?
        let cardsSet = filteredDeck! as! Set<Exercise>
        let count = cardsSet.count
        
        return "\(count)"
    }
    
    
    func fetchDecks() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            workouts = try context.fetch(Workout.fetchRequest())
        }
        catch {
            let alert = UIAlertController(title: "Error", message: "There was an error fetching your data, try restarting the application.", preferredStyle: UIAlertControllerStyle.alert)
            let dismissAction = UIAlertAction(title: "Got it!", style: .default, handler: { (UIAlertAction) -> Void in
            })
            alert.addAction(dismissAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
