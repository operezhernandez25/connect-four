//
//  ConectaCuatro.swift
//  Conecta_4
//
//  Created by Oscar Perez on 3/24/22.
//

import Foundation


class ConectaCuatro{
    
    var matriz:[[String]]
    var usuarioActual:String = Settings.jugadorOne
    var jugadorRojoVictorias:Int = 0
    var jugadorAmarillasVictorias:Int = 0
    var ganador:String = "";
    var gameEnd:Bool = false

    let fila = ["e","e","e","e","e","e","e"]
    
    init(){

        matriz = [
            fila,
            fila,
            fila,
            fila,
            fila,
            fila,
            fila
        ];
        
        
        
    }
    
    public func reiniciarJuego(){
        //Reiniciamos la matriz al estado inicial
        matriz = [
            fila,
            fila,
            fila,
            fila,
            fila,
            fila,
            fila
        ];
        ganador = ""
        gameEnd = false
        usuarioActual = Settings.jugadorOne
    }
    
    public func reiniciarContador(){
        jugadorRojoVictorias = 0
        jugadorAmarillasVictorias = 0
    }
    
    
    //Punto de entrada
    public func colocarPieza(positionX: Int, playerID: String) -> Int{
        var indexSetted:Int = -1;
        
        //Empezamos buscando en la matriz el registro mas bajo de esa coordenada.
        for (index,item) in matriz.reversed().enumerated(){
            if item[positionX] != "e"{
                print("Se encontro una pieza en la position [\(index)][\(positionX)]")
            }else{
                //Colocamos la pieza en la casilla seleccionada
                matriz[self.matriz.count-index-1][positionX] = playerID;
                //Guardamos la casilla para analizar si ya fue un Conecta4
                indexSetted = matriz.count-index-1
                break
            }
        }
        
        //Determinando Si existen piezas para completar el juego a partir de la pieza encontrada
        print("El index donde se coloco la pieza es verticalmente \(indexSetted)")
        let response = analizarPiezas(positionY: indexSetted, positionX: positionX)

        if(response){
            gameEnd = response;
            ganador = playerID;
            if(ganador == Settings.jugadorOne){
                jugadorRojoVictorias += 1
            }else{
                jugadorAmarillasVictorias += 1
            }
            print("Juego terminado gano el jugador: \(playerID)")
        }
        
        print("************")
        return indexSetted
    }



