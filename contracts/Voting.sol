// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Voting {
    uint256 private p;
    uint256 private q;
    uint256 private n;
    uint256 private g;
    uint256 private l;
    uint256 private m;
    uint256 private constant candidate_count = 2;

    uint256[candidate_count][] private votes;
    uint256[candidate_count] private countedVotes;

    struct PrivateKey {
        uint256 l;
        uint256 m;
    }

    struct PublicKey {
        uint256 n;
        uint256 n_sq;
        uint256 g;
    }

    PublicKey publicKey;
    PrivateKey privateKey;

    constructor() {
        // Initialize key generation parameters (simplified)
        p = 1000000009; // Replace with a prime number
        q = 1000000007; // Replace with another prime number
        n = p * q;
        l = (p - 1) * (q - 1);
        m = modInverse(l, n, 1000000); // Calculate the modular inverse

        publicKey = PublicKey(n, n * n, n + 1);
        privateKey = PrivateKey(l, m);
    }

    function modInverse(uint256 a, uint256 pp, uint256 maxiter) internal pure returns (uint256) {
        uint256 r = a;
        uint256 d = 1;
        for (uint256 i = 0; i < min(pp, maxiter); i++) {
            d = ((pp / r + 1) * d) % pp;
            r = (d * a) % pp;
            if (r == 1) {
                break;
            }
        }
        return d;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function encrypt(uint256 plaintext) internal view returns (uint256) {
        require(plaintext < n, "Plaintext must be smaller than n");
        uint256 r = 5;
        uint256 x = powmod(r, publicKey.n, publicKey.n_sq);
        return (powmod(publicKey.g, plaintext, publicKey.n_sq) * x) % publicKey.n_sq;
    }

    function decrypt(uint256 ciphertext) internal view returns (uint256) {
        uint256 c1 = (powmod(ciphertext, privateKey.l, publicKey.n_sq) - 1) % publicKey.n_sq;
        uint256 plaintext = ((c1 / publicKey.n) * privateKey.m) % publicKey.n;

        return plaintext;
    }

    function add(uint256 a_enc, uint256 b_enc) internal view returns (uint256) {
        return (a_enc * b_enc) % publicKey.n_sq;
    }

    function addVotes(uint256 x) internal {
        for (uint256 i = 0; i < candidate_count; i++) {
            countedVotes[i] = add(votes[x][i], countedVotes[i]);
        }
    }

    function powmod(uint256 a, uint256 b, uint256 nn) internal pure returns (uint256) {
        if (a > nn) {
            a -= nn;
        }
        if (b == 0) {
            return 1;
        } else if (b % 2 == 0) {
            uint256 temp = powmod(a, b / 2, nn);
            return (temp * temp) % nn;
        } else {
            uint256 temp = powmod(a, (b - 1) / 2, nn);
            return (a * ((temp * temp) % nn)) % nn;
        }
    }

    function performVote(uint256[candidate_count] memory vote) public returns (string memory) {
        for (uint256 i = 0; i < vote.length; i++) {
            vote[i] = encrypt(vote[i]);
        }

        votes.push(vote);

        return "Your vote has been counted";
    }

    function voteCount() public returns (uint256[candidate_count] memory) {
        for (uint256 i = 0; i < candidate_count; i++) {
            countedVotes[i] = encrypt(0);
        }

        for (uint256 i = 0; i < votes.length; i++) {
            addVotes(i);
        }

        for (uint256 i = 0; i < candidate_count; i++) {
            countedVotes[i] = decrypt(countedVotes[i]);
        }

        return countedVotes;
    }
}
