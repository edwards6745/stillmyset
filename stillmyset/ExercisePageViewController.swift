//
//  ExercisePageViewController.swift
//  stillmyset
//
//  Created by Austin Edwards on 12/12/17.
//  Copyright © 2017 Austin Edwards. All rights reserved.
//

import UIKit

class ExercisePageViewController: UIPageViewController {

    var workout: Workout!
    var exercisesSet: Set<Exercise> = []
    var exercises: [Exercise] = []
    var tomorrowTimestamp: Double = 0.0
    var calendar: Calendar = Calendar.current
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.title = workout?.name
        imageView = UIImageView(image: UIImage(named: "Background")!)
        imageView!.contentMode = .scaleAspectFill
        view.insertSubview(imageView!, at: 0)
        
        let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: Date())
        tomorrowTimestamp = calendar.startOfDay(for: tomorrowDate!).timeIntervalSince1970
        
        let exerciseViewController = ExerciseViewController()
        exerciseViewController.exercises = exercises
        
        sortExercises()
        
        //print("Workout: \(workout)\n")
        print("Exercises: \(exercises)\n")
        
        // Do any additional setup after loading the view.
        dataSource = self
        setViewControllers([viewControllerForPage(at: 0)], direction: .forward, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sortExercises() -> Void {
        let datePredicate = NSPredicate(format: "nextShown < %f", tomorrowTimestamp)
        let filteredDeck = workout.exercises?.filtered(using: datePredicate) as NSSet?
        
        exercisesSet = filteredDeck! as! Set<Exercise>
        
        exercises = exercisesSet.sorted { $0.updatedDate < $1.updatedDate }
    }
}

extension ExercisePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ExerciseViewController,
            let pageIndex = viewController.pageIndex,
            pageIndex > 0 else {
                return nil
        }
        return viewControllerForPage(at: pageIndex - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ExerciseViewController,
            let pageIndex = viewController.pageIndex,
            pageIndex < exercises.count - 1 else {
                return nil
        }
        
        return viewControllerForPage(at: pageIndex + 1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return exercises.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewControllers = pageViewController.viewControllers,
            let currentVC = viewControllers.first as? ExerciseViewController,
            let currentPageIndex = currentVC.pageIndex else {
                return 0
        }
        return currentPageIndex
    }
    
    func viewControllerForPage(at index: Int) -> UIViewController {
        let exerciseViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseView") as! ExerciseViewController
        print("Index: \(index)\n")
        exerciseViewController.pageIndex = index
        exerciseViewController.exercises = exercises
        return exerciseViewController
    }
    
}
