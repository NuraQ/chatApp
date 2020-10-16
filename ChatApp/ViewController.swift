//
//  ViewController.swift
//  ChatApp
//
//  Created by Asal 3 on 16/10/2020.
//  Copyright © 2020 Asal 3. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource  {
  
    static var textMessages:[String] = []
    var currentMsg:String? = nil
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.textMessages.count
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
         //   textFeild.addTarget(self, action: #selector(textFieldEditingDidChange), for: UIControl.Event.editingChanged)
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: tableView.bounds.size.width - 8.0)

        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(
                          withIdentifier: "TableViewCustomeCellTableViewCell"
                          ) as? TableViewCustomeCellTableViewCell ?? Bundle.main.loadNibNamed("TableViewCustomeCellTableViewCell", owner: self,
                                  options: nil)?.first as! TableViewCustomeCellTableViewCell
                cell.customeLabel?.text = ViewController.textMessages[indexPath.row]
       // cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
     

                          cell.customeImage?.image  = #imageLiteral(resourceName: "nature")

                        return cell
    }
  //        return ViewController.textMessages.count

    func textFieldDidChangeNotification(_ textField: UITextField) {
        
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
        tableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: false)

        tableView.reloadData()
        
    }
   @objc  func textFieldEditingDidChange(){
        currentMsg = textFeild.text ?? nil
    }
 func textFieldDidEndEditing(_ textField: UITextField) {
     //...This function is called EVERY time editing is finished in myTestField
 }
    @objc func textFieldDidChange(_ textField: UITextField) {
        currentMsg = textFeild.text ?? nil
        print("curr msg \(String(describing: currentMsg))")

    }
    
}

