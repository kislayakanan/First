//
//  ChatVC.swift
//  Shabbat_Project
//
//  Created by WebAstral on 5/12/16.
//  Copyright © 2016 WebAstral. All rights reserved.
//

import UIKit



class ChatVC: JSQMessagesViewController
{

    var USER_CAST:String?
    var Name:String?
    var current_userID:String?
    var messages = [JSQMessage]()
    var connectedPersonId:String?
    var requestStatus:String?
    var requestedDinnerId:String?
    let invitationBtn = UIButton(type: .Custom)
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var usersTypingQuery: FIRDatabaseQuery!
    
    //let ref = Firebase(url:"https://shabbatapp.firebaseio.com/")
    var ref = FIRDatabase.database().reference()
    var messageRef: FIRDatabaseReference!
    
    var userIsTypingRef: FIRDatabaseReference! // 1
    private var localTyping = false // 2
    var isTyping: Bool
        {
        get
        {
            return localTyping
        }
        set
        {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    
    private func observeTyping()
    {
        let typingIndicatorRef = ref.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        
        // 1
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
        
        // 2
        usersTypingQuery.observeEventType(.Value)
        { (data: FIRDataSnapshot!) in
            
            // 3 You're the only typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping
            {
                return
            }
            
            // 4 Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottomAnimated(true)
        }        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        messageRef = ref.child("messages")
        
        
        USER_CAST =  NSUserDefaults.standardUserDefaults().objectForKey("user_cast") as? String
        current_userID = NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String

        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        let nav1Lbl = UILabel(frame: CGRectMake(0, 0, 200, 44))
        
        let users = ref.child("USERS")
        print(connectedPersonId)
        let connected_user = users.child(connectedPersonId!)
        
        //let user = Firebase(url:"https://shabbatapp.firebaseio.com/USERS/" + connectedPersonId!)
        // To fetch the name of connected user
        connected_user.observeEventType(.Value, withBlock:
            {
                snapshot in
                let dict = snapshot.value as? NSDictionary
                print(dict)
                nav1Lbl.text = dict!.objectForKey("fullname") as? String
            })

        nav1Lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        nav1Lbl.textAlignment = .Center
        nav1Lbl.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = nav1Lbl
        
        let button = UIButton(type: .Custom)
        button.addTarget(self, action:#selector(ChatVC.backMethod), forControlEvents: .TouchUpInside)
        button.setImage(UIImage(named: "backicon"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        let bBarBtn: UIBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = bBarBtn
        
        
        if USER_CAST == "HOST"
        {
            invitationBtn.addTarget(self, action:#selector(ChatVC.sendInvitation), forControlEvents: .TouchUpInside)
            invitationBtn.frame = CGRectMake(0, 0, 30, 30)
            let sBarBtn: UIBarButtonItem = UIBarButtonItem(customView: invitationBtn)
            self.navigationItem.rightBarButtonItem = sBarBtn
            
            if requestStatus == "You are invited"
            {
                invitationBtn.setImage(UIImage(named: "green-trophy"), forState: .Normal)
            }
            else if requestStatus == "Request accepted"
            {
               invitationBtn.setImage(UIImage(named: "yellow_trophy"), forState: .Normal)
            }
        }

        
        setupBubbles()
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        //To remove left toolbar button
        self.inputToolbar.contentView.leftBarButtonItem = nil        
        
    }
    
    
    private func setupBubbles()
    {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print(messages.count)
        return messages.count
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId
        { // 2
            return outgoingBubbleImageView
        }
        else
        { // 3
            return incomingBubbleImageView
        }
    }
    
    
    func addMessage(id: String, text: String)
    {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    

    
    
    func backMethod()
    {
        //to dismiss keypad
        let textView = self.inputToolbar.contentView.textView
        textView.text = nil
        self.navigationController?.popViewControllerAnimated(true)
        self.view.endEditing(true)
        
        
    }
    
    //MARK: Method to send invitation to seeker
    func sendInvitation()
    {

        if invitationBtn.currentImage == UIImage(named: "yellow_trophy")
        {
            let data =
                [
                    connectedPersonId!:"You are invited"
                 ]
            
            let requests = ref.child("REQUESTS")
            let user = requests.child(current_userID!)
            let dinner = user.child(requestedDinnerId!)
            dinner.updateChildValues(data)//to update child values
           // self.alertShowMethod("", message: "You are invited")
            
            invitationBtn.setImage(UIImage(named: "green_trophy"), forState: .Normal)
        }
        



    }
    
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        observeMessages()
        observeTyping()
    }
    
    private func observeMessages()
    {
        // 1
        let messagesQuery = messageRef.queryLimitedToLast(25)
        // 2
        messagesQuery.observeEventType(.ChildAdded)
        { (snapshot: FIRDataSnapshot!) in
            // 3
            
            let dict = snapshot.value as? NSDictionary
            print(dict)
            
            let id = snapshot.value!["senderId"] as! String
            let reciever = snapshot.value!["recieverId"] as! String
            
            if (reciever == self.connectedPersonId && id == NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String) || (id == self.connectedPersonId && reciever == NSUserDefaults.standardUserDefaults().objectForKey("current_userID") as? String)
            {
                let text = snapshot.value!["text"] as! String
                
                // 4
                self.addMessage(id, text: text)
                
                // 5
                self.finishReceivingMessage()
            }

        }
    }
    
    
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,senderDisplayName: String!, date: NSDate!)
    {
        
        let itemRef = messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "text": text,
            "senderId": senderId,
            "recieverId":connectedPersonId
        ]
        itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        
        finishSendingMessage()
        
        isTyping = false
    }
    
    
    override func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId
        {
            cell.textView!.textColor = UIColor.whiteColor()
        }
        else
        {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    
    
    override func textViewDidChange(textView: UITextView)
    {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

