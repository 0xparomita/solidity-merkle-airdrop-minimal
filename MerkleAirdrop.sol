// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}

library MerkleProof {
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = _hashPair(computedHash, proof[i]);
        }
        return computedHash;
    }

    function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
        return a < b ? keccak256(abi.encodePacked(a, b)) : keccak256(abi.encodePacked(b, a));
    }
}

contract MerkleAirdrop {
    address public immutable token;
    bytes32 public immutable merkleRoot;
    address public immutable owner;

    mapping(address => bool) public hasClaimed;

    event TokensClaimed(address indexed claimant, uint256 amount);
    event EmergencyWithdrawal(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the authorized owner");
        _;
    }

    constructor(address _token, bytes32 _merkleRoot) {
        require(_token != address(0), "Invalid token contract address");
        require(_merkleRoot != bytes32(0), "Invalid cryptographic root hash");
        token = _token;
        merkleRoot = _merkleRoot;
        owner = msg.sender;
    }

    function claim(uint256 amount, bytes32[] calldata merkleProof) external {
        require(!hasClaimed[msg.sender], "Airdrop distribution allocation already claimed");

        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, amount))));
        
        require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "Invalid cryptographic signature proof validation");

        hasClaimed[msg.sender] = true;
        require(IERC20(token).transfer(msg.sender, amount), "Token distribution payout transfer failed");

        emit TokensClaimed(msg.sender, amount);
    }

    function emergencyWithdraw(uint256 amount) external onlyOwner {
        require(IERC20(token).transfer(owner, amount), "Emergency asset recovery withdrawal failed");
        emit EmergencyWithdrawal(owner, amount);
    }
}
