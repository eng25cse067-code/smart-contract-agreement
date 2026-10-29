
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Agreement {
    address public partyA;
    address public partyB;

    bytes32 public documentHash;

    bool public signedByA;
    bool public signedByB;
    bool public cancelled;

    constructor(address _partyB, bytes32 _documentHash) {
        require(_partyB != address(0), "Invalid party B");
        require(_partyB != msg.sender, "Parties must differ");
        require(_documentHash != bytes32(0), "Empty document hash");

        partyA = msg.sender;
        partyB = _partyB;
        documentHash = _documentHash;
    }

    function signAgreement() external {
        require(!cancelled, "Agreement cancelled");
        require(!isFullySigned(), "Already fully signed");

        if (msg.sender == partyA) {
            require(!signedByA, "Already signed by A");
            signedByA = true;
        } else if (msg.sender == partyB) {
            require(!signedByB, "Already signed by B");
            signedByB = true;
        } else {
            revert("Not an agreement party");
        }
    }

    function isFullySigned() public view returns (bool) {
        return signedByA && signedByB;
    }

    function cancelAgreement() external {
        require(
            msg.sender == partyA || msg.sender == partyB,
            "Not an agreement party"
        );
        require(!cancelled, "Already cancelled");
        require(!isFullySigned(), "Already fully signed");

        cancelled = true;
    }

    function getStatus() external view returns (string memory) {
        if (cancelled) {
            return "Cancelled";
        }

        if (isFullySigned()) {
            return "Fully Signed";
        }

        return "Pending Signatures";
    }
}
