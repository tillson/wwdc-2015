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
    var answerField: UITextField?
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
        let barButtonItem = UIBarButtonItem(title: text, style: UIBarButtonItemStyle.Plain, target: self, action: "nextButtonPressed:")
        barButtonItem.width = view.frame.width / 3.55
        toolbar.setItems([barButtonItem], animated: true)
        textField.inputAccessoryView = toolbar
        
        loadView.addSubview(textField)
        textField.becomeFirstResponder()
        answerField = textField
        
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
    
    func finish() {
        answerField?.resignFirstResponder()
        
        let finishView = UIView()
        finishView.frame = CGRect(x: view.frame.width+5, y: 15, width: view.frame.width-30, height: view.frame.height-30)
        finishView.backgroundColor = UIColor.whiteColor()
        finishView.layer.cornerRadius = 10
        
        let doneLabel = UILabel()
        doneLabel.frame = CGRect(x: finishView.frame.width / 2 - 150, y: 115, width: 300, height: 175)
        doneLabel.text = "You did it!"
        doneLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 150)
        doneLabel.adjustsFontSizeToFitWidth = true
        doneLabel.textAlignment = .Center
        finishView.addSubview(doneLabel)
        
        let infoLabel = UILabel()
        infoLabel.frame = CGRect(x: finishView.frame.width / 2 - 150, y: 175, width: 300, height: 175)
        infoLabel.text = "Pretty simple, right?"
        infoLabel.textColor = UIColor.darkGrayColor()
        infoLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 100)
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textAlignment = .Center
        infoLabel.alpha = 0.0
        finishView.addSubview(infoLabel)
        
        let button = UIButton()
        button.frame = CGRect(x: finishView.frame.width / 2 - 150, y: 325, width: 300, height: 50)
        button.setTitle("Done", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.addTarget(self, action: "closeWindow", forControlEvents: .TouchUpInside)
        button.alpha = 0.0
        finishView.addSubview(button)
        
        UIView.animateWithDuration(0.3, delay: 1.0, options: nil, animations: {
            infoLabel.alpha = 1.0
        }, completion: nil)
        
        UIView.animateWithDuration(0.4, delay: 1.0, options: nil, animations: {
            button.alpha = 1.0
        }, completion: nil)
        

        view.addSubview(finishView)
        animateNewProblem(finishView)
    }
    
    func closeWindow() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        if isTransitioning {
            return
        }
        let answerIsCorrect = currentProblem!.answerIsCorrect((answerField?.text)!)
        if answerIsCorrect {
            correct++
        }
        completedProblems++
        isTransitioning = true
        UIView.animateKeyframesWithDuration(1.0, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.7, animations: {
                self.view.backgroundColor = (answerIsCorrect ? UIColor.greenColor() : UIColor.redColor())
            })
            UIView.addKeyframeWithRelativeStartTime(0.7, relativeDuration: 0.3, animations: {
                self.view.backgroundColor = UIColor.grayColor()
            })
            }, completion: { animated in
                if self.completedProblems >= 3 {
                    self.finish()
                } else {
                    self.showNextProblem(UIView(), forProblem: self.getNewProblem())
                }
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

