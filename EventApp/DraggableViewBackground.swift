
import Foundation
import UIKit
import Firebase
import CoreLocation
//import AlamofireImage

class DraggableViewBackground: UIView, DraggableViewDelegate, CLLocationManagerDelegate {
    var exampleCardLabels: [String]!
    var allCards: [DraggableView]!
    
    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 420
    let CARD_WIDTH: CGFloat = 330
    
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    var emptyLabel: UILabel!
    var imageEvent: UIImage!
    var bgImage: UIImageView?
    var topLabel: UILabel!
    
    var ref: DatabaseReference!
    var userId: String!
    var photoList: [String]!
    var eventList: [Event]!
    var eventKeys: [String]!
    var interestedEvents: [String]!
    var notInterestedEvents: [String]!
    
    let locationManager = CLLocationManager()
    
    let eventsToEventDetails = "EventsToEventDetails"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        userId = user?.uid
        exampleCardLabels = []
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        eventList = []
        eventKeys = []
        interestedEvents = []
        notInterestedEvents = []
        photoList = ["http://www.sycamorelifestyle.com/wp-content/uploads/2016/09/night-gathering-with-friends-sycamore-woods-iowa-city.jpg",
                     "https://us.123rf.com/450wm/rawpixel/rawpixel1707/rawpixel170708225/81688417-diverse-friends-gathering-having-food-together.jpg?ver=6",
                     "https://cdn.thewirecutter.com/wp-content/uploads/2018/03/boardgamesforadults-2x1-7452.jpg",
                     "https://cdn.shopify.com/s/files/1/2206/4495/articles/ibiza-rocks-craig-david-2017_2048x.jpeg?v=1525358407",
                     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRur9cqs1QN8G0soVHsr8PWzMigV_pw7YV-sU4gJtlUQMcjeiNGcQ",
                     "https://media.phillyvoice.com/media/images/2518GameDayWingsDiBrunoBros.2e16d0ba.fill-735x490.png",
                     "https://d2ciprw05cjhos.cloudfront.net/files/v3/styles/gs_large/public/images/18/06/gettyimages-649155058.jpg?itok=Lhx5ciAR",
                     "https://images.unsplash.com/photo-1542323789-2bff6a0d95df?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e84f7a611351db52f4efe9f66923643e&auto=format&fit=crop&w=2253&q=80",
                     "https://images.unsplash.com/photo-1542317366-7902c90fd32a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=fb22145163b0e5611e16f34d0aec1722&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542382217702-61a6a6cd8383?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e43572816aa8623702afd1f416d48305&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542407424724-5426773d65a5?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=876b5b522f01bebd9228a62d8d29466d&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542387278-a96ec637c1f1?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e3a886f89c687a6a6335e0bf3a560a6d&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542397284385-6010376c5337?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=e972da38f4a2c1d39b4221c9e0c065c5&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542403209676-b48e139095c8?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=917e672e57e71e262461e26241a01d42&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542389134-ee23a1aa8e71?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2ad6121699a190f0f5f80df43634e508&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542389134-ee23a1aa8e71?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2ad6121699a190f0f5f80df43634e508&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542387960-f8197d82db42?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=506f8c0028082a62578caf66e45e338c&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542389882-faa2e207fd79?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6bf95b649fc5e227d7baff98e686a150&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542384781206-d07657226fe7?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ed86046d9523f56969b48457f2871a11&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542378974-5514c513e381?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=c72eb3fa54de10de4b65193564936970&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542377252-d90110471c2d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=5e2de91fa4a1993320354b01117cb90b&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542389266-f8b2d4f94e54?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6d79e71ad32e4d305b59bfb763606031&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542384701-9eaf70a33558?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=2e8afa63deabd10ac58ed3aa98519cf8&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542383189-2e843a3028cd?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=1b075d688ee00d563a99d46ef0fc352b&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542379521-3410aec637d1?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=ba115ad65237d18576a57f5cee417b2b&auto=format&fit=crop&w=800&q=60",
                     "https://images.unsplash.com/photo-1542361164-6c814a69fdc6?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=9b39c02dea18f0bd7abe552e17bd139b&auto=format&fit=crop&w=800&q=60"]
        self.populateInterestedEvents()
    }
    
    func setupView() -> Void {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        self.frame = CGRect(x: 0, y: 75, width: self.frame.width, height: self.frame.height)
        
        xButton = UIButton(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2 + 35, y: self.frame.size.height/2 + CARD_HEIGHT/2 + 10 - 75, width: 59, height: 59))
        xButton.setImage(UIImage(named: "xButton"), for: UIControlState())
        xButton.addTarget(self, action: #selector(DraggableViewBackground.swipeLeft), for: UIControlEvents.touchUpInside)
        
        checkButton = UIButton(frame: CGRect(x: self.frame.size.width/2 + CARD_WIDTH/2 - 85, y: self.frame.size.height/2 + CARD_HEIGHT/2 + 10 - 75, width: 59, height: 59))
        checkButton.setImage(UIImage(named: "checkButton"), for: UIControlState())
        checkButton.addTarget(self, action: #selector(DraggableViewBackground.swipeRight), for: UIControlEvents.touchUpInside)
        
        emptyLabel = UILabel(frame: CGRect(x: 0, y: 150, width: 250, height: 300))
        emptyLabel.text = "   No more events in your area \n\n            Check back later"
        emptyLabel.numberOfLines = 0
        emptyLabel.center.x = self.center.x
        
        self.addSubview(xButton)
        self.addSubview(checkButton)
        self.addSubview(emptyLabel)
    }
    
    func createDraggableViewWithDataAtIndex(_ index: NSInteger) -> DraggableView {
        let event = eventList[index]
        let draggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2 - 75, width: CARD_WIDTH, height: CARD_HEIGHT))
        draggableView.information.text = exampleCardLabels[index]
        draggableView.information.textRect(forBounds: CGRect(x: (self.frame.size.width - CARD_WIDTH)/2, y: (self.frame.size.height - CARD_HEIGHT)/2, width: CARD_WIDTH, height: CARD_HEIGHT), limitedToNumberOfLines: 2)
        let imageIndex = Int(arc4random_uniform(UInt32(self.photoList.count)))
        let imageUrlString = photoList[imageIndex]
        let imageUrl:URL = URL(string: imageUrlString)!
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData:Data = try! Data(contentsOf: imageUrl)
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.CARD_WIDTH, height: self.CARD_HEIGHT-100))
            //imageView.center = draggableView.center
            
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                imageView.image = image
                //imageView.contentMode = UIViewContentMode.scaleAspectFit
                draggableView.addSubview(imageView)
            }
        }
        draggableView.information.numberOfLines = 0
        draggableView.delegate = self
        return draggableView
    }
    
    func getEventObject() -> Event{
        if eventList.isEmpty{
            var no_event: Event
            no_event = Event(date:"",description:"",location:"",latitude:0.0,longitude:0.0,name: "no event nearby",startTime: "",endTime: "",entryFee: "",createdBy: "", imageUrl: "")
            return no_event
        }
        return eventList[0]
    }
    
    func populateInterestedEvents(){
        print("IN INTERESTED EVENTS")
        self.ref.child("users").child(userId).child("interested_events").observeSingleEvent(of: .value, with: { (snapshot)in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.interestedEvents.append(rest.value as! String)
            }
            self.populateNotInterestedEvents()
        })
        
    }
    
    func populateNotInterestedEvents(){
        print("IN NOT INTERESTED EVENTS")
        self.ref.child("users").child(userId).child("not_interested_events").observeSingleEvent(of: .value, with: { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.notInterestedEvents.append(rest.value as! String)
            }
            self.populateEvents()
        })
    }
    
    func populateEvents(){
        print("IN POPULATE EVENTS")
        ref.child("events").observeSingleEvent(of: .value, with: { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                //print(rest.key)
                //print("VALUE: \(rest.value)")
                let event = Event(snapshot: rest)
                let currentDate = NSDate()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                var day = "01"
                var month = "01"
                var year = "1400"
                let eDate = event.date
                if eDate.count == 10 {
                    var start = eDate.index(eDate.startIndex, offsetBy: 0)
                    var end = eDate.index(eDate.startIndex, offsetBy: 2)
                    var range = start..<end
                    month = String(eDate[range])
                    start = eDate.index(eDate.startIndex, offsetBy: 3)
                    end = eDate.index(eDate.startIndex, offsetBy: 5)
                    range = start..<end
                    day = String(eDate[range])
                    start = eDate.index(eDate.startIndex, offsetBy: 6)
                    end = eDate.index(eDate.startIndex, offsetBy: 10)
                    range = start..<end
                    year = String(eDate[range])
                }
                let dateStr = year+"-"+month+"-"+day
                let dateEvent = dateFormatter.date(from: dateStr)
                let lat = event.latitude
                let lng = event.longitude
                print("LATITUDE: \(lat) LONGITUDE: \(lng)")
                var currentLoc = self.getCurrentLocation()
                let dist = self.getDistanceBetweenLocations(lat1: lat, lng1: lng, lat2: currentLoc[0], lng2: currentLoc[1])
                print("DATE is later: \(currentDate.compare(dateEvent!) != ComparisonResult.orderedDescending)")
                print("DISTANCE: \(dist)")
                if !self.notInterestedEvents.contains(rest.key) && !self.interestedEvents.contains(rest.key)
                    && dist < 50 {
                        self.eventList.append(event)
                        self.eventKeys.append(rest.key)
                        self.exampleCardLabels.append(event.toString())
                }
                
            }
            
            print("COUNT: \(self.eventList.count)")
            for e in self.eventList {
                print("NAME: \(e.name)")
            }

            self.loadCards()
            
        })
        
    }
    
    func getCurrentLocation() -> Array<Double>{
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()


        let location = self.locationManager.location

        let latitude: Double = location!.coordinate.latitude
        let longitude: Double = location!.coordinate.longitude

        return [latitude,longitude]
    }
    
    func getDistanceBetweenLocations(lat1:Double, lng1:Double, lat2:Double, lng2:Double) -> Double{
        let coordinate1 = CLLocation(latitude: lat1, longitude: lng1)
        let coordinate2 = CLLocation(latitude: lat2, longitude: lng2)
        let distanceInMeters = coordinate1.distance(from: coordinate2)
        return distanceInMeters*0.000621371
    }


    
    func loadCards() -> Void {
        print("IN LOAD CARDS")
        if exampleCardLabels.count > 0 {
            let numLoadedCardsCap = exampleCardLabels.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : exampleCardLabels.count
            for i in 0 ..< exampleCardLabels.count {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            for i in 0 ..< loadedCards.count {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
            
        }
        
    }
    
    
    func cardSwipedLeft(_ card: UIView) -> Void {
        loadedCards.remove(at: 0)
        eventList.remove(at: 0)
        let key = eventKeys.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
        
        self.ref.child("users").child(userId).child("not_interested_events").childByAutoId().setValue(key)
    }
    
    func cardSwipedRight(_ card: UIView) -> Void {
        loadedCards.remove(at: 0)
        eventList.remove(at: 0)
        let key = eventKeys.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[MAX_BUFFER_SIZE - 2])
        }
        
        self.ref.child("users").child(userId).child("interested_events").childByAutoId().setValue(key)
    }
    
    @objc func swipeRight() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeRight)
        UIView.animate(withDuration: 0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.rightClickAction()
    }
    
    @objc func swipeLeft() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.ggOverlayViewModeLeft)
        UIView.animate(withDuration: 0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.leftClickAction()
    }
}