    public func analizarPiezas( positionY:Int, positionX: Int) -> Bool{
        //Declaracion de variables
        let estado:Bool = false;
        let playerID = matriz[positionY][positionX]
        let anchoArray = matriz[positionY].count - 1;
        let largoArray = matriz.count - 1;
        var coincidenciasVerticales:Int = 0;
        var conincidenciasHorizontales:Int = 0;
        var concidenciasDiagonales:Int = 0;
        

        print("<<<<<<<<<<<<")
        //Empezamos analizando horizontalmente
        //Buscamos para la izquierda
        for (index,item) in matriz[positionY].reversed().enumerated() {
           
            //Empezamos a analizar desde la posicion anterior a la pieza colocada
            if((anchoArray - index) < positionX)
            {
                
                print("Analizando al arreglo en la posicionY: \(positionY) posixionX: \(anchoArray - index) valor: \(item)")
                if( item != playerID){
                    print("La pieza en el indice \(anchoArray - index) no coincide.. La busqueda a la izquierda termina")
                    break
                }
                
                coincidenciasVerticales += 1;
                if(coincidenciasVerticales == 4){
                    break
                }
            }
            
        }
        print("Para la pieza [\(positionY)][\(positionX)] en la busqueda para la izquierda se encontraron: \(coincidenciasVerticales)")
        
        if(coincidenciasVerticales == 3){
            return true;
        }

        print(">>>>>>>>>>>>")
        //Busqueda a la derecha
        for(index,item) in matriz[positionY].enumerated(){
            if(index > positionX){
                print("Analizando al arreglo en la posicionY: \(positionY) posixionX: \(index) valor: \(item)")
                
                if(item != playerID){
                    print("La pieza en el indice \(item) no coincide.. La busqueda a la derecha termina")
                    break
                }
                
                coincidenciasVerticales += 1;
                if(coincidenciasVerticales == 3){
                    return true
                }
            }
        }
        print("Para la pieza [\(positionY)][\(positionX)] en la busqueda para la derecha se encontraron: \(coincidenciasVerticales)")
        
        
        /*
            EMPEZAMOS LA BUSQUEDA VERTICALMENTE
        */
        
        print("<Busqueda Vertical Para ABAJO>")
        for(item) in Array(0...largoArray){
            if(item > positionY ){
                if(matriz[item][positionX] != playerID){
                    break
                }
                conincidenciasHorizontales += 1
                if(conincidenciasHorizontales == 3){
                    return true
                }
            }
        }
        
        if(conincidenciasHorizontales == 3){
            return true;
        }
        
        /*
            EMPEZAMOS CON LA BUSQUEDA DIAGONAL
            PRIMER PASO: ARRIBA DERECHA.
         */
        
        //Cuando se coloca una pieza debemos buscar si existe a la derecha arriba de la pieza
        //una pieza del mismo juegador.
        var i:Int = 0
        print("<Busqueda Diagonal derecha-arriba>")
        for(item) in Array(0...anchoArray){
            if(item > positionX ){
                
                i += 1
                
              //  print("Analizando el registro \(positionX + i)")
                if((positionX + i) <= anchoArray && (positionY - i ) > 0){
                    if(matriz[positionY - i][positionX + i] != playerID){
                       break
                    }
                    print("Concidencia! \([positionY - i])\([positionX + i]) \(matriz[positionY - i][positionX + i])");
                    concidenciasDiagonales += 1;
                    if(concidenciasDiagonales == 3){
                        return true
                    }
                }
                
            }
        }
        i = 0;
        print("<Busqueda Diagonal Izquierda-ABAJO>")
        for(item) in Array(0...anchoArray){
            if(item < positionX){
                i += 1
                if((positionX - i) >= 0 && (positionY + i) < largoArray ){
                    if(matriz[positionY + i][positionX - i] != playerID){
                        break
                    }
                    concidenciasDiagonales += 1;
                    if(concidenciasDiagonales == 3){
                        return true
                    }
                }
            }
        }
        
        //reiniciamos las coincidenciasDiagonales
        concidenciasDiagonales = 0;
        print("<Busqueda Diagonal Derecha ABAJO>")
        i=0;
        for(item) in Array(0...anchoArray){
            if(item > positionX ){
                i += 1;
                if((positionX + i) <= anchoArray && (positionY + i ) <= largoArray){
                print("Analizando el registro [\(positionY + i)][\(positionX + i)]")
                    if(matriz[positionY + i][positionX + i] != playerID){
                       break
                    }
                    print("Concidencia! \([positionY + i])\([positionX + i]) \(matriz[positionY + i][positionX + i])");
                    concidenciasDiagonales += 1;
                    if(concidenciasDiagonales == 3){
                        return true
                    }
                }
            }
        }
        print("<Busqueda Diagonal Izquierda ARRIBA>")
        i = 0;
        for(item) in Array(0...anchoArray){
            if(item < positionX){
                i += 1;
                if((positionX - i) >= 0 && (positionY - i) >= 0){
                    if(matriz[positionY - i][positionX - i] != playerID){
                       break
                    }
                    print("Analizando el registro [\(positionX - i)][\(positionY - i)]")
                    concidenciasDiagonales += 1;
                    if(concidenciasDiagonales == 3){
                        return true
                    }
                }
            }
        }
        
        
        return estado;
    }
    
    private func updateCounter(playerID:String){
        if(playerID == Settings.jugadorOne){
            jugadorRojoVictorias += 1
        }else{
            jugadorAmarillasVictorias += 1
        }
    }
    
}
