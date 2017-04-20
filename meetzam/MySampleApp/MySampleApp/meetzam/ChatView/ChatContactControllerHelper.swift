//
//  ChatContactControllerHelper.swift
//  MySampleApp
//
//  Created by ZuYuan Fan on 4/17/17.
//
//

import UIKit
import CoreData

extension ChatViewController {
    
    // clean data in core data
    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
           
            do {
                let entityNames = ["Contact", "Message"]
                
                for entityname in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityname)
                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
                    
                    for obj in objects! {
                        context.delete(obj)
                    }
                }
                try(context.save())
                
            } catch let err {
                print(err)
            }
        }
    }
    
    // setup data to core data
    func setupData() {
        // MUST clear core data first, or there will be duplicated messages in core data
        clearData()
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            // create contacts and messages
            var chatRoomList = ChatRoomModel().getChatRoomList()
            print(chatRoomList.count)
            if chatRoomList.count != 0 {
                chatRoomList = ChatRoomModel().sortByTime(roomList: chatRoomList) // Sorted List
                for singleChatRoom in chatRoomList {
                    // DB
                    let contactID = singleChatRoom.recipientId!
                    let contactName = UserProfileToDB().getUserProfileByIds(userIDs: [contactID])[0].displayName
                    let imagePath_string = UserProfileToDB().downloadUserIcon(userID: contactID).path
                    let chatRoomID_2 = ChatRoomModel().getChatRoomId(userId: contactID, recipientId: singleChatRoom.userId!)
                    
                    // Local
                    let localContact = self.createContactwithName(name: contactName!, profileimageName: imagePath_string, context: context, userID: contactID)
                    let allMessages = ConversationModel().getHistoryRecords(userId_1: singleChatRoom.userId!, _chatRoomId_1: singleChatRoom.chatRoomId!, userId_2: contactID, _chatRoomId_2: chatRoomID_2)
                    
                    for singleMessage in allMessages {
                        let localText = singleMessage.message
                        let createDate = singleMessage.createdAt?.dateFromISO8601
                        
                        if singleMessage.userId != contactID {
                            ChatViewController.createMessagewithText(text: localText!, contact: localContact, minutesAgo: createDate!, context: context, issender: true)
                        }
                        else {
                            ChatViewController.createMessagewithText(text: localText!, contact: localContact, minutesAgo: createDate!, context: context)
                        }
                        
                    }
                    
                }
            }
            
            // save these data into context(core data)
            do {
                try(context.save())
            } catch let error {
                print(error)
            }
            
        }

    }
    
    // helper function to help create multiple contacts
    private func createContactwithName(name: String, profileimageName: String, context: NSManagedObjectContext, userID: String) -> Contact {
        let cont = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact
        cont.name = name
        cont.profileImageName = profileimageName
        cont.userID = userID
        
        return cont
    }
    
    // helper function to help create multiple messages
    static func createMessagewithText(text: String, contact: Contact, minutesAgo: Date, context: NSManagedObjectContext, issender: Bool = false) {
        let msg = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        msg.contact = contact
        msg.text = text
        msg.date = minutesAgo as NSDate
//            NSDate().addingTimeInterval(-minutesAgo * 60)
        msg.isSender = issender
        
        contact.lastMessage = msg
        
    }
    
}


//            // Jack
//            let jack = createContactwithName(name: "Jack", profileimageName: "profile1", context: context)
//            ChatViewController.createMessagewithText(text: "Message content testing here this is wayyyyyyyyyyyyy tooooo loong and we are trying to display it", contact: jack, minutesAgo: 60 * 24 * 8, context: context)
//
//            // Ryan
//            let ryan = createContactwithName(name: "Ryan", profileimageName: "profile0", context: context)
//            ChatViewController.createMessagewithText(text: "Hi there this is awesome", contact: ryan, minutesAgo: 10, context: context)
//            ChatViewController.createMessagewithText(text: "I'm trying to finish it", contact: ryan, minutesAgo: 6, context: context)
//            ChatViewController.createMessagewithText(text: "Hello how are you??", contact: ryan, minutesAgo: 2, context: context)
//            ChatViewController.createMessagewithText(text: "Yes I can see your message", contact: ryan, minutesAgo: 1, context: context, issender: true)
//            ChatViewController.createMessagewithText(text: "Only one report should be submitted per group with each person submitting their own statement of contribution separately.", contact: ryan, minutesAgo: 0.5, context: context)
//            ChatViewController.createMessagewithText(text: "Everything should be submitted on Blackboard. The statement of contribution should consist of what you did in the project and if there were any problems with the group as a whole.", contact: ryan, minutesAgo: 0.25, context: context, issender: true)
//            ChatViewController.createMessagewithText(text: "Throughout the semester we have learned some basic but useful statistics tools. With these tools, we can conduct analysis on some problems that we may be interested in. Since most data sets contain a large amount of different types of data,", contact: ryan, minutesAgo: 0, context: context)
//
//            // Rose
//            let rose = createContactwithName(name: "Rose", profileimageName: "profile2", context: context)
//            ChatViewController.createMessagewithText(text: "I love Jack", contact: rose, minutesAgo: 60 * 24, context: context)