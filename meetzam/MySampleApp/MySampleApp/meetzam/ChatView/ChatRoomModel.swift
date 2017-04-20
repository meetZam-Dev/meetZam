//
//  ChatRoom.swift
//  MySampleApp
//
//  Created by mushroom on 4/5/17.
//
//

import Foundation
import AWSDynamoDB
import AWSMobileHubHelper

let AWSDynamoDBChatroom = "chatroom"
class ChatRoomModel : AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    
    var userId: String?
    var chatRoomId: String?
    //var lastActivated: String?
    var recipientId: String?
    var timeStamp: String?
    
    class func dynamoDBTableName() -> String {
        return AWSDynamoDBChatroom
    }
    
    class func hashKeyAttribute() -> String {
        return "chatRoomId"
    }
    
    func createChatRoom(recipient: String) {
        
        print("===== Create Chat Room =====")
        print("create for current")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let mapper = AWSDynamoDBObjectMapper.default()
        
        let chatRoom = ChatRoomModel()
        
        chatRoom?.chatRoomId = UUID().uuidString
        chatRoom?.timeStamp = Date().iso8601
        chatRoom?.userId = AWSIdentityManager.default().identityId!
        chatRoom?.recipientId = recipient
        var dummynum = 0
        mapper.save(chatRoom!) .continueWith(block: { (task: AWSTask!) -> AnyObject! in
            if ((task.error) != nil) {
                NSLog("Failed")
                print("Error: \(String(describing: task.error))")
            }
            else {
                print("SUCCESS")
            }
            dummynum = 6
            return nil
        })
        var dummynum2 = 0
        
        print("create for recipient")
        
        let mapper2 = AWSDynamoDBObjectMapper.default()
        
        let chatRoom2 = ChatRoomModel()
        
        chatRoom2?.chatRoomId = UUID().uuidString
        chatRoom2?.timeStamp = Date().iso8601
        chatRoom2?.userId = recipient
        chatRoom2?.recipientId = AWSIdentityManager.default().identityId!
        
        mapper2.save(chatRoom2!) .continueWith(block: { (task: AWSTask!) -> AnyObject! in
            if ((task.error) != nil) {
                NSLog("Failed")
                print("Error: \(String(describing: task.error))")
            }
            else {
                print("SUCCESS")
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            dummynum2 = 7
            return nil
        })
        var waiting = 0
        while (dummynum != 6 || dummynum2 != 7)
        {
            waiting = 1
        }
        
    }
    /*
    func updateTimeStamp(chatRoomId: String) {
        API().updateTimeStamp(chatRoomId: chatRoomId, timeStamp: Date().iso8601)
    }
    */
    func updateTimeStamp() {
        API().updateTimeStamp(chatRoomId: self.chatRoomId!, timeStamp: Date().iso8601)
        //API().updateTimeStamp(chatRoomId: "test", timeStamp: "mushroom30")
    }
    
    
    func deleteRoom(roomId: String) {
        let other_room = self.getPairRoomId(chatRoomId: roomId)
        print("other room is \(other_room)")
        API().deleteConversation(chatRoomId: roomId)
        API().deleteConversation(chatRoomId: other_room)
        API().deleteChatRoom(chatRoomId: roomId)
        API().deleteChatRoom(chatRoomId: other_room)
    }
    
    
    func getChatRoomList() -> [ChatRoomModel] {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        print("===== getChatRoomList =====")
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        
        queryExpression.filterExpression = "userId = :userId";
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!]
      
        var roomList = [ChatRoomModel]()
        var dummynum = 0

        dynamoDBObjectMapper.scan(ChatRoomModel.self, expression: queryExpression).continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
        
            if let paginatedOutput = task.result {
                for item in paginatedOutput.items as! [ChatRoomModel] {
                    
                    roomList.append(item)
                    //print("getting room \(item.chatRoomId ?? "no Room") of user \(item.userId ?? "no ID")")
                }
                
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //self.tableView.reloadData()
            if let error = task.error as NSError? {
                print("Error: \(error)")
                
            }
            dummynum = 6
            print("get list of chatroom: SUCCESS")
            return nil
        })
        var waiting = 0
        while (dummynum != 6)
        {
            waiting = 1
        }
        //print(roomList.description)
        print("got \(roomList.count) chatrooms")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        return roomList
    }
   
    func getChatRoomId(userId: String, recipientId: String) -> String{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        print("===== getChatRoomId =====")
        print("of \(userId) and \(recipientId)")
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        queryExpression.filterExpression = "userId = :userId AND recipientId = :recipientId";
        queryExpression.expressionAttributeValues = [":userId": userId, ":recipientId": recipientId]
        
        var roomList = Set<ChatRoomModel>()
        var dummynum = 0
        dynamoDBObjectMapper.scan(ChatRoomModel.self, expression: queryExpression).continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            
            if let paginatedOutput = task.result {
                for item in paginatedOutput.items as! [ChatRoomModel] {
                    
                    roomList.insert(item)
                    //print("getting room \(item.chatRoomId ?? "no Room") of user \(item.userId ?? "no ID")")
                }
                
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //self.tableView.reloadData()
            if let error = task.error as NSError? {
                print("Error: \(error)")
                
            }
            dummynum = 6
            print("get list of chatroom: SUCCESS")
            return nil
        })
        var waiting = 0
        while (dummynum != 6)
        {
            waiting = 1
        }
        //print(roomList.description)
        print("got \(roomList.count) chatrooms")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        return roomList.first!.chatRoomId!

    }
    
    
    func getSingleChatRoom(chatRoomId: String) -> ChatRoomModel {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
        print("===== getSingleChatRoom of \(chatRoomId) =====")
        let mapper = AWSDynamoDBObjectMapper.default()
        var getted_chatroom = ChatRoomModel()
        var dummynum = 0
        mapper.load(ChatRoomModel.self, hashKey: chatRoomId, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as NSError? {
                print("get single chatroom Error: \(error)")
                getted_chatroom = nil
            } else if let item = task.result as? ChatRoomModel {
                getted_chatroom = item
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            dummynum = 6
            return nil
        })
        var waiting = 0
        while (dummynum != 6)
        {
            waiting = 1
        }
        print("getting room \(getted_chatroom?.chatRoomId ?? "no Room") of user \(getted_chatroom?.userId ?? "no ID")")
        return getted_chatroom!
        
    }
    
    func getPairRoomId(chatRoomId: String) -> String {
        let temp_room = self.getSingleChatRoom(chatRoomId: chatRoomId)
        print(temp_room.userId ?? "no user Id")
        print(temp_room.recipientId ?? "no recipient Id")
        assert(temp_room.chatRoomId == chatRoomId)
        return getChatRoomId(userId: temp_room.recipientId!, recipientId: temp_room.userId!)
    }
 
    func getSingleChatRoom(userId: String, recipientId: String) -> ChatRoomModel{
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        print("===== getSingleChatRoom =====")
        
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        queryExpression.filterExpression = "userId = :userId AND recipientId = :recipientId";
        queryExpression.expressionAttributeValues = [":userId": userId, ":recipientId": recipientId]
        
        var roomList = Set<ChatRoomModel>()
        var dummynum = 0
        dynamoDBObjectMapper.scan(ChatRoomModel.self, expression: queryExpression).continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            
            if let paginatedOutput = task.result {
                for item in paginatedOutput.items as! [ChatRoomModel] {
                    
                    roomList.insert(item)
                    //print("getting room \(item.chatRoomId ?? "no Room") of user \(item.userId ?? "no ID")")
                }
                
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //self.tableView.reloadData()
            if let error = task.error as NSError? {
                print("Error: \(error)")
                
            }
            dummynum = 6
            print("get list of chatroom: SUCCESS")
            return nil
        })
        var waiting = 0
        while (dummynum != 6)
        {
            waiting = 1
        }
        //print(roomList.description)
        print("got \(roomList.count) chatrooms")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        return roomList.first!
        
    }
    
    func sortByTime(roomList: [ChatRoomModel]) -> [ChatRoomModel] {
        return roomList.sorted(by: { $0.timeStamp?.compare($1.timeStamp!) == .orderedDescending })
    }
    
    
    
}
