//
//  EditProfileViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2021/01/09.
//

import UIKit
import Photos

class EditProfileViewController: UIViewController  {
    
    @IBOutlet weak var profileImage: UIImageView!
    var profileViewModel = ProfileViewModel()
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    var profile: Profile?
    @IBOutlet var collectionOfButtons: Array<UIButton>?

    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()
    
// [TODO] 키보드처리(글로벌로빼기)
    
    @IBOutlet weak var nickNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  profileViewModel.fetchProfile()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        setUpUI()
  
    }
    
    @IBAction func tapColor(_ sender: UIButton) {
        switch sender.tag {
        case 0: profileViewModel.updateColor(.BurntCoral)
        case 1: profileViewModel.updateColor(.marigold)
        case 2: profileViewModel.updateColor(.greenAsh)
        case 3: profileViewModel.updateColor(.coraulean)
        default: break;
        }
        collectionOfButtons?[sender.tag].showsTouchWhenHighlighted = true
        
    }
    @IBAction func tapBG(_ sender: Any) {
        nickNameTF.resignFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        //[STUDY: Convert IMAGE TO View]
        profileViewModel.setUpProfile(nickName: nickNameTF.text ?? "0", profileImg: profileImage.image?.pngData() ?? Data())
        if let vc = presentingViewController as? TodoViewController {
            vc.fetchTasks()
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}



//MARK: ACTION EVENTS
extension EditProfileViewController {
    @IBAction func ImageButtonTapped(_ sender: Any) {
        checkPermission()
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            DispatchQueue.main.async {
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                print("\(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized{
                    DispatchQueue.main.async {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }
            }
        case .restricted:
            print("User do not have access to photo album")
        case .denied:
            print("User has denied the permission")
        default: break
        }
    }
    func setUpUI(){
        profileViewModel.fetchColor()
        self.profileImage.makeRounded()
        let fetchImage = profileViewModel.profile.last?.profileImg
        profileImage?.image = UIImage(data: fetchImage ?? Data() )
        nickNameTF.text = profileViewModel.profile.last?.nickName
        submitButton.backgroundColor = profileViewModel.color.rgb
    }
    
    @objc private func adjustInputView(noti: Notification) {
         guard let userInfo = noti.userInfo else { return }
         guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
         if noti.name == UIResponder.keyboardWillShowNotification {
              let adjustmentHeight = keyboardFrame.height -      view.safeAreaInsets.bottom
              inputViewBottom.constant = adjustmentHeight
         }
         else {
              inputViewBottom.constant = 0
         }
    }
}

















