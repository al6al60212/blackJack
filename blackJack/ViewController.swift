//
//  ViewController.swift
//  blackJack
//
//  Created by 董禾翊 on 2022/10/7.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playerMoneyLable: UILabel!
    @IBOutlet weak var betLable: UILabel!
    @IBOutlet weak var bankerTotalPoint: UILabel!
    @IBOutlet weak var playerTotalPoint: UILabel!
    @IBOutlet var bankerViews: [UIImageView]!
    @IBOutlet var playerViews: [UIImageView]!
    @IBOutlet weak var betConfirmBtn: UIButton!
    @IBOutlet weak var allInBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet var chipBtns: [UIButton]!
    //賭金
    var bet = Int()
    //玩家本金
    var playerMoney = Int()
    //儲存牌的陣列
    var Cards = [Card]()
    let suits = ["♣️", "♦️", "♥️", "♠️"]
    let points = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    //卡牌序號
    var cardIndex = 3
    //ImageView序號
    var bankerCardViewIndex = 1
    var playerCardViewIndex = 1
    //用來儲存判斷卡牌得到的點數
    var point = 0
    //玩家總點數
    var playerPoint = 0
    //莊家總點數
    var bankerPoint = 0
    //分別計算玩家和莊家Ace的數量
    var playerAceCount = 0
    var bankerAceCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //產生52張牌
        for suit in suits {
            for point in points {
                let card = Card(suit: suit, point: point)
                Cards.append(card)
            }
        }
        Cards.shuffle()
        bet = 0
        betLable.text = "賭注：\(bet)"
        playerMoney = 3000
        playerMoneyLable.text = "本金：\(playerMoney)"
        controlBtn(a: true, b: false)
    }
    //重新一局
    func newGame(){
        Cards.shuffle()
        bet = 0
        betLable.text = "賭注：\(bet)"
        controlBtn(a: true, b: false)
        cardIndex = 3
        bankerCardViewIndex = 1
        playerCardViewIndex = 1
        bankerPoint = 0
        bankerTotalPoint.text = ""
        playerPoint = 0
        playerTotalPoint.text = ""
        playerAceCount = 0
        bankerAceCount = 0
        for i in 0...4{
            bankerViews[i].image = nil
            playerViews[i].image = nil
        }
    }
    //加入Alert
    func addAlert(title: String, message: String, btnTitle:String){
        //玩家破產時
        if playerMoney == 0{
            let alert = UIAlertController(title: "輸到家了！", message: "小賭怡情，大賭傷身～", preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "轉身離去", style: .cancel){_ in
                exit(0)
            }
            
            alert.addAction(cancel)
            
            let action = UIAlertAction(title: "借錢翻本", style: .destructive){_ in
                self.playerMoney = 3000
                self.playerMoneyLable.text = "\(self.playerMoney)"
                self.newGame()
            }
            
            alert.addAction(action)
            present(alert, animated: true)
        }else{
            //玩家未破產，繼續玩
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "OK", style: .default){_ in
                self.newGame()
            }
            
            alert.addAction(action)
            present(alert, animated: true)
        }
        
    }
    
    //控制按鈕
    func controlBtn(a: Bool, b: Bool){
        betConfirmBtn.isEnabled = a
        allInBtn.isEnabled = a
        cancelBtn.isEnabled = a
        for chip in 0...2{
            chipBtns[chip].isEnabled = a
        }
        callBtn.isEnabled = b
        stopBtn.isEnabled = b
    }
    
    
    //押注確認後即開始發牌
    @IBAction func betConfirm(_ sender: Any) {
        //判斷賭金不等於0時執行
        if bet != 0 {
            playerMoney -= bet
            playerMoneyLable.text = "本金：\(playerMoney)"
            controlBtn(a: false, b: true)
            //各發第一張牌
            bankerViews[0].image = UIImage(named: "cardBack")
            playerViews[0].image = UIImage(named: Cards[1].suit + Cards[1].point)
            //各發第二張牌
            bankerViews[1].image = UIImage(named: Cards[2].suit + Cards[2].point)
            playerViews[1].image = UIImage(named: Cards[3].suit + Cards[3].point)
            
            //計算玩家點數
            switch Cards[1].point{
                case "A":
                    if playerPoint < 11{
                        point = 11
                        playerAceCount += 1
                    }else{
                        point = 1
                    }
                case "J", "Q", "K":
                    point = 10
                default:
                    point = Int(Cards[1].point)!
            }
            playerPoint += point
            
            switch Cards[3].point{
                case "A":
                    if playerPoint < 11{
                        point = 11
                        playerAceCount += 1
                    }else{
                        point = 1
                    }
                case "J", "Q", "K":
                    point = 10
                default:
                    point = Int(Cards[3].point)!
            }
            playerPoint += point
            
            playerTotalPoint.text = "\(playerPoint)"
            
            //計算莊家點數
            switch Cards[2].point{
                case "A":
                    if bankerPoint < 11{
                        point = 11
                        bankerAceCount += 1
                    }else{
                        point = 1
                    }
                case "J", "Q", "K":
                    point = 10
                default:
                    point = Int(Cards[2].point)!
            }
            
            bankerPoint += point
            bankerTotalPoint.text = "\(bankerPoint)"
            
            switch Cards[0].point{
                case "A":
                    if bankerPoint < 11{
                        point = 11
                        bankerAceCount += 1
                    }else{
                        point = 1
                    }
                case "J", "Q", "K":
                    point = 10
                default:
                    point = Int(Cards[0].point)!
            }
            
            bankerPoint += point
            //到這邊其實已經把莊家點數算出來了，但只先顯示明牌的點數
            
            //判斷是否有Black Jack的情況
            if playerPoint == 21 ,bankerPoint == 21{
                bankerViews[0].image = UIImage(named: Cards[0].suit + Cards[0].point)
                bankerTotalPoint.text = "\(bankerPoint)"
                playerMoney += bet
                playerMoneyLable.text = "本金：\(playerMoney)"
                addAlert(title: "Black Jack平手！", message: "玩了個寂寞～", btnTitle: "OK")
                
            }else if bankerPoint == 21 {
                bankerViews[0].image = UIImage(named: Cards[0].suit + Cards[0].point)
                bankerTotalPoint.text = "\(bankerPoint)"
                addAlert(title: "哎呀！", message: "莊家Black Jack，輸了\(bet)", btnTitle: "OK")
                
            }else if playerPoint == 21 {
                bankerViews[0].image = UIImage(named: Cards[0].suit + Cards[0].point)
                bankerTotalPoint.text = "\(bankerPoint)"
                bet *= 3
                playerMoney += bet
                playerMoneyLable.text = "本金：\(playerMoney)"
                addAlert(title: "恭喜！", message: "Black Jack,獎金2倍", btnTitle: "OK")
                
            }
        }
            
    }
        
        
    //All In
    @IBAction func allIn(_ sender: Any) {
        bet = playerMoney
        betLable.text = "賭注：\(bet)"
    }
    
    //取消按鈕，用於下錯籌碼
    @IBAction func cancel(_ sender: Any) {
        bet = 0
        betLable.text = "賭注：\(bet)"
    }
    
    //叫牌
    @IBAction func call(_ sender: Any) {
        playerCardViewIndex += 1
        cardIndex += 1
        playerViews[playerCardViewIndex].image = UIImage(named: Cards[cardIndex].suit + Cards[cardIndex].point)
        
        switch Cards[cardIndex].point{
            case "A":
                if playerPoint < 11{
                    //如果Ace作為11點，Ace數+1
                    point = 11
                    playerAceCount += 1
                }else{
                    point = 1
                }
            case "J", "Q", "K":
                point = 10
            default:
                point = Int(Cards[cardIndex].point)!
        }
        //計算分數和有無Ace，有Ace且加分數會爆牌的話，扣回10分
        if playerPoint + point > 21, playerAceCount == 1{
            playerPoint = playerPoint + point - 10
            //扣10分同時把Ace數量-1
            playerAceCount -= 1
        }else{
            playerPoint += point
        }
        playerTotalPoint.text = "\(playerPoint)"
        
        
        if playerCardViewIndex == 4,playerPoint <= 21{
            //顯示alert過五關
            bet *= 4
            playerMoney += bet
            playerMoneyLable.text = "本金：\(playerMoney)"
            addAlert(title: "恭喜！", message: "過五關，獎金3倍", btnTitle: "OK")
            
            
            
        }else if playerPoint > 21{
            //顯示Alert爆掉了
            bankerViews[0].image = UIImage(named: Cards[0].suit + Cards[0].point)
            bankerTotalPoint.text = "\(bankerPoint)"
            addAlert(title: "哎呀！", message: "爆掉了！輸了\(bet)", btnTitle: "OK")
            
        }
        
    }
    //停牌
    @IBAction func stop(_ sender: Any) {
        //先開莊家的暗排
        bankerViews[0].image = UIImage(named: Cards[0].suit + Cards[0].point)
        bankerTotalPoint.text = "\(bankerPoint)"
        //莊家<17，必須補牌
        while bankerPoint < 17, bankerCardViewIndex < 4 {
            bankerCardViewIndex += 1
            cardIndex += 1
            bankerViews[bankerCardViewIndex].image = UIImage(named: Cards[cardIndex].suit + Cards[cardIndex].point)
            
            switch Cards[cardIndex].point{
            case "A":
                if bankerPoint < 11{
                    point = 11
                    bankerAceCount += 1
                }else{
                    point = 1
                }
            case "J", "Q", "K":
                point = 10
            default:
                point = Int(Cards[cardIndex].point)!
            }
            
            if bankerPoint + point > 21, bankerAceCount == 1{
                bankerPoint = bankerPoint + point - 10
                bankerAceCount -= 1
            }else{
                bankerPoint += point
            }
            bankerTotalPoint.text = "\(bankerPoint)"
            
        }
            
            
        if bankerCardViewIndex == 4, bankerPoint <= 21 {
            addAlert(title: "哎呀！", message: "莊家過五關！輸了\(bet)", btnTitle: "OK")
        }else if bankerPoint > 21 {
            bet *= 2
            playerMoney += bet
            playerMoneyLable.text = "本金：\(playerMoney)"
            addAlert(title: "恭喜！", message: "莊家爆牌，贏了\(bet / 2)", btnTitle: "OK")
                
        }else if bankerPoint > playerPoint{
            addAlert(title: "可惜！", message: "莊家比你大，輸了\(bet)", btnTitle: "OK")
            
        }else if bankerPoint < playerPoint{
            bet *= 2
            playerMoney += bet
            playerMoneyLable.text = "本金：\(playerMoney)"
            addAlert(title: "恭喜！", message: "你比莊家大，贏了\(bet / 2)", btnTitle: "OK")
            
                
        }else if bankerPoint == playerPoint{
            playerMoney += bet
            playerMoneyLable.text = "本金：\(playerMoney)"
            addAlert(title: "平手！", message: "玩了個寂寞～", btnTitle: "OK")
            
        }
            
        
        
    }
    //籌碼按鈕
    @IBAction func chip(_ sender: UIButton) {
        if bet + sender.tag < playerMoney{
            bet += sender.tag
            betLable.text = "賭注：\(bet)"
        }else{
            bet = playerMoney
            betLable.text = "賭注：\(bet)"
        }
        
    }
    
}

