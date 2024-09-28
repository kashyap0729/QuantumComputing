// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.OracularAlgorithms {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    //////////////////////////////////////////////////////////////////
    // This is the set of programming assignments for the module "Oracular Algorithms".
    //////////////////////////////////////////////////////////////////

    // The tasks cover the following topics:
    //  - phase oracles
    //  - Deutsch and Deutsch-Jozsa algorithms
    //  - Bernstein-Vazirani algorithm
    //
    // We recommend to solve the following katas before doing these assignments:
    //  - Oracles tutorial
    //  - ExploringDeutschJozsaAlgorithm tutorial
    // from https://github.com/Microsoft/QuantumKatas
    //
    // In all of the tasks, you're not allowed to allocate extra qubits. 
    // The testing harness doesn't enforce this; the way this check can be implemented using library function AllowAtMostNQubits 
    // interferes with parallel test execution done by the "dotnet test" command and leads to failures of correct solutions.


    // Task 1. Phase oracles for Deutsch algorithm (1 point).
    // Inputs:
    //      1) a qubit in an arbitrary state (function input)
    //      2) an integer F which defines which function to implement:
    //         F = 0 : f(x) = 0
    //         F = 1 : f(x) = 1
    //         F = 2 : f(x) = x
    //         F = 3 : f(x) = 1 - x
    // Goal: implement a unitary that transforms each basis state |x⟩ into state (-1)^f(x) |x⟩.
    // You are not allowed to allocate extra qubits.
    operation Task1 (x : Qubit, F : Int) : Unit is Adj + Ctl {
        // ...
        if (F == 0) {
        } elif (F == 1) {
            R(PauliI, 2.0 * PI(), x);
        } elif (F == 2) {
            
            Z(x);
        } elif (F == 3) {
            X(x);
            Z(x);
            X(x);
            }
    }


    // Task 2. Equality phase oracle (2 points).
    // Input: two qubits in an arbitrary state (function input)
    // Goal: implement a unitary that transforms each basis state |x₁x₂⟩ into state (-1)^f(x₁, x₂) |x₁x₂⟩,
    //       where f(x₁, x₂) = 1 if x₁ = x₂ and 0 otherwise.
    // You are not allowed to allocate extra qubits.
    operation Task2 (x : Qubit[]) : Unit is Adj + Ctl {
    Controlled Z([x[0]], x[1]);
        X(x[0]);
        X(x[1]);
        Controlled Z([x[0]], x[1]);
        X(x[0]);
        X(x[1]); 

}


    // Task 3. Phase oracle for Bernstein-Vazirani algorithm (2 points).
    // Inputs: 
    //      1) N ≥ 2 qubits in an arbitrary state (function input)
    //      2) a bit vector of length N represented as Bool[] (true corresponds to 1 and false to 0)
    // Goal: implement a unitary that transforms each basis state |x₁x₂...xₙ⟩ into state (-1)^f(x₁, x₂, ..., xₙ) |x₁x₂...xₙ⟩,
    //       where f(x₁, x₂, ..., xₙ) = Σᵢ sᵢ xᵢ modulo 2 
    //       (i.e., the function implemented by the oracle used in Bernstein-Vazirani algorithm).
    // You are not allowed to allocate extra qubits.
    operation Task3 (x : Qubit[], s : Bool[]) : Unit is Adj + Ctl {
        // ...
        for i in 0..Length(s) - 1{
        if (s[i]) {
            Z(x[i]);
        }
    }
    }

    // Task 4. "Even number of 0s" phase oracle (2 points)
    // Input: N ≥ 2 qubits in an arbitrary state (function input)
    // Goal: implement a unitary that transforms each basis state |x₁x₂...xₙ⟩ into state (-1)^f(x₁, x₂, ..., xₙ) |x₁x₂...xₙ⟩,
    //       where f(x₁, x₂, ..., xₙ) = 1 if the number of zeros among xᵢ is even, and 0 otherwise.
    // You are not allowed to allocate extra qubits.
    operation Task4 (x : Qubit[]) : Unit is Adj + Ctl {
        // ...
         let N = Length(x);

        for i in 0..N-1 {
            X(x[i]);
        }

       
        for i in 0..N-2 {
            CNOT(x[i], x[i+1]);
        }
        Z(x[N-1]);
        for i in N-2..-1..0 {
            CNOT(x[i], x[i+1]);
        }

        for i in 0..N-1 {
            X(x[i]);
        }

    }


    // Task 5. "Alternating bit stings" phase oracle (3 points)
    // Input: N ≥ 2 qubits in an arbitrary state (function input)
    // Goal: implement a unitary that transforms each basis state |x₁x₂...xₙ⟩ into state (-1)^f(x₁, x₂, ..., xₙ) |x₁x₂...xₙ⟩,
    //       where f(x₁, x₂, ..., xₙ) = 1 if the bit string x consists of alternating bits, and 0 otherwise.
    //       (This means that the only two bit strings that should be marked with the -1 phase are 0101... and 1010...)
    // You are not allowed to allocate extra qubits.
    operation Task5 (x : Qubit[]) : Unit is Adj + Ctl {
        // ...
        let N = Length(x);
        for i in 1 .. N - 1 {
             CNOT(x[i], x[i - 1]);
        }
        Controlled Z(x[0 .. N - 3], x[N - 2]);
         for i in N - 1 .. -1 .. 1 {
            CNOT(x[i], x[i - 1]);
        }

    }
}
