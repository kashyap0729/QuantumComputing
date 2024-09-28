// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.QEC {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    //////////////////////////////////////////////////////////////////
    // This is the set of programming assignments for the module "Quantum error correction".
    //////////////////////////////////////////////////////////////////

    // The tasks cover the following topics:
    //  - quantum error correction: sign flip and Shor error correction codes
    //
    // We recommend to solve the following katas before doing these assignments:
    //  - QEC_BitFlipCode
    // from https://github.com/Microsoft/QuantumKatas


    // Task 1. Sign flip code: encode logical state (1 point).
    // Input: three qubits in the state |ψ⟩ ⊗ |0⟩ ⊗ |0⟩, where |ψ⟩ = α|0⟩ + β|1⟩ is the state of qs[0].
    // Goal: create a state |̅ψ⟩ = α|+++⟩ + β|---⟩ on these qubits.
    operation Task1(qs : Qubit[]) : Unit is Adj {
        CNOT(qs[0], qs[1]);
        H(qs[1]);
        CNOT(qs[0], qs[2]);
        H(qs[1]);
        
        H(qs[0]);
        H(qs[1]);
        H(qs[2]);
    }


    // Task 2. Sign flip code: detect Z error (1 point).
    // Input: three qubits that are either in the state |̅ψ⟩ = α|+++⟩ + β|---⟩
    //        or in one of the states Z𝟙𝟙|̅ψ⟩, 𝟙Z𝟙|̅ψ⟩ or 𝟙𝟙Z|̅ψ⟩
    //        (i.e., state |̅ψ⟩ with a Z error applied to one of the qubits).
    // Goal: determine whether a Z error has occurred, and if so, on which qubit.
    // The state of the qubits after your operation is applied should not change.
    // Error | Output
    // ======+=======
    // None  | -1
    // X𝟙𝟙   | 0
    // 𝟙X𝟙   | 1
    // 𝟙𝟙X   | 2
    operation Task2(qs : Qubit[]) : Int {
        use Abit = Qubit();
        use Bbit = Qubit();

        //Apply Hadamard 
        H(qs[0]);
        H(qs[1]);
        H(qs[2]);

        //Transform the new Qubits
        CNOT(qs[0], Abit);
        CNOT(qs[1], Abit);

        CNOT(qs[1], Bbit);
        CNOT(qs[2], Bbit);

        //Reverting the Qs
        H(qs[0]);
        H(qs[1]);
        H(qs[2]);

        let resA = Measure([PauliZ], [Abit]);
        let resB = Measure([PauliZ], [Bbit]);

        if (resA == Zero and resB == Zero) {
            return -1;
        }
        elif (resA == Zero and resB == One) {
            return 2;
        }
        elif (resA == One and resB == One) {
            return 1;
        }
        
        else {
            return 0;
        }
    }


    // Task 3. Shor code: encode logical state (2 points).
    // Input: 9 qubits in the state |ψ⟩ ⊗ |0...0⟩, where |ψ⟩ = α|0⟩ + β|1⟩ is the state of qs[0].
    // Goal: create the state |̅ψ⟩ - the logical state representation of |ψ⟩ using thr Shor error correction code.
    operation Task3(qs : Qubit[]) : Unit is Adj {

        CNOT(qs[0], qs[3]);
        CNOT(qs[0], qs[6]);

        H(qs[0]);
        CNOT(qs[0], qs[2]);
        CNOT(qs[0], qs[1]);

        H(qs[3]);
        CNOT(qs[3], qs[5]);
        CNOT(qs[3], qs[4]);

        
        H(qs[6]);
        CNOT(qs[6], qs[8]);
        CNOT(qs[6], qs[7]);
    }


    // Task 4. Shor code: detect single error (4 points).
    // Input: 9 qubits that are either in the state |̅ψ⟩ - the logical representation of state |ψ⟩ using thr Shor error correction code -
    //        or in one of the states that are a result of applying a single X, Y, or Z gate to one of the qubits of the state |̅ψ⟩.
    // Goal: determine whether an error has occurred, and if so, what type of error and on which qubit.
    // The first element of the return is an Int - the index of the qubit on which the error occurred, or -1 if no error occurred.
    // The second element of the return is a Pauli indicating the type of the error (PauliX, PauliY, or PauliZ).
    //   * If no error occurred, the second element of the return can be any value, it is not validated.
    //   * In case of a single Z error, the qubit on which it occurred cannot be identified uniquely.
    //     In this case, the return value should be the index of the triplet of qubits in which the error occurred (0 for qubits 0 .. 2, 1 for qubits 3 .. 5, and 2 for qubits 6 .. 8).
    // The state of the qubits after your operation is applied should not change.
    // Examples:
    //     Error    |    Output
    // =============+==============
    // None         | (-1, PauliI)
    // X on qubit 0 | (0, PauliX)
    // Y on qubit 4 | (4, PauliY)
    // Z on qubit 8 | (2, PauliZ)
    operation Task4(qs : Qubit[]) : (Int, Pauli) {
        let startIndexes = [0, 3, 6];
        mutable eX = -1;
        use Abits = Qubit[6];

        for groupIndex in 0..2 {
            let start = startIndexes[groupIndex];
            let q0 = qs[start];   
            let q1 = qs[start + 1]; 
            let q2 = qs[start + 2];

            let a0 = Abits[2 * groupIndex];  
            let a1 = Abits[2 * groupIndex + 1];

            CNOT(q0, a0);
            CNOT(q1, a0);
            CNOT(q1, a1);
            CNOT(q2, a1);

            let result0 = M(a0);
            let result1 = M(a1);

            if (result0 == One and result1 == Zero) {
                set eX = start;
            } elif (result0 == One and result1 == One) {
                set eX = start + 1; 
            } elif (result0 == Zero and result1 == One) {
                set eX = start + 2; 
            }

            Reset(a0);
            Reset(a1);
        }

        for i in 0..8 {
            H(qs[i]);
        }
        
        use Bbits = Qubit[2];
        for i in 0..5 {
            CNOT(qs[i], Bbits[0]);
        }
        for i in 3..8 {
            CNOT(qs[i], Bbits[1]);
        }
        for i in 0..8 {
            H(qs[i]);
        }
        let result2 = M(Bbits[0]);
        let restult3 = M(Bbits[1]);        
        mutable eZ = -1;
        if (result2 == One and restult3 == Zero) {
            set eZ = 0;
        } elif (result2 == One and restult3 == One) {
            set eZ = 1;
        } elif (result2 == Zero and restult3 == One) {
            set eZ = 2;
        }
        if (eX != -1 and eZ == -1) {
            return (eX, PauliX);
        } elif (eX != -1 and eZ != -1) {
            return (eX, PauliY);
        } elif (eX == -1 and eZ != -1) {
            return (eZ, PauliZ);
        } else {
            return (-1, PauliI);
        }
    }



}
