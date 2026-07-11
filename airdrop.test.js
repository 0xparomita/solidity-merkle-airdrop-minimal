const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MerkleAirdrop Structural Setup Engine", function () {
  let MerkleAirdrop, airdrop;
  let owner, mockToken;
  const sampleRoot = "0x1234567890123456789012345678901234567890123456789012345678901234";

  beforeEach(async function () {
    [owner, mockToken] = await ethers.getSigners();
    MerkleAirdrop = await ethers.getContractFactory("MerkleAirdrop");
    airdrop = await MerkleAirdrop.deploy(mockToken.address, sampleRoot);
  });

  it("Should correctly initialize structural components and parameters", async function () {
    expect(await airdrop.token()).to.equal(mockToken.address);
    expect(await airdrop.merkleRoot()).to.equal(sampleRoot);
    expect(await airdrop.owner()).to.equal(owner.address);
  });
});
