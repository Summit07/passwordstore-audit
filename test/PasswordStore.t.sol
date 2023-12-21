// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {PasswordStore} from "../src/PasswordStore.sol";
import {DeployPasswordStore} from "../script/DeployPasswordStore.s.sol";

contract PasswordStoreTest is Test {
    //! Initialise the storage for the testing of the contract
    PasswordStore public passwordStore; //?---- initiate PasswordStore
    DeployPasswordStore public deployer; //?----initiate Deploy PassWord Script
    address public owner; // ? ----initialis owner storage

    //! Initialise the deployer, setUP() with Deploy Script DeployPasswordStore() than run the passwordStore using deployer.run()
    function setUp() public {
        deployer = new DeployPasswordStore(); //? initiate the deployer
        passwordStore = deployer.run(); //? ----- run the passwordStore using deployer.run()
        owner = msg.sender; // ? msg.sender == owner
    }

    //! //////////////////////////////////////////
    //!        Start the Testing function       //
    //! //////////////////////////////////////////
    function test_owner_can_set_password() public {
        //! start prank with owner
        vm.startPrank(owner);
        string memory expectedPassword = "myNewPassword";
        passwordStore.setPassword(expectedPassword); //? ---- pass the password using setPassword() function
        string memory actualPassword = passwordStore.getPassword(); //? --- gettting new Password
        assertEq(actualPassword, expectedPassword); //?  === comapring the new and setted password
    }

    //!   Check if non owner can set the password
    function test_non_owner_reading_password_reverts() public {
        //! start prank with other address not related to owner
        vm.startPrank(address(1)); //? ==== initialise with diffrent address

        vm.expectRevert(PasswordStore.PasswordStore__NotOwner.selector); //? expected revert with .selector keyword
        passwordStore.getPassword();
    }
}
