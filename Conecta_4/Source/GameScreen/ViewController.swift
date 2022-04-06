//
//  ViewController.swift
//  Conecta_4
//
//  Created by Oscar Perez on 3/17/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Level0StackView: UIStackView!
    @IBOutlet weak var contadorTxt: UILabel!
    @IBOutlet weak var imagePlayerOne: UIImageView!
    @IBOutlet weak var imagePlayerTwo: UIImageView!
    @IBOutlet weak var txtJugadorActual: UILabel!
    @IBOutlet weak var restartGameView: UIView!
    
    @IBOutlet weak var restarGameButton: UIImageView!
    @IBOutlet weak var restartCounterGameButton: UIImageView!
    
    
    let data = Array(0...7)
    var click:Int = 0;
    var usuarioActual:String = Settings.jugadorOne
    var conectaCuatro:ConectaCuatro = ConectaCuatro();
    var piezas:[[PiezaView]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intialization()
        FocusUserImage(playerID: Settings.jugadorOne)
        
        restartCounterGameButton.isUserInteractionEnabled = true;
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(restartCounterGameButtonClick(_:)))
        restartCounterGameButton.addGestureRecognizer(tapGestureRecognizer1)
        
        restarGameButton.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(restartGameButton(_:)))
        restarGameButton.addGestureRecognizer(tapGestureRecognizer)
        
    }
 
}

//MARK: Extension
extension ViewController{
      
    @objc func restartCounterGameButtonClick(_ sender:AnyObject){
        let refreshAlert = UIAlertController(title: "Reiniciar Contador de victorias", message: "El juego actual sera finalizado", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
            
            self.conectaCuatro.reiniciarContador()
            self.resetGameFun()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cencelar", style: .cancel, handler: { (action: UIAlertAction!) in
              print("El juego continua")
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    @objc func restartGameButton(_ sender:AnyObject){
        
        if(conectaCuatro.gameEnd){
            resetGameFun()
        }else{
            let refreshAlert = UIAlertController(title: "Reiniciar Juego Actual", message: "El juego actual sera finalizado", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { (action: UIAlertAction!) in
                    print("Vamos a reiniciar el juego")
                    self.resetGameFun()
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cencelar", style: .cancel, handler: { (action: UIAlertAction!) in
                  print("El juego continua")
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
        
    }
    
    //MARK: Reset Game
    func resetGameFun(){
        //reiniciamos el juego actual
        conectaCuatro.reiniciarJuego()
        //colocamos al usuario actual como el 1
        usuarioActual = Settings.jugadorOne
        FocusUserImage(playerID: Settings.jugadorOne)
        counterUpdate()
        for j in Array(0...(piezas.count-1)){
            for i in Array(0...(piezas[0].count-1)){
                //Colocando su color por defecto de la pieza
                piezas[j][i].initPiece()
                
            }
        }
    }
    
    //MARK:Update COUNTER
    func counterUpdate(){
        
        contadorTxt.text = "\(conectaCuatro.jugadorRojoVictorias) : \(conectaCuatro.jugadorAmarillasVictorias)"
    }

    //MARK: INITIALITION FUNCTION
    func intialization(){
        
        imagePlayerOne.backgroundColor = Colors.playerColorOne
        imagePlayerOne.layer.borderColor = UIColor.white.cgColor
        imagePlayerOne.layer.borderWidth = 5
        imagePlayerTwo.backgroundColor = Colors.playerColorTwo
        imagePlayerTwo.layer.borderColor = UIColor.white.cgColor
        imagePlayerTwo.layer.borderWidth = 5
        print(conectaCuatro.usuarioActual)
        txtJugadorActual.text = Settings.jugadorOneNombre
       
        Level0StackView.backgroundColor = .red
        counterUpdate()
        var i:Int = 0, j:Int = 0
        
        for  l0 in self.Level0StackView.subviews as [UIView]{
            if let vs = l0 as? UIStackView{
                //Empezamos a recorrer cada uno de los niveles para guardarlos en
                //la matriz
                var arreglo:[PiezaView] = []
                for v in vs.subviews{
                    if let view = v as? PiezaView{

                        view.initPiece(indexX: i, indexY: j)
                        //setting onclick event in PiezaView
                        view.setOnClickListener { [self] in
                            if (!conectaCuatro.gameEnd){
                                colocarPieza(view: view)
                            }
                            else{
                                print("El juego ya termino")
                            }
                        }
                        arreglo.append(view)
                        i += 1
                        
                    }
                }
                
                piezas.append(arreglo)
                arreglo = []
                i = 0
                j += 1
            }
        }
    }
    
    func colocarPieza(view: PiezaView){
        
        let positionY = self.conectaCuatro.colocarPieza(positionX: view.indexX, playerID: usuarioActual)
        self.piezas[positionY][view.indexX].changeColor(playerID: self.usuarioActual)
        //Cambiamos el jugador
        if(self.usuarioActual == Settings.jugadorOne){
            self.usuarioActual = Settings.jugadorTwo
            print(conectaCuatro.usuarioActual)
            txtJugadorActual.text = Settings.jugadorTwoNombre
            FocusUserImage(playerID: Settings.jugadorTwo)
        }else{
            self.usuarioActual = Settings.jugadorOne
            txtJugadorActual.text = Settings.jugadorOneNombre
            FocusUserImage(playerID: Settings.jugadorOne)
        }
        counterUpdate();
        if(conectaCuatro.gameEnd){
            let alert = UIAlertController(title: "Juego terminado", message: "GANADOR: \((conectaCuatro.ganador == Settings.jugadorOne) ? Settings.jugadorOneNombre:Settings.jugadorTwoNombre)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func FocusUserImage(playerID:String){
        
        let wBigger:CGFloat     = 10
        let cBigger:CGColor     = UIColor.yellow.cgColor
        let wSmaller:CGFloat    = 5
        let cSmaller:CGColor    = UIColor.white.cgColor
        let isPlayerOne:Bool    = (playerID == Settings.jugadorOne) ? true : false
        
        imagePlayerOne.layer.borderWidth = (isPlayerOne) ? wBigger : wSmaller
        imagePlayerOne.layer.borderColor = (isPlayerOne) ? cBigger : cSmaller
        imagePlayerTwo.layer.borderWidth = (!isPlayerOne) ? wBigger : wSmaller
        imagePlayerTwo.layer.borderColor = (!isPlayerOne) ? cBigger : cSmaller
        
    }

}
