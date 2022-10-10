//////////////////////////////////////// votaciones ////////////////////////////////////////// 

// "SPDX-License-Identifier: MIT"
pragma solidity ^0.8.0;
// Contrato de votaciones
    // registrar candidatos
    // persmiso a alguien de votar
    // votar
    

    // Posibles Mejoras 
    // crear multiples votaciones
    // pasar los candidatos por argumentos del constructor
    // agregar un token ERC20 como el derecho a votar (Recordando que los ERC20 son solo balances) y una vez que vote, quemar ese ERC20 del votante
    // añadir un tiempo final para votar como en la vida real de las 6 de la tarde de determinado día

contract Votes{
    // variables
    uint256 totalVotos;
    address owner;

  struct Candidato{
        uint id;
        string nombre;
        uint256 votos;
    }

    Candidato public canditato1 = Candidato({
        id: 1,
        nombre: "Mauricio Pinon",
        votos: 0
    });

    Candidato public canditato2 = Candidato({
        id: 2,
        nombre: "Robert Carrichi",
        votos: 0
    });

    struct Votante{
        bool voto;
        bool puedeVotar;
    }

    mapping(address => Votante) vota;

    modifier validarOwner{
        require(msg.sender==owner, "Tu no eres el INE Dex ");
        _;
        
    } 
    constructor(){
        owner=msg.sender;
    }
     
      function permisoVotar(address _Votante) public validarOwner() {
       require(!vota[_Votante].puedeVotar, "ya tienes derecho a votar");
        vota[_Votante].puedeVotar= true;

    }

   
         // funciones
    // darle permiso a laguien de votar - (Solo el INE DEX puede ejecutar)
   
      // votar - solo la ejecutan los votantes con permiso
    function votar(uint256 _candidato) public {
       require(vota[msg.sender].puedeVotar, "No tienes derecho a votar");
       require(vota[msg.sender].voto, " No puedes volver a votar");

        vota[msg.sender].voto=true;
        totalVotos +=1;

        if(_candidato == 1){
            // votas por mau
            canditato1.votos += 1;
        } else{
            // carrichi
            canditato2.votos += 1;
        }

    } 

  


}