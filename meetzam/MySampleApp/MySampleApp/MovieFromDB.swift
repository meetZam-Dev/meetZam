//
//  MovieFromDB.swift
//  MySampleApp
//
//  Created by Ling Zhang on 2/27/17.
//
//

import Foundation
import AWSDynamoDB

let AWSDynamoDBTableName = "Movie2"//"meetzam-mobilehub-1569925313-Movie"
class SingleMovie : AWSDynamoDBObjectModel ,AWSDynamoDBModeling  {
    var movie_id: Int?
    var TMDB_movie_id: String?
    var Title: String?
    var TMDB_popularity: String?
    var release_date: String?
    var poster_path: String?
    var overview: String?
    
    class func dynamoDBTableName() -> String {
        return AWSDynamoDBTableName
    }
    
    class func hashKeyAttribute() -> String {
        return "TMDB_movie_id"
    }
    
    
    func getMovieForDisplay(key: String, movie_data: SingleMovie?, movieTitle: UILabel!, movieTitleDetailed: UILabel!, imageView: UIImageView!){
        print("     enter func getmovieForDisplay")
        /*let mapper = AWSDynamoDBObjectMapper.default()
         return mapper.load(UserProfileToDB.self, hashKey: key, rangeKey: email)*/
        let mapper = AWSDynamoDBObjectMapper.default()
        
        //print("userId is ", user_profile?.userId, separator: " ")
        //tableRow?.UserId --> (tableRow?.UserId)!
        mapper.load(SingleMovie.self, hashKey: key, rangeKey: nil) .continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            if let error = task.error as? NSError {
                print("Error: \(error)")
            } else if let movie_data = task.result as? SingleMovie {
                print("     Getting fields")
                movieTitle.text = movie_data.Title
                print(movieTitle.text)
                movieTitleDetailed.text = movie_data.overview
                print(movieTitleDetailed.text)
                //imgName = URL("https://image.tmdb.org/t/p/w500/" + movie_data.poster_path)
                let path = "https://image.tmdb.org/t/p/w500/" + movie_data.poster_path!
                let imageURL = URL(string: path)
                let imageData = try! Data(contentsOf: imageURL!)
                imageView.image = UIImage(data: imageData)
                
            }
            
            return nil
        })
    }/*
    func refreshList()  {
        
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBScanExpression()
        // queryExpression.exclusiveStartKey = self.lastEvaluatedKey
        //queryExpression.limit = 5
        
        dynamoDBObjectMapper.scan(SingleMovie.self, expression: queryExpression).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask!) -> AnyObject! in
            
            
            var cou = 0
            if let paginatedOutput = task.result {
                //let count = paginatedOutput.count as Int
                for item in paginatedOutput.items as! [SingleMovie] {
                    if item.TMDB_movie_id == nil || item.Title == nil {
                        //cou = cou + 1
                        continue
                    }
                    movie.appendWithPara(id: item.TMDB_movie_id!, title: item.Title!, pop: item.TMDB_popularity!, date: item.release_date!, path: item.poster_path!)
                    print("title: \(movie.tableRows[cou].Title)")
                    cou = cou + 1
                    
                }
                
                /*self.lastEvaluatedKey = paginatedOutput.lastEvaluatedKey
                 if paginatedOutput.lastEvaluatedKey == nil {
                 self.doneLoading = true
                 }
                 */
                
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            //self.tableView.reloadData()
            movie.doneLoading = true
            if let error = task.error as? NSError {
                print("Error: \(error)")
            }
            
            return nil
        })
        
    }*/

}
/*
class MovieList {
    var tableRows:Array = [SingleMovie]()
    var doneLoading:Bool = false
    
    func appendWithPara(id: String, title: String, pop: String, date: String, path: String) {
        let new_movie = SingleMovie()
        new_movie?.TMDB_movie_id = id
        new_movie?.Title = title
        new_movie?.release_date = date
        new_movie?.TMDB_popularity = pop
        new_movie?.poster_path = path
        self.tableRows.append(new_movie!)
   
    }
}
*/
