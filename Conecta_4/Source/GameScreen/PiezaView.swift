//
//  PiezaView.swift
//  Conecta_4
//
//  Created by Oscar Perez on 3/24/22.
//

import UIKit

class PiezaView: UIView {
    
     var indexX:Int = -1
     var indexY:Int = -1
    
    public func initPiece(indexX:Int,indexY:Int){
        self.indexX = indexX
        self.indexY = indexY
        self.layer.borderWidth = 5;
        self.layer.borderColor = UIColor.white.cgColor
        initPiece()
    }
    
    public func initPiece(){
        if(((indexX % 2) == 0 && (indexY % 2) != 0) || ((indexX % 2) != 0 && (indexY % 2) == 0)){
            self.backgroundColor = Colors.boardColorSB
        }else{
            self.backgroundColor = Colors.boardColorY
        }

    }
    
    public func changeColor(playerID:String){
        if(playerID == Settings.jugadorOne){
            self.backgroundColor = Colors.playerColorOne
        }else{
            self.backgroundColor = Colors.playerColorTwo
        }
    }
    
    
    func setOnClickListener(action :@escaping () -> Void){
          let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
          tapRecogniser.onClick = action
          self.addGestureRecognizer(tapRecogniser)
      }
      
      @objc func onViewClicked(sender: ClickListener) {
          if let onClick = sender.onClick {
              onClick()
          }
      }
    
}


class ClickListener: UITapGestureRecognizer {
     var onClick : (() -> Void)? = nil
    }
