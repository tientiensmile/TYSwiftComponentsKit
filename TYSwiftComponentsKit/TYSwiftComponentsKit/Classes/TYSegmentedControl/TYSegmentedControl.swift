//
//  TYSegmentedControl.swift
//  TYSwiftComponentsKit
//
//  Created by Tienyun Wang on 2022/2/28.
//

import UIKit

/// 點擊標題按鈕協議
public protocol TYSegmentControlDelegate: AnyObject {
    
    /// 點擊時
    func didTap(index: Int, segment: TYCustomSegmentControl)

}

public class TYSegmentedControl: UIView {
    
    private weak var delegate: TYSegmentControlDelegate? = nil
    
    /// 按鈕們
    private var buttons: [UIButton] = []
    
    /// 標題文字
    private var titles: [String] = []
    
    /// 各按鈕的比例
    private var weights: [CGFloat] = []
    
    /// 外誆
    private lazy var borderView: UIView = UIView()
    
    /// 目前所在的index
    private(set) var currentIndex: Int = 0
 
    
    // MARK: - 背景相關屬性
    
    /// 圓角半徑
    var borderRadius: CGFloat = 6
    
    /// 被選中的顏色
    var selectedColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    /// 被選中的顏色
    var selectedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    /// 背景border顏色與未被選取的title顏色
    var unSelectedColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
    
    /// 選擇匡背景顏色
    var selectionViewBGColor: UIColor? = nil
    
    /// 按鈕文字大小
    var titleFontSize: CGFloat = 12
    
    /// 按鈕框框與背景間距
    var titleGap: CGFloat = 0
    
    /// 准許重複按鈕點擊
    var allowRepeatBtnClicked: Bool = false
    
    /// 初始化
    private func initialize(){
        for view in subviews {
            view.removeFromSuperview()
        }
        
        borderView.removeFromSuperview()
        
        buttons = []
        titles = []
        weights = []
        currentIndex = 0
    }
    
    
    // MARK: - 公開方法
    /// 設定代理
    ///
    /// - Parameters:
    ///   - delegate: 按鈕代理
    public func setDelegate(delegate: TYSegmentControlDelegate) {
        self.delegate = delegate
    }
    
    /// 設定按鈕
    ///
    /// - Parameters:
    ///   - titles: 按鈕的標題 由左到右
    ///   - weights: 按鈕的寬度比例 由左到右 若與標題數量不合 會自動補1
    public func setup(titles: [String], weightScales: [CGFloat]) {
        initialize()
        self.titles = titles
        var resutlWeights = weightScales
        
        if weightScales.count < titles.count {
            let diff = titles.count - weightScales.count
            for _ in 0..<diff {
                resutlWeights.append(1)
            }
        }
        
        // 重新計算百分比 讓其加總為1
        var sum: CGFloat = 0
        for weight in resutlWeights {
            sum += weight
        }
        
        if sum == 0 {
            return
        }
        
        resutlWeights = resutlWeights.map{
            bounds.width * $0 / sum
        }
        
        weights = resutlWeights
        setupView()
    }
    
    public func setStyle(borderColor: UIColor = .white, selectedTextColor: UIColor = .white , unSelectedTextColor: UIColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)) {
        self.selectedColor = borderColor
        self.selectedTextColor = selectedTextColor
        self.unSelectedColor = unSelectedTextColor
    }

    /// 設定按鈕預設寬度等寬
    ///
    /// - Parameter titles: 標題
    public func setup(titles: [String]){
        return setup(titles: titles, weightScales: titles.map{_ in 1})
    }
    
    /// 滾到到指定按鈕
    /// - Parameters:
    ///   - tag: 按鈕index
    ///   - animated: 是否動畫
    public func rollingToCurrentButton(tag: Int, animated: Bool = true) {
        currentIndex = tag
        setSelectedButton(tag: tag)
    }
    
    /// 設定外觀
    private func setupView(){
        if titles.count == 0 || weights.count == 0 {
            return
        }
        
        // 增加背景
        backgroundColor = .clear
        let backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = .clear
        backgroundView.layer.cornerRadius = borderRadius
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = unSelectedColor.cgColor
        addSubview(backgroundView)
        
        // 增加外部動畫匡
        let frame = CGRect(x: 0, y: 0, width: weights[0], height: bounds.height)
        let view = UILabel(frame: frame)
        view.layer.cornerRadius = self.borderRadius
        if let color = selectionViewBGColor {
            view.backgroundColor = color
            view.layer.cornerRadius = self.borderRadius
        } else {
            view.layer.borderWidth = 1.8
            view.layer.borderColor = self.selectedColor.cgColor
        }
        
        borderView = view
        addSubview(view)
        
        // 增加按鈕
        var currentBtnPos: CGFloat = 0
        for i in 0..<titles.count {
            let frame = CGRect(x: currentBtnPos, y: 0, width: self.weights[i], height: self.bounds.height)
            currentBtnPos += frame.width
            currentBtnPos += titleGap
            
            let btn = UIButton(frame: frame)
            btn.setTitle(titles[i], for: .normal)
            btn.setTitleColor(unSelectedColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize)
            btn.tag = i
            buttons.append(btn)
            addSubview(btn)
            btn.addTarget(self, action: #selector(buttonDidTapped(_ :)), for: .touchUpInside)
        }
        
        // 將第一個按鈕的title改為highlight color
        buttons.first?.setTitleColor(selectedTextColor, for: .normal)
    }
    
    // MARK: - 點擊事件
    /// 點擊標題按鈕
    @objc private func buttonDidTapped(_ sender: UIButton) {

        if currentIndex != sender.tag || allowRepeatBtnClicked == true {
            rollingToCurrentButton(tag: sender.tag)
            self.delegate?.didTap(index: sender.tag, segment: self)
        }

    }

    //// 設定選中的按鈕
    private func setSelectedButton(tag: Int, animated: Bool = true) {
        if self.weights.count == 0 {
            return
        }
        /// 控制顏色
        for i in 0..<buttons.count {
            if i == tag {
                buttons[i].setTitleColor(selectedTextColor, for: .normal)
            } else {
                buttons[i].setTitleColor(unSelectedColor, for: .normal)
            }
        }
        
      
        /// 控制外誆動畫
        //先計算位移
        var txp: CGFloat = 0
        var gap: CGFloat = 0
        for j in 0..<tag {
            gap += titleGap
            txp += weights[j]
        }

        // 計算大小變化比例
        let weight = weights[tag]
        /// 動畫
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}

            if animated {
                UIView.animate(withDuration: 0.2) {
                    // CGAffineTransform是作用于View的主要为2D变换
                    // a表示x水平方向的缩放，tx表示x水平方向的偏移
                    // d表示y垂直方向的缩放，ty表示y垂直方向的偏移
                    // 如果b和c不为零的话，那么视图肯定发生了旋转
                    self.borderView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: txp + gap, ty: 0)
                    self.borderView.frame.size.width = weight
                }
            } else {
                self.borderView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: txp + gap, ty: 0)
                self.borderView.frame.size.width = weight
            }
        }
        
    }
}
