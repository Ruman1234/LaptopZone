//
//  GiveOfferScreenViewController.swift
//  SnapToSell
//
//  Created by Apple on 10/9/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SVProgressHUD

class GiveOfferScreenViewController: UIViewController , UITableViewDataSource,UITableViewDelegate {
   
    

    @IBOutlet weak var continuewBtn: UIButton!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var yes_no = [Int]()
    var id = String()
    var price = String()
    var questions = [Buy_Sell_Questions]()
    var answer = [QuestionsModel]()
    var calculatedAmount = Int()
    var answerIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBG()
       
        priceLbl.text = Double(price)?.dollarString
        callApi(id: Constants.productName)
        
        self.calculatedAmount = Int(self.price)!
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
            self.addPAger(totalPage: 7, currentPage: 6)
                   self.cancleBtn()
                   self.backBtn()
                   self.continuewBtn.applyGradient(colours: [UIColor(red: 0.99, green: 0.17, blue: 0.03, alpha: 1) , UIColor(red: 1, green: 0.49, blue: 0, alpha: 1)], locations: nil, startPoint: CGPoint(x: 0.25, y: 0.5), endPoint: CGPoint(x: 0.75, y: 0.5))
       }
     
    func callApi(id : String)  {
         SVProgressHUD.show(withStatus: "Loading...")
         NetworkManager.SharedInstance.getQuestions(Id: id, success: { (res) in
           
            SVProgressHUD.dismiss()
            
            
            self.questions = res
            
            for i in res {
                for j in i.answers!{
                    
                    if (j.IS_DEFAULT != nil) {
                        self.yes_no.append(0)
                        self.answerIdArray.append(j.ID!)
                    }
                }
            }
            
//            guard let arr = res else{
//                 return
//             }
            
//            guard let arrAns = res.AnswerArray else{
//                return
//            }
//            self.answer = arrAns
//            print(arr)
////            let grades = [8, 9, 10, 1, 2, 5, 3, 4, 8, 8]
////            let goodGrades = grades.all(where: { $0 > 7 })
////            print(goodGrades)
//            // Output: [8, 9, 10, 8, 8]
//
//            for val in arrAns{
//
//                if (val.DEFAULT_VAL != nil){
//                    self.yes_no.append(Int(val.DEFAULT_VAL!)!)
//                }else{
//                    self.yes_no.append(0)
//                }
//            }
//             self.questions = arr

            self.tableView.reloadData()
         }) { (err) in
             SVProgressHUD.dismiss()
             Utilites.ShowAlert(title: "Error!!!", message: "Something went wrong", view: self)
         }
    }


    
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = questions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OffertableViewCell", for: indexPath) as! OffertableViewCell
        if indexPath.row == 0 {
            if data.answers?.count == 4{
                cell.flawLess.isHidden = false
                cell.brokenBtn.isHidden = false

                cell.yesBtn.setTitle("Flawless", for: .normal)
                cell.noBtn.setTitle("Good", for: .normal)
                cell.flawLess.setTitle("Fair", for: .normal)
                cell.brokenBtn.setTitle("Broken", for: .normal)

            }
            
            
           if self.yes_no[indexPath.row] == 0 {
               if #available(iOS 13.0, *) {
                   cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                   cell.yesBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)

                cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
                cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)

               } else {
                   // Fallback on earlier versions
               }
            }else if self.yes_no[indexPath.row] == 1 {
               if #available(iOS 13.0, *) {
                   cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                   cell.noBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
                cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
                cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)

               } else {
                   // Fallback on earlier versions
               }
            }else if self.yes_no[indexPath.row] == 3 {
               if #available(iOS 13.0, *) {
                   cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                   cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                cell.flawLess.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
                cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)

               } else {
                   // Fallback on earlier versions
               }
            }else if self.yes_no[indexPath.row] == 4 {
               if #available(iOS 13.0, *) {
                   cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                   cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
                cell.brokenBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)

               } else {
                   // Fallback on earlier versions
               }
            }else{

                if #available(iOS 13.0, *) {
                    cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }

            }
            

        }else{
            cell.flawLess.isHidden = true
            cell.brokenBtn.isHidden = true
            
            cell.yesBtn.setTitle("Yes", for: .normal)
            cell.noBtn.setTitle("No", for: .normal)


            if self.yes_no[indexPath.row] == 0 {
                if #available(iOS 13.0, *) {
                    cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.yesBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }
            }else if self.yes_no[indexPath.row] == 1 {
                if #available(iOS 13.0, *) {
                    cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.noBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }
            }else{

                if #available(iOS 13.0, *) {
                    cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)
                    cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }

            }

        }
