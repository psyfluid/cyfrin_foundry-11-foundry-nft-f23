// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {VmSafe} from "forge-std/Vm.sol";
import {MoodNFT} from "../src/MoodNFT.sol";
// import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

function bytesToAddress(bytes memory bys) pure returns (address addr) {
    assembly {
        addr := mload(add(bys, 32))
    }
}

function getDeployedContractAddress(string memory contractName) view returns (address) {
    VmSafe vm = VmSafe(address(uint160(uint256(keccak256("hevm cheat code")))));
    string memory path = string.concat(
        "./broadcast/", contractName, ".s.sol/", Strings.toString(block.chainid), "/run-latest.json"
    );
    string memory json = vm.readFile(path);
    bytes memory contractAddress = stdJson.parseRaw(json, ".transactions[0].contractAddress");
    return (bytesToAddress(contractAddress));
}

contract MintBasicNFT is Script {
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        // address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNFT", block.chainid);
        address mostRecentlyDeployed = getDeployedContractAddress("DeployBasicNFT");
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNFT(PUG);
        vm.stopBroadcast();
    }
}

contract MintMoodNFT is Script {
    function run() external {
        address mostRecentlyDeployed = getDeployedContractAddress("DeployMoodNFT");
        mintNFTOnContract(mostRecentlyDeployed);
    }

    function mintNFTOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNFT(contractAddress).mintNFT();
        vm.stopBroadcast();
    }
}

contract FlipMoodNFT is Script {
    function run() external {
        address mostRecentlyDeployed = getDeployedContractAddress("DeployMoodNFT");
        flipMoodNFT(mostRecentlyDeployed);
    }

    function flipMoodNFT(address contractAddress) public {
        vm.startBroadcast();
        MoodNFT(contractAddress).flipMood(0); // just first token
        vm.stopBroadcast();
    }
}
