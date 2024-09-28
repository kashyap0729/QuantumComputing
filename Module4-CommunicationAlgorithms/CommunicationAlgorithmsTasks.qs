// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.CommunicationAlgorithms {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    //////////////////////////////////////////////////////////////////
    // This is the set of programming assignments for the module "Quantum Communication Algorithms".
    //////////////////////////////////////////////////////////////////

    // The tasks cover the following topics:
    //  - teleportation protocol
    //  - superdense coding protocol
    //  - no-cloning theorem
    //
    // We recommend to solve the following katas before doing these assignments:
    //  - Teleportation
    //  - SuperdenseCoding
    // from https://github.com/Microsoft/QuantumKatas


    // Task 1. Superdense coding using |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2) (1 point).
    // This task considers a modification of the superdense coding protocol 
    // in which the pair of qubits shared by Alice and Bob are entangled in a state |Ψ⁺⟩ = (|01⟩ + |10⟩) / sqrt(2).
    //
    // Alice performs the standard message encoding operation, as implemented in SuperdenseCoding kata:
    // operation EncodeMessageInQubit_Reference (qAlice : Qubit, message : Bool[]) : Unit {
    //     if (message[0]) {
    //         Z(qAlice);
    //     }
    //     if (message[1]) {
    //         X(qAlice);
    //     }
    // }
    // After performing this operation she sends her qubit to Bob.
    //
    // Your task is to implement Bob's part of the protocol (the message decoding) to obtain the two bits of Alice's message.
    operation Task1 (qBob : Qubit, qAlice : Qubit) : Bool[] {
    CNOT(qAlice,qBob);
    H(qAlice);

    let bit1 = M(qAlice) == One ? true | false;
    let bit2 = M(qBob) == Zero ? true | false;
    return [bit1,bit2];
    }


    // Task 2. Teleportation using (|01⟩ ± |10⟩) / sqrt(2) (1 point).
    //
    // This task considers a modification of the teleportation protocol
    // in which the pair of qubits shared by Alice and Bob are entangled in a state (|01⟩ ± |10⟩) / sqrt(2),
    // where the first qubit in ket notation denotes Alice's qubit and the second one - Bob's qubit.
    // The sign between the |01⟩ and |10⟩ components of the state is given by the parameter bellStateSign:
    // +1 denotes state (|01⟩ + |10⟩) / sqrt(2), -1 - state (|01⟩ - |10⟩) / sqrt(2).
    // 
    // Alice has a qubit in the state |ψ⟩ = α|0⟩ + β|1⟩.
    // Alice performs the standard message sending operation, as implemented in the Teleportation kata:
    // operation SendMessage_Reference (qAlice : Qubit, qMessage : Qubit) : (Bool, Bool) {
    //     CNOT(qMessage, qAlice);
    //     H(qMessage);
    //     return (M(qMessage) == One, M(qAlice) == One);
    // }
    // After performing this operation she sends the two measured bits to Bob.
    // 
    // Your task is to implement Bob's part of the protocol (the fix-up), so that he ends up with a qubit in the state |ψ⟩.
    // You are allowed to introduce a global phase to the teleported state.
    operation Task2 (qBob : Qubit, (b1 : Bool, b2 : Bool), bellStateSign : Int) : Unit {
        // ...
        if(bellStateSign == -1){
            Z(qBob);
        }
        if(b1) {
            Z(qBob);
        }
        if not (b2) {
            X(qBob);
        }
    }


    // Task 3. Clone |+⟩ and |-⟩ states (1 point).
    // Inputs:
    //    1) a data qubit that is guaranteed to be in |+⟩ or |-⟩ state,
    //    2) a scratch qubit that is guaranteed to be in the |0⟩ state.
    // Goal: Implement a unitary transformation that will clone the data qubit state onto the scratch qubit,
    //       i.e., will transform |+, 0⟩ → |+, +⟩ and |-, 0⟩ → |-, -⟩.
    // Do not use measurements.
    operation Task3 (data : Qubit, scratch : Qubit) : Unit is Adj {
    H(data);
    CNOT(data, scratch);
    H(data);
    H(scratch);
    }


    // Task 4. Delete |+⟩ and |-⟩ states (1 point).
    // Input: a pair of qubits that is guaranteed to be in |+, +⟩ or |-, -⟩ state.
    // Goal: Implement a unitary transformation that will delete the data from the second qubit,
    //       i.e., will transform |+, +⟩ → |+, 0⟩ and |-, -⟩ → |-, 0⟩.
    // Do not use measurements.
    operation Task4 (qs : Qubit[]) : Unit is Adj {
         H(qs[0]);
         H(qs[1]);
  CNOT(qs[0], qs[1]); 
  H(qs[0]);           
    }


    // Task 5. H gate teleportation (2 points).
    // Alice and Bob share a qubit in the state (I ⊗ H)(|00⟩ + |11⟩) / sqrt(2) = 1/2 (|00⟩ + |01⟩ + |10⟩ - |11⟩)
    // (the Hadamard gate is applied to Bob's qubit of the Bell pair).
    // Alice has a qubit in the state |ψ⟩ = α|0⟩ + β|1⟩.
    // She wants to send to Bob the state H|ψ⟩ without Bob applying an H gate to his qubit (this is called gate teleportation).
    //
    // Alice performs the standard message sending operation, as implemented in the Teleportation kata:
    // operation SendMessage_Reference (qAlice : Qubit, qMessage : Qubit) : (Bool, Bool) {
    //     CNOT(qMessage, qAlice);
    //     H(qMessage);
    //     return (M(qMessage) == One, M(qAlice) == One);
    // }
    // She sends Bob the return of this operation.
    //
    // Your task is to implement Bob's part of the protocol (the fix-up), so that he ends up with a qubit in the state H|ψ⟩.
    // You can only use Pauli gates; you can not use H or arbitrary rotation gates.
    // You are allowed to introduce a global phase to the teleported state.
    operation Task5 (qBob : Qubit, (b1 : Bool, b2 : Bool)) : Unit {
        // ...
        if(b1) {
            X(qBob);
        }
        if(b2) {
            Z(qBob);
        }
    }
    
}
