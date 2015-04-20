//
//  ViewController.swift
//  MathApp
//
//  Created by Tillson Galloway on 9/10/14.
//  Copyright (c) 2014 Tillson Galloway. All rights reserved.
//

//
//  Original file has been simplified for demo purposes
//

import UIKit

class TimedTestViewController: UIViewController {
    
    var currentProblemView = UIView()
    var currentProblem: AdditionProblem?
    var answerLabel: UITextField?
    var correct = 0
    var completedProblems = 0
    var totalTime = 0
    
    var isTransitioning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        
        view.backgroundColor = UIColor.darkGrayColor()
        
        showNextProblem(currentProblemView, forProblem: getNewProblem())
        

    }
    
    func showNextProblem(loadView: UIView, forProblem: AdditionProblem) {
        if currentProblem == nil {
            loadView.frame = CGRect(x: 15, y: 15, width: view.frame.width-30, height: view.frame.height-30)
        } else {
            loadView.frame = CGRect(x: view.frame.width+5, y: 15, width: view.frame.width-30, height: view.frame.height-30)
        }
        loadView.backgroundColor = UIColor.whiteColor()
        loadView.layer.cornerRadius = 10
        
        let topNumberLabel = UILabel()
        topNumberLabel.frame = CGRect(x: loadView.frame.width-350, y: 5, width: 300, height: 105)
        topNumberLabel.text = String(forProblem.numbers.0)
        topNumberLabel.font = UIFont.systemFontOfSize(100)
        topNumberLabel.textAlignment = NSTextAlignment.Right
        loadView.addSubview(topNumberLabel)
        
        let signLabel = UILabel()
        signLabel.frame = CGRect(x: 30, y: 115, width: 180, height: 105)
        signLabel.text = "+"
        signLabel.font = UIFont.systemFontOfSize(100)
        loadView.addSubview(signLabel)
        
        let bottomNumberLabel = UILabel()
        bottomNumberLabel.frame = CGRect(x: loadView.frame.width-350, y: 115, width: 300, height: 105)
        bottomNumberLabel.text = String(forProblem.numbers.1)
        bottomNumberLabel.font = UIFont.systemFontOfSize(100)
        bottomNumberLabel.textAlignment = NSTextAlignment.Right
        loadView.addSubview(bottomNumberLabel)
        
        let lineView = UIView()
        lineView.frame = CGRect(x: 20, y: 250, width: loadView.frame.width-40, height: 1)
        lineView.backgroundColor = UIColor.blackColor()
        loadView.addSubview(lineView)
        
        let textField = UITextField()
        textField.keyboardType = UIKeyboardType.PhonePad
        textField.frame = CGRect(x: 40, y: 255, width: loadView.frame.width-80, height: 150)
        textField.text = String(forProblem.numbers.0)
        textField.font = UIFont.systemFontOfSize(150)
        textField.text = ""
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = NSTextAlignment.Right
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 35))
        let text = completedProblems == 2 ? "Done" : "Next"
        let barButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: "nextButtonPressed:")
        barButtonItem.width = view.frame.width / 3.55
        toolbar.setItems([barButtonItem], animated: true)
        textField.inputAccessoryView = toolbar
        
        loadView.addSubview(textField)
        textField.becomeFirstResponder()
        answerLabel = textField
        
        view.addSubview(loadView)
        if currentProblem != nil {
            animateNewProblem(loadView)
        }
        currentProblem = forProblem
        
    }
    
    func animateNewProblem(newView: UIView) {
        isTransitioning = true
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.77, initialSpringVelocity: 0.9, options: nil, animations: {
            newView.frame = CGRect(x: 15, y: 15, width: self.view.frame.width-30, height: self.view.frame.height-30)
            self.currentProblemView.frame = CGRect(x: -self.view.frame.width, y: 15, width: self.view.frame.width-30, height: self.view.frame.height-30)
            }, completion: { animated in
                self.currentProblemView.removeFromSuperview()
                self.currentProblemView = newView
                self.isTransitioning = false
        })
    }
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        if isTransitioning {
            return
        }
        let answerIsCorrect = currentProblem!.answerIsCorrect((answerLabel?.text)!)
        if answerIsCorrect {
            correct++
        }
        completedProblems++
        UIView.animateKeyframesWithDuration(1.0, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.7, animations: {
                self.view.backgroundColor = (answerIsCorrect ? UIColor.greenColor() : UIColor.redColor())
            })
            UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor.grayColor()
            })
            }, completion: { animated in
                self.showNextProblem(UIView(), forProblem: self.getNewProblem())
        })
    }
    
    func endTest() {
        UIView.animateWithDuration(1.0, delay: 0.0, options: nil, animations: {
            let frame = self.currentProblemView.frame
            self.currentProblemView.frame = CGRect(x: frame.origin.x, y: -frame.height, width: frame.width, height: frame.height)
            }, completion: { animated in
                self.currentProblemView.removeFromSuperview()
                UIView.animateWithDuration(0.3, animations: {
                    self.view.backgroundColor = UIColor.whiteColor()
                    }, completion: { animated in
                    // bananas
                })
        })
    }
    
    func getNewProblem() -> AdditionProblem {
        var numbers = (Int(arc4random_uniform(18)), 100)
        while (numbers.0 + numbers.1) > 18 {
            numbers.1 = Int(arc4random_uniform(18))
        }
        return AdditionProblem(numbers: numbers)
    }
}

class AdditionProblem: NSObject {
    let numbers: (Int, Int)
    
    init(numbers: (Int, Int)) {
        self.numbers = numbers
        super.init()
    }
    
    func getAnswer() -> Int {
        return numbers.0 + numbers.1
    }
    
    func answerIsCorrect(check: String) -> Bool {
        let answerInt = check.toInt()
        if let answer = answerInt {
            if answer == getAnswer() {
                return true;
            }
        }
        return false
    }
}

