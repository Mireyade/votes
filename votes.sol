//////////////////////////////////////// votaciones ////////////////////////////////////////// 

// "SPDX-License-Identifier: MIT"
pragma solidity ^0.8.0;

contract Votes{

    uint256 totalVotos;
    address owner;
    uint public time = block.timestamp; // Get the time when the contract started

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

    struct Votante{
        bool voto;
        bool puedeVotar;
    }

    mapping(address => Votante) vota;

    modifier validarOwner{
        require(msg.sender==owner, "No eres el owner, no tienes permisos");
        _;
        
    } 

    //Función Permiso para votar (Sólo el owner puede ejecutar)
      function permisoVotar(address _Votante) public validarOwner() {
       require(!vota[_Votante].puedeVotar, "Tu derecho a votar ya fue asignado previamente");
        vota[_Votante].puedeVotar= true;
        vota[_Votante].voto= false;

    }

    //Función Votar (Sólo la ejecutan los votantes con permiso)
    function vote(uint _Candidato) external {
    Votante storage sender = vota[msg.sender];
        require(sender.puedeVotar, "No tienes derecho a votar");
        require(!sender.voto, " No puedes volver a votar");
        require(time == time + 60, "Las votaciones han finalizado"); //Se le suma cierto tiempo (en segundos) al momento en que inició el contrato
        
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

}