//
//  UserProfileToDB.swift
//  MySampleApp
//
//  Created by Rainy on 2017/2/26.
//
//
import AWSDynamoDB
//
//  UserProfile.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.10
//
import Foundation
import UIKit
import AWSDynamoDB
class UserProfileToDB: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var userId: String?
    var displayName: String?
    var bio: String?
    var age: String?
    var gender: String?
    var region: String?
    var email: String?
    var currentLikedMovie = Set<String>()
    
    class func dynamoDBTableName() -> String {
        
        return "meetzam-mobilehub-1569925313-UserProfile"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "userId"
    }
    
    // function to add/update user info into database
    // argument: dbName...
    func insertProfile(_userId: String, _displayName: String, _bio: String, _age: String, _gender: String, _region: String, _email: String) {
        print("     insertProfile")
        let mapper = AWSDynamoDBObjectMapper.default()
        var userProfile = UserProfileToDB()
        
        mapper.load(UserProfileToDB.self, hashKey: _userId, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("InsertError: \(error)")
            } else if let user_profile_addTo = task.result as? UserProfileToDB {
                userProfile?.currentLikedMovie=user_profile_addTo.currentLikedMovie
                userProfile?.userId=user_profile_addTo.userId
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        while(userProfile?.userId==nil)
        {
            print("waiting")
        }
        
        userProfile?.userId  = _userId
        userProfile?.displayName = _displayName
        userProfile?.bio = _bio
        userProfile?.age = _age
        userProfile?.gender = _gender
        userProfile?.region = _region
        userProfile?.email = _email
        mapper.save(userProfile!)
        
        /*mapper.save(userProfile!).continueWith(block: { (task:AWSTask<AnyObject>!) -> Any? in
         if let error = task.error as? NSError {
         print("The request failed. Error: \(error)")
         } else {
         // Do something with task.result or perform other operations.
         }
         })*/
        
        
        //return BFTask(forCompletionOfAllTasks: [task1, task2, task3])
    }
    
    func getProfileForEdit(key: String, user_profile: UserProfileToDB?, displayname: UITextField!, bio: UITextField!, age: UITextField!, gender: UITextField!, region: UITextField!, email: UITextField!){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let mapper = AWSDynamoDBObjectMapper.default()
        
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            } else if let user_profile = task.result as? UserProfileToDB {
                displayname.text = user_profile.displayName
                //print(displayname.text)
                bio.text = user_profile.bio
                //print(bio.text)
                age.text = user_profile.age
                //print(age.text)
                gender.text = user_profile.gender
                //print(gender.text)
                region.text = user_profile.region
                //print(region.text)
                email.text = user_profile.email
                //print(email.text)
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        
    }
    
    func getProfileForDisplay(key: String, user_profile: UserProfileToDB?, displayname: UILabel!, bio: UILabel!){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let mapper = AWSDynamoDBObjectMapper.default()
        
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            } else if let user_profile = task.result as? UserProfileToDB {
                //print("     Getting fields in user_profile")
                displayname.text = user_profile.displayName
                //print(displayname.text)
                bio.text = user_profile.bio
                //print(bio.text)
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        
    }
    

    func insertToCurrentLikedMovie(key: String, movieTitle: String)
    {
        print("     insertToCurrentLikedMovie!!")
        /*let dynamoDB = AWSDynamoDB.default()
        let updateInput = AWSDynamoDBUpdateItemInput()
        
        let hashKeyValue = AWSDynamoDBAttributeValue()
        hashKeyValue?.s = key
        updateInput?.tableName = "meetzam-mobilehub-1569925313-UserProfile"
        updateInput?.key = ["userId": hashKeyValue!]
        let valueUpdate = AWSDynamoDBAttributeValueUpdate()
        let newTitle = AWSDynamoDBAttributeValue()
        newTitle?.ss?.append(movieTitle)
        valueUpdate?.value = newTitle
        valueUpdate?.action = .put
        updateInput?.attributeUpdates = ["currentLikedMovie": valueUpdate!]
        dynamoDB.updateItem(updateInput!).continueWith { (task:AWSTask<AWSDynamoDBUpdateItemOutput>) -> Any? in
            if let error = task.error as? NSError {
                print("The request failed. Error: \(error)")
                return nil
            }
            return nil
        }*/
        let mapper = AWSDynamoDBObjectMapper.default()
        
        var userProfile = UserProfileToDB()

        print("     before load!!")
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.immediate(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("InsertError: \(error)")
            } else if let user_profile_addTo = task.result as? UserProfileToDB {
                userProfile?.userId=key
                print("     key is \(key)")
                userProfile?.displayName = user_profile_addTo.displayName
                print("displayname is \(userProfile?.displayName)")
                userProfile?.bio = user_profile_addTo.bio
                print("bio is \(userProfile?.bio)")
                userProfile?.age = user_profile_addTo.age
                print("age is \(userProfile?.age)")
                userProfile?.gender = user_profile_addTo.gender
                print("gender is \(userProfile?.gender)")
                userProfile?.region = user_profile_addTo.region
                print("region is \(userProfile?.region)")
                userProfile?.currentLikedMovie=user_profile_addTo.currentLikedMovie
                for movie in (userProfile?.currentLikedMovie)! {
                    print("\(movie)")
                }
                userProfile?.email = user_profile_addTo.email
                print("email is \(userProfile?.email)")
                print("     all put")
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        while(userProfile?.email==nil)
        {
            print("waiting")
        }
        print("SHOULD BE AFTER LOAD: displayname is \(userProfile?.displayName)")
        if (!((userProfile?.currentLikedMovie.contains(movieTitle))!))
        {
            userProfile?.currentLikedMovie.insert(movieTitle)
        }
        for movie in (userProfile?.currentLikedMovie)! {
            print("\(movie)")
        }
        mapper.save(userProfile!)
    }
    
    /*func returnUser(key: String) -> UserProfileToDB
    {
        print("     returnUser!!")
        let mapper = AWSDynamoDBObjectMapper.default()
        var getuserProfile = UserProfileToDB()
        mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                //print("Error: \(error)")
            } else if let user_profile = task.result as? UserProfileToDB {
                getuserProfile=user_profile
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
        print("     display name is \(getuserProfile?.displayName)")
        return getuserProfile!
    }*/


    func getLikedMovies(userId: String, user_profile: UserProfileToDB) {
        let mapper = AWSDynamoDBObjectMapper.default()
        mapper.load(UserProfileToDB.self, hashKey: userId, rangeKey: nil).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            } else if let user_profile_temp = task.result as? UserProfileToDB {
                print("get: HERE ARE THE LIKED MOVIES")
                user_profile.currentLikedMovie = user_profile_temp.currentLikedMovie
                print(user_profile.currentLikedMovie.description)
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            return nil
        })
    }
    
}
