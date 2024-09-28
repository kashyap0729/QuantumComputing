// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.MultiQubitSystems {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    //////////////////////////////////////////////////////////////////
    // This is the set of programming assignments for the module "Multi-qubit systems".
    //////////////////////////////////////////////////////////////////

    // The tasks cover the following topics:
    //  - multi-qubit quantum systems
    //  - applying single- and multi-qubit gates to change quantum state
    //  - preparing multi-qubit superposition states
    //  - measurement
    //
    // We recommend to solve the following katas before doing these assignments:
    //  - BasicGates, tasks 1.8-1.10, 2.1-2.5
    //  - Superposition, tasks 1.3, 1.4, 1.6-1.9, 2.2 (optionally 1.10-1.4, 2.3, 2.5-2.7)
    //  - Measurements, tasks 1.5-1.7 (optionally 1.8-1.14)
    // from https://github.com/Microsoft/QuantumKatas


    // Task 1. Prepare (|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2 (1 point).
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal: create the following state on these qubits: (|00⟩ + |01⟩ - |10⟩ - |11⟩) / 2.
    //       The states of the qubits are given in order |qs[0], qs[1]⟩.
    //       (The rest of the tasks in this assignment follow the same convention: 
    //       the first qubit in the array is the first bit in ket notation.)
    operation Task1 (qs : Qubit[]) : Unit {
        // ...
        H(qs[0]);
        H(qs[1]);
        CNOT(qs[0], qs[1]);
        Z(qs[0]);
    }

    // Task 2. Prepare (|0101..⟩ + |1010..⟩) / sqrt(2) (1 point).
    // Input: N qubits in |0...0⟩ state.
    // Goal: create the following state on this qubit: (|0101..⟩ + |1010..⟩) / sqrt(2).
    operation Task2 (qs : Qubit[]) : Unit {
        let N = Length(qs);
 
        H(qs[0]);
 
        for i in 1..2..N-1 {
            X(qs[i]);
        }

        for i in 0..N-2 {
            CNOT(qs[0], qs[i + 1]);
        }
        
 
    }




    // Task 3. Prepare |0000...⟩ + |0011...⟩ + |1100...⟩ + |1111...⟩ (1 point)
    // Input: N qubits in |0...0⟩ state (you are guaranteed that N is even).
    // Goal: create an equal superposition of all the basis states for which
    //       - qubits with indexes 0 and 1 are in the same state,
    //       - qubits with indexes 2 and 3 are in the same state,
    //       - and so on, qubits with indexes 2k and 2k+1 are in the same state.
    // In other words, create an equal superposition of all the basis states
    // of the form |aabbccdd...⟩, where each letter denotes one bit.
    // For example, for N = 4 the required state is (|0000⟩ + |0011⟩ + |1100⟩ + |1111⟩) / 2.
    operation Task3 (qs : Qubit[]) : Unit {
        // ...
       let N = Length(qs);
    // Apply Hadamard gates to the first qubit of each pair
    for i in 0..N / 2 - 1{
        H(qs[2 * i]);
    }
    // Entangle each pair with CNOT gates
    for i in 0..N / 2 - 1 {
        CNOT(qs[2 * i], qs[2 * i + 1]);
    }

    }


    // Task 4. Prepare (|+++...⟩ - |---...⟩) / sqrt(2) (2 points)
    // Input:  N qubits in |0...0⟩ state.
    // Goal: create the following state on this qubit: (|+++...⟩ - |---...⟩) / sqrt(2).
    // For example, for N = 1 the required state is (|+⟩ - |-⟩) / sqrt(2) = |1⟩.
   operation Task4 (qs : Qubit[]) : Unit {
    // Apply Hadamard to each qubit to create the superposition
    H(qs[0]);
    for i in 1..Length(qs)-1 {
        CNOT(qs[0],qs[i]);
    }
    Z(qs[0]);
    ApplyToEach(H,qs);
}


    // Task 5. Prepare (|00⟩ - |01⟩ + |10⟩ + |11⟩) / 2 (1 point).
    // Input: two qubits in |00⟩ state (stored in an array of length 2).
    // Goal: create the following state on these qubits: (|00⟩ - |01⟩ + |10⟩ + |11⟩) / 2.
    operation Task5 (qs : Qubit[]) : Unit {
    ApplyToEach(H, qs);
    
    Z(qs[1]);
    
    Controlled Z([qs[0]], qs[1]);
    }


    // Task 6. Distinguish two three-qubit states (1 point).
    // Input: three qubits which are guaranteed to be in one of the two superposition states:
    //        (|001⟩ + |010⟩ + |100⟩ + |111⟩) / 2 or 
    //        (|000⟩ + |110⟩ + |101⟩ + |011⟩) / 2.
    // Output: 0 if the qubits were in the first state,
    //         1 if they were in the second state.
    // The state of the qubits at the end of the operation does not matter.
    operation Task6 (qs : Qubit[]) : Int {
        Controlled X([qs[0]], qs[1]);
        Controlled X([qs[1]], qs[2]);
        return M(qs[2]) == Zero ? 1 | 0;

    }


    // Task 7. Distinguish four 3-qubit states (1 point).
    // Input: three qubits which are guaranteed to be in one of the four superposition states:
    //         |S0⟩ = (|000⟩ + |111⟩) / sqrt(2)
    //         |S1⟩ = (|001⟩ + |110⟩) / sqrt(2)
    //         |S2⟩ = (|010⟩ + |101⟩) / sqrt(2)
    //         |S3⟩ = (|100⟩ + |011⟩) / sqrt(2)
    // Output: 0 if the qubits were in |S0⟩ state,
    //         1 if they were in |S1⟩ state,
    //         2 if they were in |S2⟩ state,
    //         3 if they were in |S3⟩ state.
    // The state of the qubits at the end of the operation does not matter.
  operation Task7(qubits : Qubit[]) : Int {
        mutable results = [Zero, Zero, Zero];
        
        for i in 0..2 {
            set results w/= i <- M(qubits[i]);
        }

        let measuredState = ResultArrayAsInt(results);

        if (measuredState == 0 or measuredState == 7) {
            return 0;
        } elif (measuredState == 1 or measuredState == 6) {
            return 1;
        } elif (measuredState == 2 or measuredState == 5) {
            return 2; 
        } else { 
            return 3; 
        }
    }

    function ResultArrayAsInt(results : Result[]) : Int {
        mutable intValue = 0;
        for i in 0..Length(results)-1 {
            if (results[i] == One) {
                set intValue += 1 <<< (Length(results) - 1 - i);
            }
        }
        return intValue;
    }

    // Task 8. Distinguish four 2-qubit states (2 points).
    // Input: two qubits which are guaranteed to be in one of the four superposition states:
    //         |S0⟩ = 0.36|00⟩ + 0.48|01⟩ + 0.48|10⟩ + 0.64|11⟩
    //         |S1⟩ = 0.48|00⟩ - 0.36|01⟩ + 0.64|10⟩ - 0.48|11⟩
    //         |S2⟩ = 0.48|00⟩ + 0.64|01⟩ - 0.36|10⟩ - 0.48|11⟩
    //         |S3⟩ = 0.64|00⟩ - 0.48|01⟩ - 0.48|10⟩ + 0.36|11⟩
    // Output: 0 if the qubits were in |S0⟩ state,
    //         1 if they were in |S1⟩ state,
    //         2 if they were in |S2⟩ state,
    //         3 if they were in |S3⟩ state.
    // The state of the qubits at the end of the operation does not matter.
    operation Task8 (qs : Qubit[]) : Int {
        H(qs[0]);
        H(qs[1]);
     R1(PI()/4, qs[0]);
    Ry(-2.0 * ArcTan(Sqrt(2.0)), qs[1]);
    let m1 = M(qs[0]);
    let m2 = M(qs[1]);
    if (m1 == Zero and m2 == Zero) {
        return 0; 
    } elif (m1 == Zero and m2 == One) {
        return 1;
    } elif (m1 == One and m2 == Zero) {
        return 2; 
    } elif (m1 == One and m2 == One) {
        return 3; 
    } else {
        return -1; 
    }
}
}