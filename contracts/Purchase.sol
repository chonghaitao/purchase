pragma solidity ^0.4.11;


contract Purchase {
    uint public value;
    address public buyer;
    address public seller;
    enum State { Created, Locked, Inactive }
    State public state;
    //mapping (address => uint) fromMap;


    event PurchaseConfirmed();
    event ItemReceived();
    event Aborted();

    modifier onlyBuyer {
        require(msg.sender == buyer);
        _;
    }

    modifier onlySeller {
        require(msg.sender == seller);
        _;
    }

    function Purchase() payable {
        seller = msg.sender;
        value = msg.value / 2;
        state = State.Created;
        require ((2 * value) == msg.value);
    }

    function confirmPurchase() payable {
        require(state == State.Created);
        require(msg.value == (2*value));
        buyer = msg.sender;
        state = State.Locked;
        PurchaseConfirmed();
    }

    function confirmReceived() onlyBuyer payable {
        require(state == State.Locked);
        state = State.Inactive;
        ItemReceived();
        buyer.transfer(value);
        seller.transfer(this.balance);
    }

    function abort() onlySeller payable {
        require(state == State.Created);
        state = State.Inactive;
        Aborted();
        seller.transfer(this.balance);
    }
}
