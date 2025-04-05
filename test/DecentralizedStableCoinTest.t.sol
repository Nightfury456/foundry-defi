// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";

contract DecentralizedStableCoinTest is Test {
    DecentralizedStableCoin dsc;
    address public owner;
    address public user;

    function setUp() public {
        owner = address(this);
        user = address(1);
        dsc = new DecentralizedStableCoin();
    }

    function testRevertsOnZeroBurnAmount() public {
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__mustBeMoreThanZero.selector);
        dsc.burn(0);
    }

    function testRevertsOnBalanceLessThanBurnAmount() public {
        vm.expectRevert(DecentralizedStableCoin.DecentralizedStableCoin__BurnAmountExceedsBalance.selector);
        dsc.burn(100);
    }

    function testBurnSuccess() public {
        dsc.mint(owner, 500);
        assertEq(dsc.balanceOf(owner), 500);

        dsc.burn(200);
        assertEq(dsc.balanceOf(owner), 300);
    }

    // function testOnlyOwnerCanBurn() public {
    //     dsc.mint(owner, 100);

    //     vm.prank(user);
    //     vm.expectRevert("Ownable: caller is not the owner");
    //     dsc.burn(50);
    // }
}
