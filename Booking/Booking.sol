// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HotelBooking { 
    // переменные
    uint256 public roomCost;
    address payable public owner;
    // статусы, ивенты, конструктор
    enum roomStatuses { // перечесление статусов 
        roomVacant, // 0 значение в enum
        roomOccupied // 1 значение в enum
    }

    roomStatuses currentRoomStatus;

    event OccupyRoom(address _potentialGuest, uint256 _value);

    constructor() {
        owner = payable(msg.sender);
        currentRoomStatus = roomStatuses.roomVacant;
    }
    // модификации
    modifier onlyWhileRoomVacant() {
        require(currentRoomStatus == roomStatuses.roomVacant,"Room is occupied");
        _;
    }

    modifier costOfRoom() {
        require(msg.value >= roomCost, "There is not enouth ETH in your wallet");
        _;
    }
    // функции
    function bookRoom() external payable onlyWhileRoomVacant costOfRoom {
        currentRoomStatus = roomStatuses.roomOccupied; // сделать статус комнаты - "Занята"
        owner.transfer(msg.value); // Переводим оплату владельцу
        emit OccupyRoom(msg.sender, msg.value); // эмитим ивент "ЗанятьКомнату"
    }

    function setRoomCost(uint256 _newRoomCost) external {
        require(msg.sender == owner, "Only the owner can set the room cost"); // Только владелец устанавливает ценуКомнаты
        roomCost = _newRoomCost;
    }

    function getCurrentRoomStatus() external view returns (roomStatuses) {  // возвращает статусКомнаты
        return currentRoomStatus;
    }
}

// Наследуем контракт букинга номеров для корректной работы msg.sender, owner

contract PlaneBooking is HotelBooking {
    // переменные
    uint256 public seatCost;
    // статусы,ивенты,конструктор
    enum seatStatuses { // перечесление статусов
        seatOccupied,
        seatVacant
    }

    seatStatuses currentSeatStatus; 

    event OccupySeat(address _seatOccupier, uint __value);
    constructor(uint256 _seatCost) HotelBooking() {
        seatCost = _seatCost;
        currentSeatStatus = seatStatuses.seatVacant;
        owner = payable(msg.sender);
    }
    // модификации
    modifier onlyWhileSeatVacant() {
        require(currentSeatStatus == seatStatuses.seatVacant, "Chosen seat has been already occupied");
        _;
    } 

    modifier costOfSeat() {
        require(msg.value >= seatCost, "There is not enough ETH in your wallet");
        _;
    }
    // функции
    function bookSeat() external payable onlyWhileSeatVacant costOfSeat {
        currentSeatStatus = seatStatuses.seatOccupied;
        owner.transfer(msg.value);
        emit OccupySeat(msg.sender, msg.value);
    }

    function setSeatCost(uint256 _newSeatCost) external {
        require(msg.sender == owner, "Only owner can set the seat cost");
        roomCost = _newSeatCost;
    }

    function getCurrentSeatStatus() external view returns (seatStatuses) {
        return currentSeatStatus;
    }
}