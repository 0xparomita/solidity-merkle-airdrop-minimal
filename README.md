# Merkle Tree Token Airdrop (Minimal)

A production-grade, highly gas-optimized token airdrop contract utilizing Merkle Proof validation. Instead of storing thousands of addresses directly on-chain, this contract stores a single 32-byte Merkle Root, saving massive deployment costs while maintaining cryptographic integrity.

## Features
- **Zero-Storage Whitelisting:** Verification scales infinitely using a single 32-byte on-chain Merkle Root.
- **Double-Claim Protection:** Explicit structural status checking prevents replay claims.
- **Gas-Optimized Validation:** Relies on efficient OpenZeppelin `MerkleProof` utility validation loops.
- **Flat Structure:** All essential dependencies and assets are placed directly in the root directory for fast compilations.

## Quickstart

### Dependencies
```bash
npm install
