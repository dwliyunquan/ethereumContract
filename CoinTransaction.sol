pragma solidity ^0.4.18;

contract CoinTransaction {

    mapping (address => uint) balances;
    
    address public contractuser;

    uint public orderNumber;
    
    uint public dealOrderNumber;

    struct  DealOrder  {
        uint orderId;
        address sellTrader;
        address buyTrader;
        uint volume;   
        uint transactionTime;
    }
    
    struct Order {
        uint orderId;
        address trader;
        uint direction;
        uint quantity;
        uint volume;   
        uint nodealVolume;
        uint status; 
        uint transactionTime;
    }
    
    ///未成交单
    Order[] public nodealorders;
    
    ///订单
    Order[] public orders;
    
    ///成交单 
    DealOrder[] public dealorders;
    
    function CoinTransaction() public {
        contractuser=msg.sender;
        balances[msg.sender]=0;
        orderNumber = 1;
        dealOrderNumber=1;
    }
    
    function pushOrder(address traderaddress,uint direction, uint quantity) public{
       
        orders.push(Order({
                orderId: orderNumber,
                trader: traderaddress,
                direction:direction,
                quantity:quantity,
                volume:0,
                nodealVolume:quantity,
                status:0,
                transactionTime:now
            }));
            
        nodealorders.push(Order({
                orderId: orderNumber,
                trader: traderaddress,
                direction:direction,
                quantity:quantity,
                volume:0,
                nodealVolume:quantity,
                status:0,
                transactionTime:now
            }));
            
       balances[contractuser] += quantity;
       orderNumber+=1;
 
    }
    
    function trade(uint buyorderId,uint sellorderId) public{
        
        uint buyIndex=buyorderId-1;
        uint sellIndex=sellorderId-1;
        
        if(orders[buyIndex].direction!=1 || orders[buyIndex].status==1)
          revert();
          
        if(orders[sellIndex].direction!=2 || orders[sellIndex].status==1)
          revert();
        
        uint dealVolume=0;
        
        if(orders[buyIndex].nodealVolume>orders[sellIndex].nodealVolume)
        {
            dealVolume=orders[sellIndex].nodealVolume;
            
            orders[buyIndex].volume+=orders[sellIndex].nodealVolume;
            orders[buyIndex].nodealVolume=orders[buyIndex].quantity-orders[buyIndex].volume;
            orders[buyIndex].status=2;
            
            orders[sellIndex].volume+=orders[sellIndex].quantity;
            orders[sellIndex].nodealVolume=0;
            orders[sellIndex].status=1;
        }
        
        if(orders[buyIndex].nodealVolume<orders[sellIndex].nodealVolume)
        {
            dealVolume=orders[buyIndex].nodealVolume;
            
            orders[buyIndex].volume=orders[buyIndex].quantity;
            orders[buyIndex].nodealVolume=0;
            orders[buyIndex].status=1;
            
            orders[sellIndex].volume+=orders[buyIndex].nodealVolume;
            orders[sellIndex].nodealVolume=orders[sellIndex].quantity-orders[sellIndex].volume;
            orders[sellIndex].status=2;          
        }
        
        if(orders[buyIndex].nodealVolume==orders[sellIndex].nodealVolume)
        {
            dealVolume=orders[buyIndex].nodealVolume;
            
            orders[buyIndex].volume = orders[buyIndex].quantity;
            orders[buyIndex].nodealVolume = 0;
            orders[buyIndex].status = 1;
            
            orders[sellIndex].volume = orders[sellIndex].quantity;
            orders[sellIndex].nodealVolume = 0;
            orders[sellIndex].status = 1;          
        }
        
        
        dealorders.push(DealOrder({
                orderId: dealOrderNumber,
                sellTrader: orders[sellIndex].trader,
                buyTrader:orders[buyIndex].trader,
                volume:dealVolume,
                transactionTime:now
        }));
        
        dealOrderNumber+=1;
    }
    
    
    
}