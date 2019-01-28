//
//  ViewController.swift
//  Msg-Notification
//
//  Created by 윤성호 on 21/01/2019.
//  Copyright © 2019 윤성호. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var msg: UITextField!         // 알림 메시지
    @IBOutlet var datepicker: UIDatePicker! // 알림 날짜, 시간
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // save 버튼 이벤트
    @IBAction func save(_ sender: Any) {
        
        // 알림 설정 내용 확인 (Alert 알림)
        let setting = UIApplication.shared.currentUserNotificationSettings
        
        guard setting?.types != .none else {
            let alert = UIAlertController(title: "알림 등록", message: "알림이 허용되어 있지 않습니다.", preferredStyle: .alert
            )
            
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            
            self.present(alert, animated: false)
            return
        }
        
        if #available(iOS 10.0, *) { // UserNotifications 프레임워크를 사용한 로컬 알림

            // 알림 콘텐츠 정의
            let nContent = UNMutableNotificationContent()
            nContent.body = (self.msg.text)!
            nContent.title = "미리 알림"
            nContent.sound = UNNotificationSound.default

            // 발송 시간을 '지금으로 부터 *초 형식'으로 변환 (yyyy-MM-dd HH:mm => 지금으로 부터 *초 뒤)
            let time = self.datepicker.date.timeIntervalSinceNow

            // 발송 조건 정의
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)

            // 발송 요청 객체 정의
            let request = UNNotificationRequest(identifier: "alert", content: nContent, trigger: trigger)

            // 노티피케이션 센터에 추가
            UNUserNotificationCenter.current().add(request) {
                (_) in DispatchQueue.main.async {
                    // 발송 완료 안내 메시지
                    let date = self.datepicker.date.addingTimeInterval(9*60*60)
                    let message = "알림이 등록되었습니다. 등록된 알림은 \(date)에 발송됩니다"
                    
                    let alert = UIAlertController(title: "알림 등록", message: message, preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(ok)
                    
                    self.present(alert, animated: false)
                }
            }

        } else { // LocalNotification 객체를 사용한 로컬 알림


        }
        
    }
    
}

