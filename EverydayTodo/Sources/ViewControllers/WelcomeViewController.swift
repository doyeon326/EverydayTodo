//
//  WelcomeViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2021/01/17.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet var holderView: UIView!
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    private func configure() {
        
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        //set up scrollView
        let iconName = ["plus","hand.tap","switch.2","paintpalette"]
        let bgColor = [UIColor(red: 233/255.0, green: 137/255.0, blue: 126/255.0, alpha: 1), UIColor(red: 255/255.0, green: 173/255.0, blue: 74/255.0, alpha: 1), UIColor(red: 159/255.0, green: 219/255.0, blue: 173/255.0, alpha: 1), UIColor(red: 152/255.0, green: 180/255.0, blue: 216/255.0, alpha: 1)]
        let titles = ["Add your task to manage your daily schedule","Long press the task to edit or delete in one","Let us give you a notification of your task on time","Customize own theme color"]
        for x in 0..<4 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            //pageView.backgroundColor = bgColor[x]
            
            //Title, image, buttton
            let logo = UILabel(frame: CGRect(x: 44, y: 60, width: 300, height: 30))
            let iconImage = UIImageView(frame: CGRect(x: 44, y: logo.frame.height + 320, width: 85, height: 85))
            let label = UILabel(frame: CGRect(x: 44, y: iconImage.frame.height +  350, width: pageView.frame.size.width-88, height: 120))
            let button = UIButton(frame: CGRect(x: pageView.frame.width / 2 - 25, y: pageView.frame.size.height - 80, width: 50, height: 50))
      
            logo.text = "EverydayTodo"
            logo.textColor = UIColor.systemGray2
            logo.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            //pageView.addSubview(logo)
            
            
            let imagename = iconName[x]
            iconImage.image = UIImage(systemName: imagename)
            iconImage.contentMode = .scaleAspectFill
            iconImage.tintColor = bgColor[x]
            pageView.addSubview(iconImage)
            
            //label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
            //label.textColor = .systemGray
            label.numberOfLines = 4
            label.text = titles[x]
            pageView.addSubview(label)
            
        
            
           // button.setTitleColor(.white, for: .normal)
           // button.backgroundColor = .black
          //  button.setTitle("Continue", for: .normal)
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 50)
            let largeImage = UIImage(systemName: "chevron.right.circle.fill", withConfiguration: largeConfig)
            button.setImage(largeImage, for: .normal)
            button.tintColor = bgColor[x]
            
            if x == 3 {
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 50)
                let largeImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: largeConfig)
                button.setImage(largeImage, for: .normal)
            }
            button.addTarget((self), action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x+1
            pageView.addSubview(button)
        
        }
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * 4, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
    }
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 4 else {
            //dissmiss
            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        //scroll to next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
}
