//
//  ViewController.swift
//  ChatApp
//
//  Created by Asal 3 on 16/10/2020.
//  Copyright © 2020 Asal 3. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ObservableObject,UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource  {
  
    static var textMessages:[String] = []
    var currentMsg:String? = nil

    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textfieldBottomConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onKeyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
           
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.textMessages.count
    }
  
    @IBOutlet weak var tableView: UITableView! {
        didSet {
          tableView.delegate = self
            tableView.dataSource = self
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: tableView.bounds.size.width - 8.0)

        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         let cell = tableView.dequeueReusableCell(
                          withIdentifier: "TableViewCustomeCellTableViewCell"
                          ) as? TableViewCustomeCellTableViewCell ?? Bundle.main.loadNibNamed("TableViewCustomeCellTableViewCell", owner: self,
                                  options: nil)?.first as! TableViewCustomeCellTableViewCell
                cell.customeLabel?.text = ViewController.textMessages[indexPath.row]
                cell.customeImage?.image  = #imageLiteral(resourceName: "nature")

                return cell
    }

    @IBOutlet weak var textFeild: UITextField!{
        didSet {
            textFeild.delegate = self
            textFeild.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)

        }
    }
    
    @IBAction func sendMesssage(_ sender: Any) {
        if let currentMessage = currentMsg  {
          ViewController.textMessages += [currentMessage]
            print("curr msg in send \(String(describing: currentMsg))")
            currentMsg = nil
        }
        scrollToBottom()
        tableView.reloadData()
        
    }
    
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: ViewController.textMessages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        currentMsg = textFeild.text ?? nil

    }

    @objc func keyboardWillShow (notification: NSNotification) {
        
     let key = UIResponder.keyboardFrameEndUserInfoKey
     guard let keyboardFrame = notification.userInfo?[key] as? CGRect else {
       return
     }

        let safeAreaBottom = view.safeAreaLayoutGuide.layoutFrame.maxY
        let viewHeight = view.bounds.height
        let safeAreaOffset = viewHeight - safeAreaBottom

       UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
        self.bottomConstraint.constant = keyboardFrame.height - self.textfieldBottomConstraint.constant  - safeAreaOffset  ;
        self.view.layoutIfNeeded()

       }, completion: nil)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom:safeAreaOffset , right: 0)
                     tableView.contentInset = insets
                     tableView.scrollIndicatorInsets = insets
    }
   
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
       let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        self.view.frame.origin.y = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.bottomConstraint.constant = 0
         self.view.layoutIfNeeded()

        }, completion: nil)
        view.endEditing(true)
    }
    
    
}

extension ViewController {
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
    }
}

