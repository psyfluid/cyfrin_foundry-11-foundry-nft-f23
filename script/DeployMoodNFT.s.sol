// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNFT is Script {
    function run() external returns (MoodNFT) {
        string memory happySVG = vm.readFile("./img/happy.svg");
        string memory sadSVG = vm.readFile("./img/sad.svg");

        vm.startBroadcast();
        MoodNFT moodNFT = new MoodNFT(svgToImageURI(happySVG), svgToImageURI(sadSVG));
        vm.stopBroadcast();
        return moodNFT;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        return string(abi.encodePacked(baseURI, Base64.encode(abi.encodePacked(svg))));
    }
}
