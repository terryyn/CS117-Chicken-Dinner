
import UIKit
import Firebase
import CoreLocation

class AddEventViewController: UIViewController {
    
    var ref: DatabaseReference!
    var userId: String!
    
    @IBAction func Back(_ sender: Any) {
    }
    let addEventToEvents = "AddEventToEvents"
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        let user = Auth.auth().currentUser
        userId = user?.uid
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitEvent(_ sender: UIButton) {
        let eventName = name.text
        let eventStartTime = startTime.text
        let eventEndTime = endTime.text
        let eventAddress = address.text
        let eventDate = date.text
        let eventPrice = price.text
        let eDescription = eventDescription.text
        var eventLatitude:Double = 0
        var eventLongitude:Double = 0
        let defaultUrl = "https://firebasestorage.googleapis.com/v0/b/eventsapp-5e226.appspot.com/o/ACLImage.jpg?alt=media&token=d36e620c-f495-4e6b-b478-f863aae6cfe3"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(eventAddress!) { (placemarks, error) in
            if error != nil {
                let alert = UIAlertController(title: "Address Error", message: "Please Enter a Proper Address", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinates = placemarks.first!.location
                    let lat = (coordinates?.coordinate.latitude)!
                    let lng = (coordinates?.coordinate.longitude)!
                    eventLatitude = lat
                    eventLongitude = lng
                    print("LATITUDE: \(lat) LONGITUDE: \(lng)")
                    let event = Event(date: eventDate!,description: eDescription!,location: eventAddress!, latitude: eventLatitude, longitude: eventLongitude, name: eventName!,startTime: eventStartTime!,endTime: eventEndTime!,entryFee: eventPrice!,createdBy: self.userId, imageUrl: defaultUrl)
                    self.ref.child("events").childByAutoId().setValue(event.toAnyObject())
                    self.performSegue(withIdentifier: self.addEventToEvents, sender: nil)
                }
            }
        }
        
    }
    
    
}


