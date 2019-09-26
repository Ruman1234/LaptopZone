//
//  HomeViewController.swift
//  PictureApp
//
//  Created by Apple on 6/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import DropDown
import SkyFloatingLabelTextField
import Speech
import AssetsLibrary
import Photos
import Firebase
import FirebaseCore
import FirebaseFirestore
import CoreData
import ReachabilitySwift

class HomeViewController: UIViewController, UITextFieldDelegate , UICollectionViewDelegate , UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate ,SFSpeechRecognizerDelegate , PreviewViewControllerDelegate{
    

    
    @IBOutlet weak var conditionBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var barcodeCollectionView: UICollectionView!
    @IBOutlet weak var resetBin: UIButton!
    @IBOutlet weak var scanBin: UIButton!
    @IBOutlet weak var scabBarcodeBtn: UIButton!
    @IBOutlet weak var takePic: UIButton!
    @IBOutlet var sideMenu: UIBarButtonItem!
    @IBOutlet weak var condition: DropDown!
    @IBOutlet weak var upcBarcodesTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var binBArcodeTextFiels: SkyFloatingLabelTextField!
    @IBOutlet weak var MPNTextFiels: SkyFloatingLabelTextField!
    @IBOutlet weak var VoiceBtn: UIButton!
    @IBOutlet weak var mickImg: UIImageView!
    
    @IBOutlet weak var remarkBtn: UIButton!
    
    @IBOutlet weak var condRemarkBtn: UIButton!
    
    let dropDown = DropDown()
    var barcode = [String]()
    var pictures = [UIImage]()
    var imagePicker: UIImagePickerController!
    var upcBArcode = [String]()
    var binBarcode = ""
    var MPNBarcode = ""
    
    let fileManager = FileManager.default
    var refArtists: DatabaseReference!
    let storage = Storage.storage()
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var conditin_Id = ""
    
    var conditionArray = [Results]()
    var voiceToText = String()
    
    var remarks = String()
    var cond_Remark = String()
    var conditionFormDB: [NSManagedObject] = []
    var history: [NSManagedObject] = []
    var documentUpdate = Bool()
    
