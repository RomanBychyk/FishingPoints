//
//  ViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 28.03.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let segueIdentifier = "pointsSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
        
        //решение проблемы с наезжающей клавиатурой
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        warningLabel.alpha = 0
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
   
    //создание методов, по которым мы сделали селекторы в обсерверах
    /*в качестве передаваемого параметра Notification, потому что в нем и хранится информация о размере клавиатуры */
    @objc func kbDidShow (notification: Notification){
        //необходимо извлечь словарик с информацией нашей нотификации, но он может быть нилом, поэтому делаем это безопасно
        guard let userInfo = notification.userInfo else { return }
        //находим размер клавиатуры
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue //кастим, потому что приходит в Any
        //и увеличиваем размер высоты вьюшки на размер высоты клавиатуры
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + kbFrameSize.height)
        //для того чтобы индикатор скролла не заезжал под клавиатуру, то надо поправить область его отображения
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    //здесь нам размер не нужен, так как здесь все возвращается в первоначальное положение
    @objc func kbDidHide () {
        //возвращаем назад размер вьюшки без клавиатуры
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "You need to enter email and password")
                                return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error != nil {
                self?.displayWarningLabel(withText: "Error occured")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: "pointsSegue", sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "No such user")
        }
        
    }
    
    func displayWarningLabel (withText text: String) {
        warningLabel.text = text
        UIView.animate(withDuration: 10, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {[weak self] in
            self?.warningLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "You need to enter email and password")
                                return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in

            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                return
            }
        }
    }
}

