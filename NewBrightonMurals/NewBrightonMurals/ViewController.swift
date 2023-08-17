//
//  ViewController.swift
//  NewBrightonMurals
//
//  Created by Joseph Dobos on 29/11/2022.
//

import UIKit
import MapKit
import CoreLocation

// this function converts a url into an image. Call UIimageview.load to use
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

//Variables to be used throughout

var selectedMurals = (Double(),"","","","","",URL(string: String()))
var muralTitle = " "
var array = [(Double, String, String, String, String, String,URL)]()
var sorted = [(muralDistance: Double, muralTitles:String, muralInfo:String, muralArtist:String, photoID: String, photoFileName:String, thumnail: URL)]()
var thumbnail = [URL]()
var lat = 0.00
var thumb = " "
var long = 0.00
var userLat = 0.0
var userLong = 0.0

let viewModel = MuralViewCell.self

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,
                      MKMapViewDelegate, CLLocationManagerDelegate {
    
    var report:BrightonMurals? = nil

    // MARK: Map & Location related stuff
    
    
    @IBOutlet weak var myMap: MKMapView!

    
    var locationManager = CLLocationManager()
    var firstRun = true
    var startTrackingTheUser = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0] //this method returns an array of locations
        //generally we always want the first one (usually there's only 1 anyway)
        let latitude = locationOfUser.coordinate.latitude
        userLat = Double(latitude)
        let longitude = locationOfUser.coordinate.longitude
        userLong = Double(longitude)
        //get the users location (latitude & longitude)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if firstRun {
            firstRun = false
            let latDelta: CLLocationDegrees = 0.0025
            let lonDelta: CLLocationDegrees = 0.0025
            //a span defines how large an area is depicted on the map.
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            
            //a region defines a centre and a size of area covered.
            let region = MKCoordinateRegion(center: location, span: span)
            
            //make the map show that region we just defined.
            self.myMap.setRegion(region, animated: true)
            
            //the following code is to prevent a bug which affects the zooming of the map to theuser's location.
            //We have to leave a little time after our initial setting of the map's location and span,
            //before we can start centering on the user's location, otherwise the map never zooms in because the
            //intial zoom level and span are applied to the setCenter( ) method call, rather than our "requested" ones,
            //once they have taken effect on the map.
            
            //we setup a timer to set our boolean to true in 5 seconds.
            _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:
                                        #selector(startUserTracking), userInfo: nil, repeats: false)
        }
        
        if startTrackingTheUser == true {
            myMap.setCenter(location, animated: true)
            nearestMural()
            
            
        }
        
    }
    
    //this method sets the startTrackingTheUser boolean class property to true. Once it's true,
    //subsequent calls to didUpdateLocations will cause the map to centre on the user's location.
    @objc func startUserTracking() {
        startTrackingTheUser = true
    }
    
    //MARK: Table related stuff
    
    

  
    //Counts the number of murals and sets this to the number of table rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = report?.newbrighton_murals.count ?? 0
        return count
    }
    
    
    @IBOutlet weak var myTable: UITableView!

    //Sets the UIimageView and label to the mural name and the thumbnail photo
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MuralViewCell
        cell.muralName.text = sorted[indexPath.row].muralTitles
        cell.muralImageView.load(url: sorted[indexPath.row].thumnail)
        return cell
    }
    
    // Performs a segue for when you click on the mural to get additional information
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMurals = sorted[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    
    // MARK: View related Stuff
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Make this view controller a delegate of the Location Manager, so that it
        //is able to call functions provided in this view controller.
        locationManager.delegate = self as CLLocationManagerDelegate
        
        //set the level of accuracy for the user's location.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //Ask the location manager to request authorisation from the user. Note that this
        //only happens once if the user selects the "when in use" option. If the user
        //denies access, then your app will not be provided with details of the user's
        //location.
        locationManager.requestWhenInUseAuthorization()
        
        //Once the user's location is being provided then ask for updates when the user
        //moves around.
        locationManager.startUpdatingLocation()
        
        //configure the map to show the user's location (with a blue dot).
        myMap.showsUserLocation = true
        
    
        // MARK: - JSONDecode
        //Decods the JSON data
        if let url = URL(string:"https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/nbm/data2.php?class=newbrighton_murals&lastModified=2022-09-15") {
            let session = URLSession.shared
            session.dataTask(with: url) { [self] (data, response, err) in
                guard let jsonData = data else {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let reportList = try decoder.decode(BrightonMurals.self, from: jsonData)
                    self.report = reportList
                    nearestMural()
                    DispatchQueue.main.async {
                        self.updateTheTable()
                        self.createAnnotations()
                    }
                    
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
            }.resume()
        }
        
    }
    
    //This function will update the table - used to update based on nearest mural
    func updateTheTable() {
        myTable.reloadData()
    }
    
    //This function creates the pins on the map
    func createAnnotations(){
        for aReport in report!.newbrighton_murals{
            let annotations = MKPointAnnotation()
             
            
            //force unwarpping the lat and the lon and sets to 0 if nil
            var dLat = 0.0
            var dLon = 0.0
            if let lat = aReport.lat {
                dLat = Double(lat) ?? 1.1
            }
        
            if let lon = aReport.lon {
                dLon = Double(lon) ?? 1.1
            }
            //sets the location and title of the annotation
            annotations.title = aReport.title ?? "No Title"
            annotations.coordinate = CLLocationCoordinate2D(latitude: dLat , longitude: dLon )
            myMap.addAnnotation(annotations)
         }
        
    }
    
        //This function calculates the distance from the user to the mural and orders an array of the mural information from closest to furthest away
    func nearestMural(){

        //Resets arrays to empty
        
        var array = [(Double, String, String, String, String, String,URL)]()
     
    
        for aReport in report!.newbrighton_murals{
            muralTitle = aReport.title ?? " "
            let userLoaction = CLLocation(latitude: userLat, longitude: userLong)
            
            //turns lat and lon into a a double and unwraps optional
            let lat = Double(aReport.lat ?? "0")
            let lon = Double(aReport.lon ?? "0")
            let muralLocation = CLLocation(latitude: lat ?? 0.0, longitude: lon ?? 0.0)
            //works out the distance of the user from the mural
            let muralDistance = userLoaction.distance(from: muralLocation)
            //sets variables and force unwraps
            let distanceDouble = Double(muralDistance)
            let info = aReport.info ?? "no info"
            let artist = aReport.artist ?? "no artist"
            //gets the data from the [Images] array in JSON data and sets them to a variable
            let photoId = aReport.images[0].id
            let photoFilename = aReport.images[0].filename
            let thumbs = aReport.thumbnail!
            //appends information about mural to tuple
            array.append((distanceDouble,muralTitle, info, artist, photoId, photoFilename,thumbs))
            
            
        }
        //Sorts the array based on the distance of mural
        sorted = array.sorted(by: {$0.0 < $1.0})
        
        //calls the update function 
        updateTheTable()

    }
    
    
    
    
}