    var documentUpdateDAta: [String: Any] = [:]

    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var speechResult = SFSpeechRecognitionResult()
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.conditionArray)
        if Utilites.isInternetAvailable(){
            self.fetchAndPrintEachBarcode()
        }
        
        
        
        let userdefaults = UserDefaults.standard
        let username = userdefaults.value(forKey: "username")
        let id = userdefaults.value(forKey: "id")
        Constants.Pic_Taker_Id = id as! String
        Constants.USERNAME = username as! String
        
        
        self.getFormDB()
        print(self.conditionArray)
        self.remarkBtn.isHidden = true
        self.condRemarkBtn.isHidden = true
        
        self.sideMenu.target = self.revealViewController()
        self.sideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.hideKeyboardWhenTappedAround() 

        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        
        self.btnDesign(btn:resetBin )
        self.btnDesign(btn:scanBin )
        self.btnDesign(btn:scabBarcodeBtn )
        self.btnDesign(btn:takePic )
        self.takePic.isUserInteractionEnabled = false
        self.takePic.backgroundColor = UIColor.lightGray
        self.takePic.isEnabled = false
        
        if Utilites.isInternetAvailable(){
            conditions()
        }else{
            self.showToast(message: "internet not availble")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: NSNotification.Name(rawValue: "reachabilityChanged"), object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.currentReachabilityStatus {
        case .reachableViaWiFi:
            print("Reachable via WiFi")
        case .reachableViaWWAN:
            print("Reachable via Cellular")
        case .notReachable:
            print("Network not reachable")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var upc = String()
        
        
        
        reachability.whenReachable = { reachability in
            self.fetchAndPrintEachBarcode()
            print("reachable")
            if reachability.isReachable {
                print("Reachable via WiFi")
            }else{
                print("Not reachable")
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        for b in Constants.UPCBarcode{
            if b == "" {
                upc = b
            }else{
                upc = upc + "," + b
            }
            
            upc = b
        }
        
        
        self.binBArcodeTextFiels.text = self.binBarcode
        self.MPNTextFiels.text = self.MPNBarcode
        self.barcode = Constants.barcodes
        self.upcBarcodesTextField.text = upc
        self.barcodeCollectionView.reloadData()
        self.collectionView.reloadData()
        
        if self.barcode.count > 0 {
            self.takePic.isUserInteractionEnabled = true
            self.takePic.backgroundColor = Constants.APP_THEAME_COLOR
            self.takePic.isEnabled = true
        }
        if self.pictures.count >= 12{
            self.takePic.isUserInteractionEnabled = false
            self.takePic.backgroundColor = UIColor.lightGray
            self.takePic.isEnabled = false
        }
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // The callback may not be called on the main thread. Add an
            // operation to the main queue to update the record button's state.
            OperationQueue.main.addOperation {
                var alertTitle = ""
                var alertMsg = ""
                
                switch authStatus {
                case .authorized:
                    print("authorized")
//                    do {
//
//                    } catch {
//                        alertTitle = "Recorder Error"
//                        alertMsg = "There was a problem starting the speech recorder"
//                    }
                    
                case .denied:
                    alertTitle = "Speech recognizer not allowed"
                    alertMsg = "You enable the recgnizer in Settings"
                    
                case .restricted, .notDetermined:
                    alertTitle = "Could not start the speech recognizer"
                    alertMsg = "Check your internect connection and try again"
                    
                default: break
                }
                if alertTitle != "" {
                    let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        
        if self.documentUpdate{
            self.documentUpdate = false
            if (self.documentUpdateDAta.index(forKey: "sync_status") != nil){
                for (key, value) in self.documentUpdateDAta {
                    print("\(key) -> \(value)")
                    
                    
                    if key == "condition"{
                        self.conditionBtn.setTitle(value as? String, for: .normal)
                    }
                    if key == "mpn"{
                        self.MPNTextFiels.text = value as? String
                    }
                    if key == "upc"{
                        self.upcBarcodesTextField.text = value as? String
                    }
                    if key == "barcode"{
                        print(value.self)
                        self.barcode.append((value.self as? String)!)
                    }
                    if key == "remarks"{
                        if let val = value as? String {
                            if val != "" {
                                self.remarks = val
                                self.remarkBtn.isHidden = false
                            }
                        }
                    }
                    if key == "cond_remarks"{
                        if let val = value as? String {
                            if val != "" {
                                self.cond_Remark = val
                                self.condRemarkBtn.isHidden = false

                            }
                        }
                    }
                    
                    print(self.documentUpdateDAta)
                    
                    self.barcodeCollectionView.reloadData()
                }
            }
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.binBArcodeTextFiels{
            self.binBarcode = self.binBArcodeTextFiels.text!
        }else if textField == self.MPNTextFiels{
            self.MPNBarcode = self.MPNTextFiels.text!
        }
    }
    
    func saveToDB(name: String , id :String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Conditions",
                                       in: managedContext)!
        
        let condNAme = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        condNAme.setValue(name, forKeyPath: "name")
        condNAme.setValue(id, forKey: "id")
        do {
            try managedContext.save()
            conditionFormDB.append(condNAme)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func isEntityAttributeExist(id: String , entityName: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        let res = try! managedContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    func deleteAllData(EntityNAme : String)
    {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: EntityNAme)
        
        //3
        do {
            conditionFormDB = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        for cond in conditionFormDB {
            
            managedContext.delete(cond)
            
        }
    }
    
    func getFormDB()  {
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Conditions")
        
        //3
        do {
            conditionFormDB = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        print(conditionFormDB)

        var i = 0

        for _ in conditionFormDB {
            
//            conditionFormDB[0].setValue("ruman", forKey: "name")
            
            self.conditionArray.append(Results(JSON: [
                "COND_NAME" : conditionFormDB[i].value(forKey: "name") as? String?,
                "ID" : conditionFormDB[i].value(forKey: "id") as? String?])!)
            i += 1
            
            
        }
        
        for arr in self.conditionArray{
            
           
            self.conditionName.append(arr.cOND_NAME!)
            self.cond_id.append(arr.iD!)
            
//            self.saveToDB(zaqw    azAname: arr.cOND_NAME!, id: arr.iD!)
            
        }
        
        self.dropDown.anchorView = self.view
        self.dropDown.direction = .bottom
        
        self.dropDown.dataSource = self.conditionName
        
        self.dropDown.bottomOffset = CGPoint(x: 0, y: self.conditionBtn.frame.height + 100)
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.conditin_Id = self.cond_id[index]
            print("Selected item: \(item) at index: \(index)")
            self.conditionBtn.setTitle(item, for: .normal)
        }
        
        
    }
    
    var oldbounds:CGRect!
    
    @IBAction func longpress(_ sender: UIGestureRecognizer) {
        if sender.state == .ended{
//            let bounds = self.VoiceBtn.bounds
            self.mickImg.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.5) {
                self.mickImg.bounds = self.oldbounds
            }
           
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the
                print("UIGestureRecognizerStateEnd.")
                if self.audioEngine.isRunning {
                    self.stopRecording()
                    self.checkForActionPhrases()
                }
                
                let alert = UIAlertController(title: "Text", message: self.voiceToText, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Remarks", style: .default, handler: { (action) in
                    self.remarks = self.voiceToText
                    if self.remarks != ""{
                        self.remarkBtn.isHidden = false
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cond Remark", style: .default, handler: { (action) in
                    self.cond_Remark = self.voiceToText
                    if self.cond_Remark != "" {
                        self.condRemarkBtn.isHidden = false
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancle", style: .destructive, handler: { (action) in
                    
                }))
                
                self.present(alert, animated: true)
                
               
                
            }
            
        }else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            oldbounds = self.mickImg.bounds
            do{
                try startRecording()
            }catch{
                
            }
        }else if sender.state == .changed {
            UIView.animate(withDuration: 0.5, delay: 0, options: .repeat, animations: {
                 self.mickImg.bounds = CGRect(origin: self.mickImg.center, size: CGSize(width: 100, height: 100))
            }, completion: nil)
        }
    }
    
    var cond_id = [String]()
    var conditionName = [String]()
    
    func conditions()  {
        NetworkManager.SharedInstance.Conditions(success: { (response) in
            guard let array = response.results else{
                return
            }
            
            self.conditionArray = array
            
            for arr in self.conditionArray{
               
                if self.isEntityAttributeExist(id: arr.iD!, entityName: "Conditions"){
                    print("exist")
                }else{
                    print("not exist")
                    self.conditionName.append(arr.cOND_NAME!)
                    self.cond_id.append(arr.iD!)
                    self.saveToDB(name: arr.cOND_NAME!, id: arr.iD!)

                }
            }
            
            self.dropDown.anchorView = self.view
            self.dropDown.direction = .bottom
            
            self.dropDown.dataSource = self.conditionName
            
            self.dropDown.bottomOffset = CGPoint(x: 0, y: self.conditionBtn.frame.height + 100)
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.conditin_Id = self.cond_id[index]
                print("Selected item: \(item) at index: \(index)")
                self.conditionBtn.setTitle(item, for: .normal)
            }
            
        }) { (error) in
            self.showToast(message: error.debugDescription)
        }
    }
    
    private func startRecording() throws {
        if !audioEngine.isRunning {

//            self.VoiceBtn.setTitle("Stop", for: .normal)
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            let inputNode = audioEngine.inputNode

            guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create the recognition request") }
            
            recognitionRequest.shouldReportPartialResults = true

            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
                var isFinal = false
                
                if let result = result {
                    print("result: \(result.isFinal)")
                    isFinal = result.isFinal
                    
                    self.speechResult = result

                    print("final: " + result.bestTranscription.formattedString)
                    self.voiceToText = result.bestTranscription.formattedString
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
                
            }
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                self.recognitionRequest?.append(buffer)
            }
            
            print("Begin recording")
            audioEngine.prepare()
            try audioEngine.start()
            
        }
        
    }
    
    
    func transcripteAudioFile(audioFileURL: URL) {
        let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "audio", ofType: ".mp3")!)
        let request = SFSpeechURLRecognitionRequest(url: fileURL)
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
        
        
        let _ : SFSpeechRecognitionTask = recognizer.recognitionTask(with: request, resultHandler: { (result, error)   in
            if let error = error {
                print("There was an problem: \(error)")
            } else {
                print (result?.bestTranscription.formattedString as Any)
            }
        })
    }
    
    @objc func timerEnded() {
        // If the audio recording engine is running stop it and remove the SFSpeechRecognitionTask
        if audioEngine.isRunning {
            stopRecording()
            checkForActionPhrases()
        }
    }
    
    func remove(commands: [String], from recordedText: String) -> String {
        var tempText = recordedText
        
        // Search array of command strings and remove if found
        for command in commands {
            if let commandRange = tempText.lowercased().range(of: command) {
                // Find range from start of recorded text to the end of command found
                let range = Range.init(uncheckedBounds: (lower: tempText.startIndex, upper: commandRange.upperBound))
                // Remove the found range
                tempText.removeSubrange(range)
                print("Updated text: \(tempText)")
            }
        }
        
        return tempText
    }
    
    func stopRecording() {
//        self.VoiceBtn.setTitle("Start", for: .normal)
        audioEngine.stop()
        recognitionRequest?.endAudio()
        // Cancel the previous task if it's running
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        return false
    }
    
     
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print("Recognizer availability changed: \(available)")
        
        if !available {
            let alert = UIAlertController(title: "There was a problem accessing the recognizer", message: "Please try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func checkForActionPhrases() {
        //        var addNote = false
        //        var addReminder = false
        
        for segment in speechResult.bestTranscription.segments {
            // Don't search until the transcription size is at least
            // the size of the shortest phrase
            if segment.substringRange.location >= 5 {
                // Separate segments to single words
                let best = speechResult.bestTranscription.formattedString
                _ = best.index(best.startIndex, offsetBy: segment.substringRange.location)
            }
        }
    }
    
    
    func btnDesign(btn: UIButton)  {
        btn.layer.cornerRadius = 5
    }
    
    @IBAction func scanBarcode(_ sender: Any) {
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "BarCodeDetectorViewController") as! BarCodeDetectorViewController
        main.type = ""
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            return self.pictures.count
        }else{
            return self.barcode.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictrureCollectionViewCell", for: indexPath) as! PictrureCollectionViewCell
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            
            
            cell.imgView.addGestureRecognizer(tap)
            
            cell.imgView.isUserInteractionEnabled = true
            
//            cell.scrollView.minimumZoomScale = 1.0
//            cell.scrollView.maximumZoomScale = 6.0

            cell.imgView.image = self.pictures[indexPath.row]
            cell.cancleBtn.tag = indexPath.row
            return cell
        }else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictrureCollectionViewCell", for: indexPath) as! PictrureCollectionViewCell
            cell.barcodeLbl.text = self.barcode[indexPath.row]
            cell.cancleBtn.tag = indexPath.row
            return cell
        }
       
    }
    
    
    let newImageView = UIImageView()
   
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        secondVC.img = self.pictures
        secondVC.delegate = self
        self.present(secondVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancleBtn(_ sender: AnyObject) {
        self.remove(sender.tag)
        if self.pictures.count < 12{
            self.takePic.isUserInteractionEnabled = true
            self.takePic.backgroundColor = Constants.APP_THEAME_COLOR
            self.takePic.isEnabled = true
        }else{
            self.takePic.isUserInteractionEnabled = false
            self.takePic.backgroundColor = UIColor.lightGray
            self.takePic.isEnabled = false
        }
    }
    
    func remove(_ i: Int) {
        
        self.pictures.remove(at: i)
        
        let indexPath = IndexPath(row: i, section: 0)
        
        self.collectionView.performBatchUpdates({
            self.collectionView.deleteItems(at: [indexPath])
        }) { (finished) in
            self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
        }
        
    }
    
    
    func removeBarcode(_ i: Int) {
        
        self.barcode.remove(at: i)
        Constants.barcodes.remove(at: i)
        let indexPath = IndexPath(row: i, section: 0)
        
        self.barcodeCollectionView.performBatchUpdates({
            self.barcodeCollectionView.deleteItems(at: [indexPath])
        }) { (finished) in
            self.barcodeCollectionView.reloadItems(at: self.barcodeCollectionView.indexPathsForVisibleItems)
        }
        
    }
    
    @IBAction func takePicture(_ sender: Any) {
//
//        if audioEngine.isRunning {
//            stopRecording()
//            checkForActionPhrases()
//        }
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        self.navigationController?.pushViewController(main, animated: true)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        imagePicker.dismiss(animated: true, completion: nil)
//
//        self.pictures.append((info[.originalImage] as? UIImage)!)
//        self.collectionView.reloadData()
//    }
    
    
    @IBAction func conditionDropDown(_ sender: Any) {
        dropDown.show()
    }
    
    
    @IBAction func barcodeCancleBtn(_ sender: AnyObject) {
     self.removeBarcode(sender.tag)
    }
    
    func validInput() -> Bool {
        var flag = true
        if self.conditionBtn.titleLabel?.text == "Condition"{
            self.showToast(message: "Please select condition")
            flag = false
        }else if self.pictures.count == 0 {
            self.showToast(message: "Please take paicture")
            flag = false
        }
        return flag
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {

        var picDateTime = String()
        
        if self.validInput(){
            
            let date :Date = Date()
            
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
            
            //                let imageName = "/\(dateFormatter.string(from: date)).jpg"
            picDateTime = dateFormatter.string(from: date)
            
            print(picDateTime)
            
            
            if Utilites.isInternetAvailable(){
            let firstBarcode = self.barcode[0]
            for barcode in self.barcode{
                
               
                self.db.collection("Barcodes").document(barcode).setData([
                    "barcode": "\(barcode)",
                    "bin_name": "\(self.binBArcodeTextFiels.text ?? "")" ,
                    "cond_id": "\(self.conditin_Id)",
                    "cond_remarks": "\(self.cond_Remark)" ,
                    "condition": "\(self.conditionBtn.titleLabel?.text ?? "")",
                    "folderBarcode": "\(firstBarcode)",
                    "folderName": "\(barcode)" ,
                    "lot_id": "",
                    "mpn": "\(self.MPNTextFiels.text ?? "")" ,
                    "pic_DateTime": "\(picDateTime)",
                    "pic_taker_id": "\(Constants.Pic_Taker_Id)" ,
                    "remarks": "\(self.remarks)",
                    "sync_status": "" ,
                    "upc": "\(self.upcBarcodesTextField.text ?? "")"
                ]) { (err) in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added")
                    }
                    
                }
                
            }
            
//                if self.documentUpdate{
//                    self.documentUpdate = false
//                    for (key, value) in self.documentUpdateDAta {
//                        print("\(key) -> \(value)")
//                        if key == "sync_status"{
//
//                            if key == "condition"{
//                                self.conditionBtn.setTitle(value as? String, for: .normal)
//                            }
//                            if key == "mpn"{
//                                self.MPNTextFiels.text = value as? String
//                            }
//                            if key == "upc"{
//                                self.upcBarcodesTextField.text = value as? String
//                            }
//                            if key == "barcode"{
//                                self.barcode.append((value as? String)!)
//                            }
//                                print(self.documentUpdateDAta)
//                        }
//                    }
//                }
                
                
                
            let storageRef = storage.reference()
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            metadata.customMetadata = ["isLastImage":"false"]
            
            
            var i = 0
            let pic = self.pictures
            DispatchQueue.global().async {
                for img in pic{
                    
                    guard let data = img.jpegData(compressionQuality: 0.5) else {
                        return
                    }
                    
                    self.save(photo: img, toAlbum: firstBarcode) { (bool, error) in
                        print(bool)
                        if bool{
                            self.showToast(message: "Image Saved")
                        }else{
                            self.showToast(message: error!.localizedDescription)
                        }
                    }
                    
                    let date :Date = Date()
                    
                    let dateFormatter = DateFormatter()
                    //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
                    dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
                    
                    dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
                    
                    let imageName = "\(dateFormatter.string(from: date))\(pic[i]).jpg"
                    print("images/\(firstBarcode)/\(imageName)")
                    
                    
                    let riversRef = storageRef.child("images/\(firstBarcode)/\(imageName)")
                    riversRef.putData(data, metadata: metadata) { (metadata, error) in
                        guard let metadata = metadata else {
                            // Uh-oh, an error occurred!
                            Utilites.ShowAlert(title: "Error", message: "\(imageName) not upload", view: self)
                            return
                        }
                        
                        let size = metadata.size
                        print(size)
                        riversRef.downloadURL { (url, error) in
                            guard url != nil else {
                                // Uh-oh, an error occurred!
                                Utilites.ShowAlert(title: "Error", message: "\(imageName) not upload", view: self)
                                return
                            }
                            print(url!)
                        }
                    }
                    
                    i += 1
                }
            }
            
                
            }else{
                print(picDateTime)
                let pic = self.pictures
                var picdata = [Data]()
                let firstBarcode = self.barcode[0]
                
                for img in pic{
                    
                    guard let data = img.jpegData(compressionQuality: 0.5) else {
                        return
                    }
                    picdata.append(data)
                }
                
                let barcodeTosave = BarcodeDBModel(barcode: self.barcode, bin_name: "\(self.binBArcodeTextFiels.text ?? "")", cond_id: "\(self.conditin_Id)", cond_remarks: "\(self.cond_Remark)", condition: "\(self.conditionBtn.titleLabel?.text ?? "")", folderBarcode: "\(firstBarcode)", folderName: "\(barcode)", lot_id: "", mpn: "\(self.MPNTextFiels.text ?? "")", pic_DateTime: picDateTime, pic_taker_id: "\(Constants.Pic_Taker_Id)", remarks: "\(self.remarks)", sync_status: "", upc: "\(self.upcBarcodesTextField.text ?? "")", imageData: picdata)
                
                self.saveBarcodeInDB(name: barcodeTosave)
            }
            
            for savebarcodetohistory in self.barcode{
                self.savehistory(barcode: savebarcodetohistory, status: "0", pictures: "\(self.pictures.count)", condition: "\(self.conditionBtn.titleLabel?.text ?? "")", timeStamp: picDateTime)
            }
            
            
            
            self.reset()
        }
        
    }
  
    func savehistory(barcode: String , status :String, pictures: String , condition :String,timeStamp: String ) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "History",
                                       in: managedContext)!
        
        let condNAme = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        condNAme.setValue(barcode, forKey: "barcode")
        condNAme.setValue(condition, forKey: "condition")
        condNAme.setValue(status, forKey: "status")
        condNAme.setValue(pictures, forKey: "pictures")
        condNAme.setValue(timeStamp, forKey: "timeStamp")
        
        do {
            try managedContext.save()
            self.history.append(condNAme)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
  
    func saveBarcodeInDB(name: BarcodeDBModel) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let Barcodes = NSEntityDescription.insertNewObject(forEntityName: "Barcodes", into: managedContext) as! Barcodes
        
        Barcodes.setValue(name, forKey: "barcode")
        
        
        //        employee.setValue(name[0], forKey: "allPage")
        //        print(name[0])
        //        print(self.array[0].page_description)
        //        employee.allPage = name[0]
        
        do {
            
            try managedContext.save()
            //            self.name_list.append(employee)
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func fetchAndPrintEachBarcode() {
    
    
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let employeesFetch = NSFetchRequest<Barcodes>(entityName: "Barcodes")
        print(employeesFetch)
        
        
        do {
            
            let fetchedEmployees = try managedContext.fetch(employeesFetch)
             print(fetchedEmployees)
             print(fetchedEmployees.count)
            
            for i in fetchedEmployees {
                
                let firstBarcode = i.barcode?.barcode[0]
                for barcode in i.barcode!.barcode{
                    
                        self.db.collection("Barcodes").document(barcode).setData([
                            "barcode": "\(barcode)",
                            "bin_name": "\(i.barcode?.bin_name ?? "")" ,
                            "cond_id": "\(i.barcode?.cond_id ?? "")",
                            "cond_remarks": "\(i.barcode?.cond_remarks ?? "")" ,
                            "condition": "\(i.barcode?.condition ?? "")",
                            "folderBarcode": "\(i.barcode?.folderBarcode ?? "")",
                            "folderName": "\(barcode)" ,
                            "lot_id": "",
                            "mpn": "\(i.barcode?.mpn ?? "")" ,
                            "pic_DateTime": "\(i.barcode?.pic_DateTime ?? "")",
                            "pic_taker_id": "\(i.barcode?.pic_taker_id ?? "")" ,
                            "remarks": "\(i.barcode?.remarks ?? "")",
                            "sync_status": "\(i.barcode?.sync_status ?? "")" ,
                            "upc": "\(i.barcode?.upc ?? "")"
                        ]) { (err) in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added")
                            }
                            
                        }
                        
                    }
                    
                    
                    let storageRef = storage.reference()
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpg"
                    metadata.customMetadata = ["isLastImage":"false"]
                    
                    
                    var index = 0
                    let pic = i.barcode!.imageData
                    DispatchQueue.global().async {
                        for img in pic{
                            
                            let data = img
                            
                            
                            let date :Date = Date()
                            
                            let dateFormatter = DateFormatter()
                            //dateFormatter.dateFormat = "yyyy-MM-dd'_'HH:mm:ss"
                            dateFormatter.dateFormat = "yyyyMMddHHmmssSSSS"
                            
                            dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
                            
                            let imageName = "\(dateFormatter.string(from: date))\(pic[index]).jpg"
                            print("images/\(firstBarcode!)/\(imageName)")
                            
                            
                            let riversRef = storageRef.child("images/\(firstBarcode!)/\(imageName)")
                            riversRef.putData(data, metadata: metadata) { (metadata, error) in
                                guard let metadata = metadata else {
                                    // Uh-oh, an error occurred!
                                    Utilites.ShowAlert(title: "Error", message: "\(imageName) not upload", view: self)
                                    return
                                }
                                
                                let size = metadata.size
                                print(size)
                                riversRef.downloadURL { (url, error) in
                                    guard url != nil else {
                                        // Uh-oh, an error occurred!
                                        Utilites.ShowAlert(title: "Error", message: "\(imageName) not upload", view: self)
                                        return
                                    }
                                    print(url!)
                                }
                            }
                            
                            index += 1
                        }
                        
                    }
                    
                    let entity = NSEntityDescription.entity(forEntityName:"Barcodes", in: managedContext)
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
                    fetchRequest.entity = entity
                    let predicate = NSPredicate(format:"barcode == %@", i.barcode!)
                    fetchRequest.predicate = predicate
                    
                    do {
                        let results = try managedContext.fetch(fetchRequest)
                        guard let obj = (results as? [Barcodes])?.first else { return }
                        managedContext.delete(obj)
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Unable to Delete Employee \(error), \(error.userInfo)")
                    }
                
            }
            
            
            
            
           
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    
    }
    
    func createAlbum(withTitle title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            var placeholder: PHObjectPlaceholder?
            
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { (created, error) in
                var album: PHAssetCollection?
                if created {
                    let collectionFetchResult = placeholder.map { PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [$0.localIdentifier], options: nil) }
                    album = collectionFetchResult?.firstObject
                }
                
                completionHandler(album)
            })
        }
    }
    
    func getAlbum(title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", title)
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let album = collections.firstObject {
                completionHandler(album)
            } else {
                self?.createAlbum(withTitle: title, completionHandler: { (album) in
                    completionHandler(album)
                })
            }
        }
    }
    
    func save(photo: UIImage, toAlbum titled: String, completionHandler: @escaping (Bool, Error?) -> ()) {
        getAlbum(title: titled) { (album) in
            DispatchQueue.global(qos: .background).async {
                PHPhotoLibrary.shared().performChanges({
                    let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: photo)
                    let assets = assetRequest.placeholderForCreatedAsset
                        .map { [$0] as NSArray } ?? NSArray()
                    let albumChangeRequest = album.flatMap { PHAssetCollectionChangeRequest(for: $0) }
                    albumChangeRequest?.addAssets(assets)
                }, completionHandler: { (success, error) in
                    completionHandler(success, error)
                })
            }
        }
    }
    
    
    @IBAction func resetBtn(_ sender: Any) {
        self.reset()
        
    }
    
    func reset()  {
        if audioEngine.isRunning {
            stopRecording()
            checkForActionPhrases()
        }
        self.conditionBtn.setTitle("Condition", for: .normal)
        self.binBArcodeTextFiels.text = ""
        self.MPNTextFiels.text = ""
        self.upcBarcodesTextField.text = ""
        self.barcode.removeAll()
        self.pictures.removeAll()
        self.upcBArcode.removeAll()
        Constants.barcodes.removeAll()
        Constants.UPCBarcode.removeAll()
        self.barcodeCollectionView.reloadData()
        self.collectionView.reloadData()
        self.takePic.isUserInteractionEnabled = false
        self.takePic.backgroundColor = UIColor.lightGray
        self.takePic.isEnabled = false
        self.MPNBarcode = ""
        self.binBarcode = ""
        self.remarks = ""
        self.cond_Remark = ""
        self.remarkBtn.isHidden = true
        self.condRemarkBtn.isHidden = true
        
    }
    
    
    
    @IBAction func scanBin(_ sender: AnyObject) {
        
        if audioEngine.isRunning {
            stopRecording()
            checkForActionPhrases()
        }
        
        let main = self.storyboard?.instantiateViewController(withIdentifier: "BarCodeDetectorViewController") as! BarCodeDetectorViewController
        if sender.tag == 0{
            main.type = "bin"
        }else if sender.tag == 1 {
            main.type = "MPN"
        }
        
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    
    @IBAction func resetBin(_ sender: AnyObject) {
        
        if sender.tag == 0{
            self.binBArcodeTextFiels.text = ""
            self.binBarcode = ""
        }else{
            self.MPNTextFiels.text = ""
            self.MPNBarcode = ""
        }
        
    }
    
    
    
//    @IBAction func voiceStartBtn(_ sender: Any) {
//
//        if self.VoiceBtn.titleLabel?.text == "Start"{
//            do{
//                try startRecording()
//            }catch{
//
//            }
//        }else{
//            if audioEngine.isRunning {
//                stopRecording()
//                checkForActionPhrases()
//            }
//        }
//
//
//    }
    
    func dataBack(img: [UIImage]) {
        self.pictures = img
        self.collectionView.reloadData()
        
    }
    
    
    @IBAction func remarkBtn(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            let alert = UIAlertController(title: "Remarks", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                    
                    self.remarks = alertTextField.text!
                    
                }
                
            }))
            
            alert.addTextField { (textField) in
                //                alert.message = textField.text
                textField.text = self.remarks
                
            }
            
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                self.remarks = ""
                self.remarkBtn.isHidden = true
            }))
            
            
            self.present(alert, animated: true)
            
            

        }else{
            
            
            let alert = UIAlertController(title: "Condition Remarks", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                if let alertTextField = alert.textFields?.first, alertTextField.text != nil {
                    
                    self.cond_Remark = alertTextField.text!
                    
                }
                
            }))
            
            
            alert.addTextField { (textField) in

                textField.text = self.cond_Remark
                
            }
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                self.cond_Remark = ""
                self.condRemarkBtn.isHidden = true
            }))
            
            
            self.present(alert, animated: true)
            
            
            Utilites.ShowAlert(title: "Condition Remarks", message: self.cond_Remark, view: self)
        }
    }
    
    
}