//        if indexPath.row == 0 {
//            cell.yesBtn.setTitle("Flawless", for: .normal)
//            cell.noBtn.setTitle("Good", for: .normal)
//            cell.flawLess.setTitle("Fair", for: .normal)
//            cell.brokenBtn.setTitle("Broken", for: .normal)
//
//        if self.yes_no[indexPath.row] == 0 {
//           if #available(iOS 13.0, *) {
//               cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//               cell.yesBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
//
//            cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
//            cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//
//           } else {
//               // Fallback on earlier versions
//           }
//        }else if self.yes_no[indexPath.row] == 1 {
//           if #available(iOS 13.0, *) {
//               cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//               cell.noBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
//            cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
//            cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//
//           } else {
//               // Fallback on earlier versions
//           }
//        }else if self.yes_no[indexPath.row] == 3 {
//           if #available(iOS 13.0, *) {
//               cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//               cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//            cell.flawLess.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
//            cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//
//           } else {
//               // Fallback on earlier versions
//           }
//        }else if self.yes_no[indexPath.row] == 4 {
//           if #available(iOS 13.0, *) {
//               cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//               cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//            cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
//            cell.brokenBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
//
//           } else {
//               // Fallback on earlier versions
//           }
//        }else{
//
//            if #available(iOS 13.0, *) {
//                cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//                cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//                cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//                cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
//            } else {
//                // Fallback on earlier versions
//            }
//
//        }
//
//            cell.flawLess.isHidden = false
//            cell.brokenBtn.isHidden = false
//        }else{
//
//            cell.yesBtn.setTitle("Yes", for: .normal)
//            cell.noBtn.setTitle("No", for: .normal)
//
//            cell.flawLess.isHidden = true
//            cell.brokenBtn.isHidden = true
//
//
//            if self.yes_no[indexPath.row] == 0 {
//                if #available(iOS 13.0, *) {
//                    cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//                    cell.yesBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
//                } else {
//                    // Fallback on earlier versions
//                }
//            }else if self.yes_no[indexPath.row] == 1 {
//                if #available(iOS 13.0, *) {
//                    cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//                    cell.noBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
//                } else {
//                    // Fallback on earlier versions
//                }
//            }else{
//
//                if #available(iOS 13.0, *) {
//                    cell.yesBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//                    cell.noBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//                    cell.brokenBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//                    cell.flawLess.setImage(UIImage(systemName: "circle"), for: .normal)
//                } else {
//                    // Fallback on earlier versions
//                }
//
//            }
//
//
//        }
//
        
        cell.question.text = self.questions[indexPath.row].DESCRIPTION
        cell.yesBtn.tag = indexPath.row
        cell.noBtn.tag = indexPath.row
        cell.flawLess.tag = indexPath.row
        cell.brokenBtn.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 131
        }else{
            return 96
        }
        
    }
    
    
