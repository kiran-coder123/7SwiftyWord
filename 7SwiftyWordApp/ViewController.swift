//
//  ViewController.swift
//  7SwiftyWordApp
//
//  Created by Satinder Panesar on 5/13/21.
//

import UIKit

class ViewController: UIViewController {
    var lblClues: UILabel!
    var lblAnswers: UILabel!
    var currentAnswer: UITextField!
    var lblScore: UILabel!
    var btnLetters = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet{
            lblScore.text = "Score \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
         
        // Score Label
        lblScore = UILabel()
        lblScore.translatesAutoresizingMaskIntoConstraints = false
        lblScore.textAlignment = .right
        lblScore.text = "Score:0"
        view.addSubview(lblScore)
          
        // Clues Label
        lblClues = UILabel()
        lblClues.translatesAutoresizingMaskIntoConstraints = false
        lblClues.font = UIFont.systemFont(ofSize: 24)
        lblClues.text = "CLUES"
        lblClues.numberOfLines = 0
        lblClues.setContentHuggingPriority(UILayoutPriority (1), for: .vertical)
        view.addSubview(lblClues)
        
        // Answer Label
        lblAnswers = UILabel()
        lblAnswers.translatesAutoresizingMaskIntoConstraints = false
        lblAnswers.font = UIFont.systemFont(ofSize: 24)
        lblAnswers.text = "ANSWERS"
        lblAnswers.textAlignment = .right
        lblAnswers.numberOfLines = 0
        lblAnswers.setContentHuggingPriority(UILayoutPriority (1), for: .vertical)
        view.addSubview(lblAnswers)
        
        // current Answer
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letter to Guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        
        // Submit Button
        
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        // Clear Button
        let clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.addTarget(self, action: #selector(clearTappad), for: .touchUpInside)
        view.addSubview(clearButton)
        
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        
        
        
        
        NSLayoutConstraint.activate([
            lblScore.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            lblScore.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            lblClues.topAnchor.constraint(equalTo: lblScore.bottomAnchor),
            lblClues.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            lblClues.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6,constant: -100),
            lblAnswers.topAnchor.constraint(equalTo: lblScore.bottomAnchor),
            lblAnswers.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            lblAnswers.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4,constant: -100),
            lblAnswers.heightAnchor.constraint(equalTo: lblClues.heightAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: lblClues.bottomAnchor, constant: 20),
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:-100),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            
            buttonView.widthAnchor.constraint(equalToConstant: 750),
            buttonView.heightAnchor.constraint(equalToConstant: 320),
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
         let width = 150
        let height = 80
        
        for row in 0..<4{
            for colum in 0..<5{
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTappad(_:)), for: .touchUpInside)
                
                let frame = CGRect(x: Int(CGFloat(colum * width)), y: Int(CGFloat(row * height)), width: width, height: height)
                letterButton.frame = frame
                buttonView.addSubview(letterButton)
                 btnLetters.append(letterButton)
            }
        }
     }
    override func viewDidLoad() {
        super.viewDidLoad()
         loadLevel()
    }
    @objc func letterTappad(_ sender: UIButton){
        
        guard let buttonTitle = sender.titleLabel?.text else { return }
           currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
           activatedButtons.append(sender)
           sender.isHidden = true
        
    }
    @objc func submitTapped(_ sender: UIButton){
        guard let answerText = currentAnswer.text else { return }

           if let solutionPosition = solutions.firstIndex(of: answerText) {
               activatedButtons.removeAll()

               var splitAnswers = lblAnswers.text?.components(separatedBy: "\n")
               splitAnswers?[solutionPosition] = answerText
               lblAnswers.text = splitAnswers?.joined(separator: "\n")

               currentAnswer.text = ""
               score += 1

               if score % 7 == 0 {
                   let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                   ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                   present(ac, animated: true)
               }
           }
        
    }
    @objc func clearTappad(_ sender: UIButton){
        currentAnswer.text = ""

           for btn in activatedButtons {
               btn.isHidden = false
           }

           activatedButtons.removeAll()
    }
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in btnLetters {
            btn.isHidden = false
        }
    }
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let  levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index,line) in lines.enumerated(){
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    
                    let soultionWords = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(soultionWords.count) letters\n"
                    solutions.append(soultionWords)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
                
                
            }
        }
        lblClues.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        lblAnswers.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        btnLetters.shuffle()
        
        if btnLetters.count == letterBits.count{
            for i in 0..<btnLetters.count{
                btnLetters[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    

}

