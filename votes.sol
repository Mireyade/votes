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
    bool status; //TRUE if the voting process is still valid. FALSE if has already ended.

  struct Candidato{

        string nombre;
        uint id;
        uint256 votos;
    }

// A dynamically-sized array of `Candidato` structs.
Candidato[] public candidatos;

//Registro de candidatos
constructor(string[] memory _nombre) {
        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        owner= msg.sender;

        for (uint i = 0; i < _nombre.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            candidatos.push(Candidato({
                nombre: _nombre[i],
                id: i + 1,
                votos: 0
            }));
        }
    }


/*
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
*/
    struct Votante{
        bool voto;
        bool puedeVotar;
    }

    mapping(address => Votante) vota;

    modifier validarOwner{
        require(msg.sender==owner, "Tu no eres el INE Dex ");
        _;
        
    } 
     
      function permisoVotar(address _Votante) public validarOwner() {
       require(!vota[_Votante].puedeVotar, "Tu derecho a votar fue asignado previamente");
        vota[_Votante].puedeVotar= true;
        vota[_Votante].voto= false;

    }

   
         // funciones
    // darle permiso a laguien de votar - (Solo el INE DEX puede ejecutar)
   
// votar - solo la ejecutan los votantes con permiso
    function vote(uint _Candidato) external {
    Votante storage sender = vota[msg.sender];
        require(sender.puedeVotar, "No tienes derecho a votar");
        require(!sender.voto, " No puedes volver a votar");
        
        sender.puedeVotar = false;
        sender.voto = true;

        candidatos[_Candidato].votos += 1;

    }


//El conteo de votos se hace automático por medio de esta función:
function validarWinner() public view
            returns (uint winner)
    {
        uint conteoVotos = 0;
        for (uint counter = 0; counter < candidatos.length; counter++) {
            if (candidatos[counter].votos > conteoVotos) {
                conteoVotos = candidatos[counter].votos;
                winner = counter;
            }
        }
    }

  function ganadorAbsolutp() external view returns(string memory , address)         
    {
        string memory ganador;
        address contractAddress= address(this);
        ganador = candidatos[validarWinner()].nombre;

        return (ganador, contractAddress);
    }


 /*   function votar(uint256 _candidato) public {
       require(vota[msg.sender].puedeVotar, "No tienes derecho a votar");
       require(!vota[msg.sender].voto, " No puedes volver a votar");
       

        vota[msg.sender].voto=true;
        totalVotos +=1;

        if(_candidato == 1){
            // votas por mau
            canditato1.votos += 1;
        } else{
            // carrichi
            canditato2.votos += 1;
        }

    } */

  


}