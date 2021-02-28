pragma solidity ^0.5.0;

import "./pupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate, // ether exchange rate
        address payable wallet, // sale beneficiary, address where funds are collected
        PupperCoin token, // the PupperCoin token itself 
        uint256 openingTime,
        uint256 closingTime,
        uint cap // max sale for crowdsale - 300 ETH for this homework -- this will also be set as the goal to be reached, otherwise funds are refunded
    ) 
    
    MintedCrowdsale() 
    TimedCrowdsale(openingTime, closingTime) 
    CappedCrowdsale(cap) 
    RefundableCrowdsale(cap) 
    Crowdsale(rate, wallet, token) public {}
}

contract PupperCoinSaleDeployer {

    address public tokenSaleAddress;
    address public tokenAddress;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet // this address will recieve all ETHER raised by the crowdsale
        
    )
        public
    {
        //create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        tokenAddress = address(token);

        // create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale pupperSale = new PupperCoinSale(1, wallet, token, now, now + 5 minutes, (300 * 10**18));
        tokenSaleAddress = address(pupperSale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(tokenSaleAddress);
        token.renounceMinter();
    }
}