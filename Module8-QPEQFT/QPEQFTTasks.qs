// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.QPEQFT {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    //////////////////////////////////////////////////////////////////
    // This is the set of programming assignments for the module "Building up to Shor's algorithm".
    //////////////////////////////////////////////////////////////////

    // The tasks cover the following topics:
    //  - quantum phase estimation
    //  - quantum Fourier transform
    //
    // We recommend to solve the following katas before doing these assignments:
    //  - QFT
    //  - PhaseEstimation
    // from https://github.com/Microsoft/QuantumKatas


    // Note: all tasks in this assignment assume register in little-endian format 
    // (the least significant bit is stored first). This matches the indices used in DumpMachine output.
    // For example, if you have two qubits in state |qs[0], qs[1]⟩ = |01⟩, this register is in state |2⟩.

    // In the first three tasks, you have to prepare the given state using quantum Fourier transform.
    // You do not need to implement QFT yourself; you need to put the given qubits into such a state that 
    // an application of the library operation QFTLE converts them into the required state.
    // In the testing harness, the call to your solution is followed by a call QFTLE(LittleEndian(qs));


    // Task 1. Prepare periodic state using QFT (1 point).
    // Input: n qubits in the |0...0⟩ state (n ≥ 2).
    // Goal: create the state such that applying to it QFTLE prepares the following state:
    //       1/sqrt(N) Σₖ exp(2πik/N) |k⟩, where N = 2ⁿ.
    // For example, for n = 2 N = 4, and the goal state is 
    //       1/2 (|0⟩ + i|1⟩ - |2⟩ - i|3⟩).
    operation Task1 (qs : Qubit[]) : Unit is Adj {
        // ...
        ApplyPauliFromBitString(PauliX, true, IntAsBoolArray(1, Length(qs)),qs);
    }


    // Task 2. Prepare superposition of odd states using QFT (1 point).
    // Input: n qubits in the |0...0⟩ state (n ≥ 2).
    // Goal: create the state such that applying to it QFTLE prepares the following state:
    //       1/sqrt(2ⁿ⁻¹) (|1⟩ + |3⟩ + ... + |2ⁿ-1⟩).
    // For example, for n = 2 the goal state is 
    //       1/sqrt(2) (|1⟩ + |3⟩).
    // Note that this state is very easy to prepare directly; please don't do that followed by a call to Adjoint QFTLE, 
    // but think what state is converted into this state by QFT.
    operation Task2 (qs : Qubit[]) : Unit is Adj {
        // ...
        let n = Length(qs);
        X(qs[n-1]);
        H(qs[n-1]);
    }


    // Task 3. Prepare superposition of cosines using QFT (2 points).
    // Input: n qubits in the |0...0⟩ state (n ≥ 2).
    // Goal: create the state such that applying to it QFTLE prepares the following state:
    //       1/sqrt(2ⁿ⁻¹) Σₖ cos(2πk/N) |k⟩, where N = 2ⁿ.
    // For example, for n = 2 N = 4, and the goal state is 
    //       1/sqrt(2) (cos(0)|0⟩ + cos(π/2)|1⟩ + cos(π)|2⟩ + cos(3π/2)|3⟩) = 1/sqrt(2) (|0⟩ - |2⟩).
    operation Task3 (qs : Qubit[]) : Unit is Adj {
    // ...
    X(qs[0]);
    H(qs[1]);
    
//    let N = Length(qs);
//     for k in 0 .. N - 1 {
//         let theta = PI() * IntAsDouble(k) / IntAsDouble(1 <<< N);
//         if (Cos(theta) >= 0.0) {
//             Ry(2.0 * ArcCos(Sqrt(Cos(theta))), qs[k]);
//         } else {
//             Ry(2.0 * ArcCos(Sqrt(-Cos(theta))), qs[k]);
//             X(qs[k]);
//         }
//     }
//     QFTLE(LittleEndian(qs));

}


    // Task 4. Eigenstates of the Hadamard gate (1 point).
    // Inputs:
    //      1) a qubit in |0⟩ state.
    //      2) an integer "state" indicating which eigenstate to prepare (0 or 1).
    // Goal: prepare one of the eigenstates of the Hadamard gate (|ψ₀⟩ or |ψ₁⟩).
    //       The eigenstate |ψ₀⟩ (prepared for "state" = 0) should be the one with eigenvalue -1,
    //       |ψ₁⟩ (prepared for "state" = 1) - the one with eigenvalue 1.
    operation Task4 (q : Qubit, state : Int) : Unit is Adj {
        // ...
     if (state == 0) {
            X(q); 
            Ry(PI() / 4.0, q);             
        } elif (state == 1) {
            Ry(PI() / 4.0, q);
        }
        else{
            Message("State should be 0 or 1");
        }
    }


    // Task 5. Quantum version of unitary power (2 points).
    // Inputs:
    //      1) a single-qubit unitary U.
    //      2) N qubits in an arbitrary state |k⟩.
    //      3) a qubit in an arbitrary state |ψ⟩ (not necessarily an eigenstate of U).
    // Goal: apply the k-th power of unitary U to the target qubit,
    //       i.e., transform the state |k⟩|ψ⟩ into the state |k⟩ Uᵏ|ψ⟩.
    // Here the integer k is stored in little endian format (least significant bit first).
    // Note that this task is similar to the oracle tasks:
    // powerRegister can be in superposition, so you should not measure it to obtain the value of k.
    //
    // For example, for U = S the state (|00⟩ + |01⟩ + |10⟩ + |11⟩) ⊗ |1⟩ should be transformed into
    //      |00⟩ ⊗ |1⟩ + |10⟩ ⊗ S|1⟩ + |01⟩ ⊗ S²|1⟩ + |11⟩ ⊗ S³|1⟩ = (|00⟩ + i |10⟩ - |01⟩ - i|11⟩) ⊗ |1⟩.
    operation Task5 (U : (Qubit => Unit is Adj+Ctl), 
                     powerRegister : Qubit[], 
                     target : Qubit) : Unit is Adj {
        // ...
          for i in 0..Length(powerRegister) - 1 {
            for j in 1..(1 <<< i){
                Controlled U([powerRegister[i]], target);
            }
        }
    }


    // Task 6. Reverse-engineer QPE (3 points).
    // Input:  A floating-point number φ in [0, 1) interval.
    // Output: A tuple of two single-qubit unitaries (U, P) which, when passed to 
    //         the QPE implementation from task 1.4 in PhaseEstimation kata, produce φ.
    //         In other words, find a unitary and its eigenstate which has the eigenvalue exp(2iπ φ).
    // For example, if phase = 0.0, you can return (Z, I) to represent eigenstate |0⟩ with eigenvalue 1 = exp(2πi · 0.0);
    //              if phase = 0.5, you can return (Z, X) to represent eigenstate |1⟩ with eigenvalue -1 = exp(2πi · 0.5).
    // 
    // QPE will be invoked with n = 8 bits of precision.
    // The returned value has to be accurate within the absolute error of 0.01.
    //
    // The test will be executed 100 times for each value of φ.
    function Task6 (phase : Double) : ((Qubit => Unit is Adj+Ctl), (Qubit => Unit is Adj)) {
        // ...
        return (I, I);
    }
}