//self.yes_no[sender.tag] = 0 yes || Flawless
//self.yes_no[sender.tag] = 1 no || Good
//self.yes_no[sender.tag] = 3 Fair
//self.yes_no[sender.tag] = 4 broken
    
    
    @IBAction func yesBtn(_ sender: AnyObject) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedCell = tableView.cellForRow(at: indexPath) as! OffertableViewCell

        // here is the text of the label
        let string = selectedCell.yesBtn.titleLabel?.text
        
        if sender.tag == 0 {
            
             var amt = Int()
                    
            if self.yes_no[sender.tag] == 1{
    //            amt = Int(self.questions[indexPath.row].answers![2].EFFECTIVE_VALUE!)!
                
                //self.yes_no[sender.tag] = 0 yes || Flawless
                //self.yes_no[sender.tag] = 1 no || Good
                //self.yes_no[sender.tag] = 3 Fair
                //self.yes_no[sender.tag] = 4 broken
                amt = Int(self.questions[indexPath.row].answers![1].EFFECTIVE_VALUE!)!
            }else if self.yes_no[sender.tag] == 3{
                amt = Int(self.questions[indexPath.row].answers![0].EFFECTIVE_VALUE!)!
            }else if self.yes_no[sender.tag] == 4{
                amt = Int(self.questions[indexPath.row].answers![3].EFFECTIVE_VALUE!)!
            }
            
            if self.yes_no[sender.tag] != 0 {
            for val in self.questions[indexPath.row].answers!{
                   if string == val.DESCRIPTION{
        //                   if (val.IS_DEFAULT != nil) {
        //                       self.calculatedAmount = self.calculatedAmount + Int(val.EFFECTIVE_VALUE!)!
        //                   }else{
                    
                    self.answerIdArray[sender.tag] = val.ID!
    //                    self.answerIdArray[indexPath.row] = val.ID!
    //                    self.answerIdArray.insert(val.ID!, at: indexPath.row)
                    self.calculatedAmount = self.calculatedAmount + amt
                    
//                    self.calculatedAmount = self.calculatedAmount - Int(val.EFFECTIVE_VALUE!)!

                    
    //                           self.calculatedAmount =  self.calculatedAmount - Int(val.EFFECTIVE_VALUE!)!
        //                   }
                   }
               }
            }
            
        }else{
            if self.yes_no[sender.tag] != 0  {
                for val in self.questions[indexPath.row].answers!{
                    if string == val.DESCRIPTION{
    //                    if (val.IS_DEFAULT != nil) {
                        
    //                    self.answerIdArray[indexPath.row] = val.ID!
    //                        self.calculatedAmount = self.calculatedAmount + Int(val.EFFECTIVE_VALUE!)!
    //                    }else{
    //                        self.calculatedAmount = Int(self.price)! - Int(val.EFFECTIVE_VALUE!)!
    //                    }
                    }else{
                        self.calculatedAmount = self.calculatedAmount + Int(val.EFFECTIVE_VALUE!)!
                        self.answerIdArray[sender.tag] = val.ID!
                    }
                }
            }
        }
        
        if self.calculatedAmount < 1{
            self.priceLbl.text = Double(0).dollarString
            Utilites.ShowAlert(title: "Alert!!!", message: "We dont want to buy this item", view: self)
        }else{

            let str = String(self.calculatedAmount)
            
            self.priceLbl.text = Double(str)?.dollarString
            
        }
        

        self.yes_no[sender.tag] = 0
        tableView.reloadData()

        print(self.yes_no)
    }
    
    
    
    @IBAction func nobtn(_ sender: AnyObject) {
        
        
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedCell = tableView.cellForRow(at: indexPath) as! OffertableViewCell

        // here is the text of the label
        let string = selectedCell.noBtn.titleLabel?.text
        
        if sender.tag == 0 {
            
             var amt = Int()
                    
            if self.yes_no[sender.tag] == 0{
    //            amt = Int(self.questions[indexPath.row].answers![2].EFFECTIVE_VALUE!)!
                
                //self.yes_no[sender.tag] = 0 yes || Flawless
                //self.yes_no[sender.tag] = 1 no || Good
                //self.yes_no[sender.tag] = 3 Fair
                //self.yes_no[sender.tag] = 4 broken

            }else if self.yes_no[sender.tag] == 3{
                amt = Int(self.questions[indexPath.row].answers![0].EFFECTIVE_VALUE!)!
            }else if self.yes_no[sender.tag] == 4{
                amt = Int(self.questions[indexPath.row].answers![3].EFFECTIVE_VALUE!)!
            }
            
            if self.yes_no[sender.tag] != 1 {
            for val in self.questions[indexPath.row].answers!{
                   if string == val.DESCRIPTION{
        //                   if (val.IS_DEFAULT != nil) {
        //                       self.calculatedAmount = self.calculatedAmount + Int(val.EFFECTIVE_VALUE!)!
        //                   }else{
                    
                    self.answerIdArray[sender.tag] = val.ID!
//                    self.answerIdArray[indexPath.row] = val.ID!
//                    self.answerIdArray.insert(val.ID!, at: indexPath.row)
                    self.calculatedAmount = self.calculatedAmount + amt
                    
                    self.calculatedAmount = self.calculatedAmount - Int(val.EFFECTIVE_VALUE!)!

                    
//                           self.calculatedAmount =  self.calculatedAmount - Int(val.EFFECTIVE_VALUE!)!
        //                   }
                   }
               }
            }
            
        }else{
            if self.yes_no[sender.tag] != 1 {
               for val in self.questions[indexPath.row].answers!{
                   if string == val.DESCRIPTION{
    //                   if (val.IS_DEFAULT != nil) {
    //                       self.calculatedAmount = self.calculatedAmount + Int(val.EFFECTIVE_VALUE!)!
    //                   }else{
                    self.answerIdArray[sender.tag] = val.ID!
//                    self.answerIdArray[indexPath.row] = val.ID!
//                    self.answerIdArray.insert(val.ID!, at: indexPath.row)
                           self.calculatedAmount =  self.calculatedAmount - Int(val.EFFECTIVE_VALUE!)!
    //                   }
                   }
               }
            }
        }
        
        
        if self.calculatedAmount < 1{
            self.priceLbl.text = Double(0).dollarString
            Utilites.ShowAlert(title: "Alert!!!", message: "We dont want to buy this item", view: self)
        }else{

           let str = String(self.calculatedAmount)
           
           self.priceLbl.text = Double(str)?.dollarString
           
        }
//        let str = String(self.calculatedAmount)
//
//        self.priceLbl.text = Double(str)?.dollarString
        self.yes_no[sender.tag] = 1
        tableView.reloadData()
    }
    
    
    @IBAction func flawless(_ sender: AnyObject) {
         
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedCell = tableView.cellForRow(at: indexPath) as! OffertableViewCell

        // here is the text of the label
        let string = selectedCell.flawLess.titleLabel?.text
        
        var amt = Int()
            
        //self.yes_no[sender.tag] = 0 yes || Flawless
        //self.yes_no[sender.tag] = 1 no || Good
        //self.yes_no[sender.tag] = 3 Fair
        //self.yes_no[sender.tag] = 4 broken

        if self.yes_no[sender.tag] == 1{
            amt = Int(self.questions[indexPath.row].answers![1].EFFECTIVE_VALUE!)!
        }else if self.yes_no[sender.tag] == 1{
//            amt = Int(self.questions[indexPath.row].answers![2].EFFECTIVE_VALUE!)!
        }else if self.yes_no[sender.tag] == 4{
            amt = Int(self.questions[indexPath.row].answers![3].EFFECTIVE_VALUE!)!
        }

        if self.yes_no[sender.tag] != 3 {
           for val in self.questions[indexPath.row].answers!{
               if string == val.DESCRIPTION{
        //                   if (val.IS_DEFAULT != nil) {
        //                       self.calculatedAmount = self.calculatedAmount + Int(val.EFFECTIVE_VALUE!)!
        //                   }else{
                let dif = Int(self.price)! - self.calculatedAmount
                print(dif)
                print(self.calculatedAmount)
                
                self.calculatedAmount = self.calculatedAmount + amt
                 self.answerIdArray[sender.tag] = val.ID!
//                self.answerIdArray[indexPath.row] = val.ID!
//                self.answerIdArray.insert(val.ID!, at: indexPath.row)
                self.calculatedAmount = self.calculatedAmount - Int(val.EFFECTIVE_VALUE!)!
                print(self.calculatedAmount)
        //                   }
               }
           }
        }
        
        if self.calculatedAmount < 1{
           self.priceLbl.text = Double(0).dollarString
           Utilites.ShowAlert(title: "Alert!!!", message: "We dont want to buy this item", view: self)
        }else{

          let str = String(self.calculatedAmount)
          
          self.priceLbl.text = Double(str)?.dollarString
          
        }
//        let str = String(self.calculatedAmount)
        
//        self.priceLbl.text = Double(str)?.dollarString
        
        self.yes_no[sender.tag] = 3
        tableView.reloadData()
        
    }
    
    @IBAction func broken(_ sender: AnyObject) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let selectedCell = tableView.cellForRow(at: indexPath) as! OffertableViewCell

        // here is the text of the label
        let string = selectedCell.brokenBtn.titleLabel?.text
        var amt = Int()
        if self.yes_no[sender.tag] == 0{
//            amt = Int(self.questions[indexPath.row].answers![2].EFFECTIVE_VALUE!)!
            
        //            for val in self.questions[indexPath.row].answers!{
        //                amt = Int(val.EFFECTIVE_VALUE!)!
        //            }
            
            //self.yes_no[sender.tag] = 0 yes || Flawless
            //self.yes_no[sender.tag] = 1 no || Good
            //self.yes_no[sender.tag] = 3 Fair
            //self.yes_no[sender.tag] = 4 broken

        }else if self.yes_no[sender.tag] == 1{
            amt = Int(self.questions[indexPath.row].answers![1].EFFECTIVE_VALUE!)!
        }else if self.yes_no[sender.tag] == 0{
            amt = Int(self.questions[indexPath.row].answers![2].EFFECTIVE_VALUE!)!
        }

        if self.yes_no[sender.tag] != 4 {
           for val in self.questions[indexPath.row].answers!{
            
               if string == val.DESCRIPTION{
        //                   if (val.IS_DEFAULT != nil) {
        //                       self.calculatedAmount = self.calculatedAmount + Int(val.EFFECTIVE_VALUE!)!
        //                   }else{
                print(self.calculatedAmount)
                self.calculatedAmount = self.calculatedAmount + amt
                print(self.calculatedAmount)
//                               let dif = Int(self.price)! - self.calculatedAmount
//                                             print(dif)
                 self.answerIdArray[sender.tag] = val.ID!
//                self.answerIdArray[indexPath.row] = val.ID!
//                self.answerIdArray.insert(val.ID!, at: indexPath.row)
                self.calculatedAmount = self.calculatedAmount - Int(val.EFFECTIVE_VALUE!)!
                print(self.calculatedAmount)
        //                   }
               }
           }
        }
        
        if self.calculatedAmount < 1{
           self.priceLbl.text = Double(0).dollarString
           Utilites.ShowAlert(title: "Alert!!!", message: "We dont want to buy this item", view: self)
        }else{

          let str = String(self.calculatedAmount)
          
          self.priceLbl.text = Double(str)?.dollarString
          
        }
//        let str = String(self.calculatedAmount)
        
//        self.priceLbl.text = Double(str)?.dollarString
        self.yes_no[sender.tag] = 4
        tableView.reloadData()
    }
    
    
    
    @IBAction func getOffer(_ sender: Any) {
        
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "SelectPaymentMethodViewController") as! SelectPaymentMethodViewController
        Constants.gevin_offer = price
        Constants.available_offer = "\(self.calculatedAmount)"
        Constants.answer_ids = self.answerIdArray.joined(separator: ",")
        self.navigationController?.pushViewController(main, animated: true)
                  
        
    }
    
    
    
    
    
}
