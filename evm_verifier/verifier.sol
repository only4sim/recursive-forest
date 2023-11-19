// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
pragma solidity ^0.8.0;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point memory) {
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) pure internal returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return r the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }


    /// @return r the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[1];
            input[i * 6 + 3] = p2[i].X[0];
            input[i * 6 + 4] = p2[i].Y[1];
            input[i * 6 + 5] = p2[i].Y[0];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alpha;
        Pairing.G2Point beta;
        Pairing.G2Point gamma;
        Pairing.G2Point delta;
        Pairing.G1Point[] gamma_abc;
    }
    struct Proof {
        Pairing.G1Point a;
        Pairing.G2Point b;
        Pairing.G1Point c;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.alpha = Pairing.G1Point(uint256(0x1534845376d75b3961d36c0e1431e5cb17769513746feb4818d3dd95e8073539), uint256(0x0c11021f9888a154d4fa887f04eac058e87472cf589704ffd72acb2c7b61f6b2));
        vk.beta = Pairing.G2Point([uint256(0x06ea8921d5bd33b03b328d800631d2fc7a67d9aa13717ce1478308cd4fb27ff3), uint256(0x09e94c91bb63ee7a8818f630fd2bf3376a53c7a9e3dbd35b92f19d0f80dec9f1)], [uint256(0x2e3d98ace9d888f20d50737466658c6ae0196a214a53cc598727fcf6e3cf5622), uint256(0x1a507419c0109a7d915bbb0bb543bfb9cb70a436e012a8baad6a0c6cd09df120)]);
        vk.gamma = Pairing.G2Point([uint256(0x19b0a6e932160deffe0dee618256f91751f1d4a7afc8e7ef26196dc8318cb041), uint256(0x2436d14ee19e77bc49a2f7e4b11ee379ebb2c584f3d783370b75b806a6b1f297)], [uint256(0x2f7be8586e0e5401aaeea7109197bcb66cbe8cb876143a9f936d6abf7661c93f), uint256(0x08686dabbb17cce890f74692287cc21cfb3976e9852a4157a5ae79c2caa4ce86)]);
        vk.delta = Pairing.G2Point([uint256(0x17c6e8ae491e77ce1525c1a2c883df0d9e226239ac1b3b844795a38fca45a77d), uint256(0x0f81c94e5bb535ddffa842f1704d927e19469155a2bf5413713328995ed58188)], [uint256(0x22f97b40ff11da22cf8f324c814804b7f4fd382b1d1500ab4e25684e1e7ae588), uint256(0x09faba29b592b9309de0ba98b2da0c54e1f684a9b4f68d7b69e982fcb2a6914d)]);
        vk.gamma_abc = new Pairing.G1Point[](12);
        vk.gamma_abc[0] = Pairing.G1Point(uint256(0x2855b5e0387ffd1c90ca7d0631abeef09fdc5f51dad0a7ff9a31f020fe79d2f2), uint256(0x2b420171f5728db8ba99fb8cb05c6dcbe9783ae31c196f8ff2b5ceddb87d0bc3));
        vk.gamma_abc[1] = Pairing.G1Point(uint256(0x1931f608807c64f219fed56d106b82751c7e3e9ae50e63a8ef685d93d7365daf), uint256(0x0c09513d0f60fd8f28e91d3fe211b33b56a1dd383ef94c684836d859e27ac96e));
        vk.gamma_abc[2] = Pairing.G1Point(uint256(0x2f28339a0279f67c1732a3913e68ad5204de7720243ccf04176af05b5a68ed19), uint256(0x253c8ed97a466f874ec298a890bfbcd5f196788713a8340a74b84f36c5c9c21c));
        vk.gamma_abc[3] = Pairing.G1Point(uint256(0x1e201532b2bf179dee4dd2ee4ffd6d26f6c845c295c68aaf6fa0a374028eb80d), uint256(0x1f4b9e15c3822718272911f80f15166f832dee6bd13f3909aacfe040caf06968));
        vk.gamma_abc[4] = Pairing.G1Point(uint256(0x251552256b54f9f9686563518baf1073cddf08de53452bba6bf44cd8389a7fed), uint256(0x2f7b39221d22182230d289b7befbb10eeb64e6ab8415299be2956cd65f9c9437));
        vk.gamma_abc[5] = Pairing.G1Point(uint256(0x027ff5621eb092e88a1553a6fbd715daeb29564138f9469d0b8a789740b5afaf), uint256(0x0e5456a0e79ace316c41d9e9f78c2f19d0e0735aa93eda6f95414acf23c4d59d));
        vk.gamma_abc[6] = Pairing.G1Point(uint256(0x285693aff9538cdc22fa64b74f7a9e2b3cb2891805a0c031a008c0ece883b9da), uint256(0x1ce6e14762ad4f3830856f33c4737f78714d4b1481449bfc6e41506abe00c8e6));
        vk.gamma_abc[7] = Pairing.G1Point(uint256(0x1dba410039d27403d4c6d8ef07aa63ce2d9f729c46b9913e75acebfc66a9b9ac), uint256(0x200392c6f1c4a43e2b9505c2dda3f644c65760f2ef5216a036896bc7dde094d9));
        vk.gamma_abc[8] = Pairing.G1Point(uint256(0x1f7caecbdb205e7fef7d4ef7084859bada062167811ba2708da1a5532fec5292), uint256(0x26c3962d5fa07238ba35aaf25901ef5bfcaeaf20b336979e45669e2c61f6c6de));
        vk.gamma_abc[9] = Pairing.G1Point(uint256(0x076278c75fdacbce6b18068715ef3b792014faf751fbdcd14606763ee6cad918), uint256(0x21825340cb3fbb86c0918826998498b141b7bdbae71db3e7f167d9dd39a108c2));
        vk.gamma_abc[10] = Pairing.G1Point(uint256(0x108d21139804ede832d9fd29d77368f740e62a444c05846bb074102d39d300b5), uint256(0x02469497ae15fd8775d035d3629218f937eeda696115df06cc11e162ff684d8d));
        vk.gamma_abc[11] = Pairing.G1Point(uint256(0x3058508a2d9942834f880296a6f18210ef0d11dbda7586dedf3ca1f500297c97), uint256(0x0210a93aacc7a4680e480c854907199bb22189467d3da263f2712afd6c5d21fa));
    }
    function verify(uint[] memory input, Proof memory proof) internal view returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.gamma_abc.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field);
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.gamma_abc[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.gamma_abc[0]);
        if(!Pairing.pairingProd4(
             proof.a, proof.b,
             Pairing.negate(vk_x), vk.gamma,
             Pairing.negate(proof.c), vk.delta,
             Pairing.negate(vk.alpha), vk.beta)) return 1;
        return 0;
    }
    function verifyTx(
            Proof memory proof, uint[11] memory input
        ) public view returns (bool r) {
        uint[] memory inputValues = new uint[](11);
        
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}
