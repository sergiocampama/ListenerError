import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

import UIKit

class ViewController: UIViewController {

  private let button: UIButton = {
    let button = UIButton(type: .roundedRect)
    button.setTitle("Run stuff", for: .normal)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(button)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    FirebaseApp.configure()
    let settings = FirestoreSettings()
    settings.dispatchQueue = DispatchQueue.init(label: "test")
    Firestore.firestore().settings = settings
    Firestore.enableLogging(true)
    startListening()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    button.sizeToFit()
    button.center = view.center
  }

  @objc func buttonTapped() {
    print("terminating firestore")
    Firestore.firestore().terminate() { error in
      print("firestore terminated", error)
    }
  }

  func startListening() {
    var listeners = [Int: ListenerRegistration]()

    Firestore.firestore().collection("changes").addSnapshotListener { snapshot, error in
      usleep(5)
      print("got difs", snapshot?.documentChanges.count)
      let id = snapshot?.documentChanges.first?.document.documentID ?? "n/a"

      for index in 0..<4000 {
        let documentListener = Firestore.firestore().collection("changes").document("doc_\(index)").addSnapshotListener { documentSnapshot, error in
          print("__kp doc", documentSnapshot)
        }

        listeners[index]?.remove()
        listeners[index] = documentListener
      }
    }

    for index in 0..<4000 {
      let documentListener = Firestore.firestore().collection("changes").document("doc_\(index)").addSnapshotListener { documentSnapshot, error in
        print("__kp doc", documentSnapshot)
      }

      listeners[index]?.remove()
      listeners[index] = documentListener
    }
  }
}

