//
//  PersonalChatVC.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-02.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Firebase

class PersonalChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet var mainView: UIView!
  @IBOutlet weak var textInputView: UIView!
  @IBOutlet weak var chatTableView: UITableView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var sendBtn: UIButton!
  @IBOutlet weak var heightConstraint: NSLayoutConstraint!
  //    @IBOutlet weak var contactNameLabel: UILabel!
  let imagePickerContorller = UIImagePickerController()
  let colours = Colours()
  
  let customMessageIn = CustomMessageIn()
  let customMessageOut = CustomMessageOut()
  
  let dateFormatter = DateFormatter()
  let now = NSDate()
  var chat: Chat?
  var chatMessages = [Message]()
  
  func initData(forChat chat: Chat){
    self.chat = chat
    
  }
  
  //
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UserServices.instance.getUserData(byUserId: (chat?.chatName)!) { (userData) in
      self.title = userData.1
    }
    
    MessageServices.instance.REF_MESSAGES.child((self.chat?.key)!).observe(.value) { (snapshot) in
      MessageServices.instance.getAllMessagesFor(desiredChat: self.chat!, handler: { (returnedChatMessages) in
        self.chatMessages = returnedChatMessages
        self.chatTableView.reloadData()
        
        if self.chatMessages.count > 0 {
          self.chatTableView.scrollToRow(at: IndexPath(row: self.chatMessages.count - 1, section: 0) , at: .none, animated: true)
        }
      })
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    
    
    NotificationCenter.default.addObserver(self, selector:#selector(PersonalChatVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector:#selector(PersonalChatVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    chatTableView.delegate = self
    chatTableView.dataSource = self
    textField.delegate = self
    imagePickerContorller.delegate = self
    
    chatTableView.register(UINib(nibName: "CustomMessageIn", bundle: nil), forCellReuseIdentifier: "messageIn")
    chatTableView.register(UINib(nibName: "CustomMessageOut", bundle: nil), forCellReuseIdentifier: "messageOut")
    
    chatTableView.register(UINib(nibName: "MultimediaMessageIn", bundle: nil), forCellReuseIdentifier: "multimediaMessageIn")
    chatTableView.register(UINib(nibName: "MultimediaMessageOut", bundle: nil), forCellReuseIdentifier: "multimediaMessageOut")
    
    //    chatTableView.register(UINib(nibName: "WebCellOut", bundle: nil), forCellReuseIdentifier: "webOut")
    
    self.hideKeyboardWhenTappedAround()
    chatTableView.separatorStyle = .none
    
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    
    //        UIView.animate(withDuration: 0.1) {
    //
    //            self.heightConstraint.constant = 325
    //            self.view.layoutIfNeeded()
    //        }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
    
    let outColor = colours.colourMainBlue
    let inColor = colours.colourMainPurple
    let sender = chatMessages[indexPath.row].senderId
    let isMedia = chatMessages[indexPath.row].isMultimedia
    let mediaUrl = chatMessages[indexPath.row].mediaUrl
    let content = chatMessages[indexPath.row].content
    
    
    // Get URL from String
    //    var url: String? = ""
    //
    //    let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    //    let matches = detector.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
    //
    //    for match in matches {
    //      guard let range = Range(match.range, in: content) else { continue }
    //      url = String(content[range])
    ////      print(url)
    //    }
    
    if  sender == currentUserId {
      
      if isMedia == true {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "multimediaMessageOut", for: indexPath) as! MultimediaMessageOut
        let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
        
        cell.configeureCell(messageImage: mediaUrl, messageTime: date!, senderName: sender)
        return cell
        
      }
      
      // WebView CEll
      //        else if url != nil {
      //        let cell = tableView.dequeueReusableCell(withIdentifier: "webOut", for: indexPath) as! WebCellOut
      //        let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
      //
      //        cell.configeureCell(mediaUrl: content, messageTime: date!, senderName: sender)
      //        return cell
      //      }
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "messageOut", for: indexPath) as! CustomMessageOut
      let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
      
      cell.configeureCell(senderName: currentEmail!, messageTime: date!, messageBody: content, messageBackground: outColor!)
      return cell
      
    } else {
      
      if isMedia == true {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "multimediaMessageIn", for: indexPath) as! MultimediaMessageIn
        let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
        
        cell.configeureCell(messageImage: mediaUrl, messageTime: date!, senderName: sender)
        return cell
        
      }
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "messageIn", for: indexPath) as! CustomMessageIn
      let date = getDateFromInterval(timestamp: Double(chatMessages[indexPath.row].timeSent))
      
      cell.configeureCell(senderName: chatMessages[indexPath.row].senderId, messageTime: date!, messageBody: chatMessages[indexPath.row].content, messageBackground: inColor!)
      return cell
      
    }
  }
  
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    UIView.animate(withDuration: 0.2) {
      
      self.heightConstraint.constant = 60
      self.view.layoutIfNeeded()
      
    }
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chatMessages.count
  }
  
  
  @IBAction func sendButton(_ sender: Any) {
    
    let date = Date()
    let currentDate = date.timeIntervalSinceReferenceDate
    let messageUID = ("\(currentDate)" + currentUserId!).replacingOccurrences(of: ".", with: "")
    if textField.text != "" {
      sendBtn.isEnabled = false
      MessageServices.instance.sendMessage(withContent: textField.text!, withTimeSent: "\(currentDate)", withMessageId: messageUID, forSender: currentUserId! , withChatId: chat?.key, isMultimedia: false, sendComplete: { (complete) in
        if complete {
          self.textField.isEnabled = true
          self.sendBtn.isEnabled = true
          self.textField.text = ""
          print("Message saved \(currentDate)")
        }
      })
    }
  }
  
  @IBAction func photoMessageButton(_ sender: Any) {
    
    
    let actionSheet = UIAlertController(title: "Select source of Image", message: "", preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
      self.imagePickerContorller.sourceType = .camera
      self.present(self.imagePickerContorller, animated: true, completion: nil)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
      self.imagePickerContorller.sourceType = .photoLibrary
      self.present(self.imagePickerContorller, animated: true, completion: nil)
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
    
    
    self.present(actionSheet, animated: true, completion: nil)
    
    print("Photo Message Uploaded")
    
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    let date = Date()
    let currentDate = date.timeIntervalSinceReferenceDate
    let messageUID = ("\(currentDate)" + currentUserId!).replacingOccurrences(of: ".", with: "")
    
    Services.instance.uploadPhotoMessage(withImage: image, withChatKey: (self.chat?.key)!, withMessageId: messageUID, completion: { (imageUrl) in
      
      MessageServices.instance.sendPhotoMessage(isMulti: true, withMediaUrl: imageUrl, withTimeSent: "\(currentDate)", withMessageId: messageUID, forSender: currentUserId!, withChatId: self.chat?.key, sendComplete: { (complete) in
        self.textField.isEnabled = true
        self.sendBtn.isEnabled = true
        self.textField.text = ""
        print("Message saved \(currentDate)")
      })
    })
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  @objc func tableViewTapped() {
    chatTableView.endEditing(true)
  }
  
  func configureTableView() {
    chatTableView.rowHeight = UITableViewAutomaticDimension
    chatTableView.estimatedRowHeight = 263.0
  }
  //
  
  @objc func keyboardWillShow(notification : NSNotification) {
    
    let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue.size
    
    self.heightConstraint.constant = keyboardSize.height + 60
    UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
      
    })
  }
  
  @objc func keyboardWillHide(notification : NSNotification) {
    self.heightConstraint.constant = 0
    
  }
  
  // MARK: -- Navigation --
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserProfile" {
      let userProfileVC = segue.destination as! UserProfileVC
      if let chatName = chat?.chatName {
        userProfileVC.chatName = chatName
      }
    }
  }
  
  deinit{
    
  }
  
}







