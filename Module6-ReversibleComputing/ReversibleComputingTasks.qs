// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.ReversibleComputing {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    //////////////////////////////////////////////////////////////////
    // This is the set of programming assignments for the module "Reversible Computing".
    //////////////////////////////////////////////////////////////////

    // The tasks cover the following topics:
    //  - reversible computing
    //  - implementing quantum oracles
    //
    // We recommend to solve the following katas before doing these assignments:
    //  - Oracles tutorial
    //  - DeutschJozsaAlgorithm (part 1)
    //  - GroversAlgorithm (part 1)
    //  - MarkingOracles
    //  - SolveSATWithGrover (parts 1 and 2)
    //  - GraphColoring (except task 2.3)
    // from https://github.com/Microsoft/QuantumKatas


    // In this assignment the oracles are defined by their effect on computational basis states,
    // as described in the lecture.

    // All oracles have to be adjointable; adjoint variant of the operation can be specified either 
    // automatically (using "is Adj" in the operation signature) or manually (using "body" and "adjoint self"); 
    // see https://docs.microsoft.com/en-us/quantum/user-guide/using-qsharp/operations-functions#explicit-specialization-declarations
    // for details on how to specify variants explicitly.   

    // Task 1. |011011...⟩ marking oracle (1 point).
    // Inputs:
    //      1) N qubits in an arbitrary state |x⟩ (input/query register)
    //      2) a qubit in an arbitrary state |y⟩ (target qubit)
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if the bit pattern of x is 011011... (extend or shorten the pattern to appropriate length)
    //                    and 0 otherwise.
    //       Leave the query register in the same state it started in.
    // Example: 
    //       For N = 4, the oracle should mark the state 0110.

    function Pattern(n : Int) : Bool[] {
        mutable pattern = new Bool[n];
        for i in 0..n-1 {
            if (i % 3 == 1 or i % 3 == 2) {
                set pattern w/= i <- true;
            }
        }
        return pattern;
    }
    operation Task1(queryRegister : Qubit[], target : Qubit) : Unit is Adj {

        // get pattern
        let p = Pattern(Length(queryRegister));

        // apply oracle
        let Pattern = ControlledOnBitString(p, X);
        Pattern(queryRegister,target);
        }

    // Task 2. Peres gate (1 point).
    // Input: 3 qubits in an arbitrary state |x⟩.
    // Goal: Implement a three-qubit gate defined by its effect on the basis states
    //       (the qubits are given in order |qs[0], qs[1], qs[2]⟩):
    //       |0 0 0⟩ → |0 0 0⟩
    //       |0 0 1⟩ → |0 0 1⟩
    //       |0 1 0⟩ → |0 1 0⟩
    //       |0 1 1⟩ → |0 1 1⟩
    //       |1 0 0⟩ → |1 1 0⟩
    //       |1 0 1⟩ → |1 1 1⟩
    //       |1 1 0⟩ → |1 0 1⟩
    //       |1 1 1⟩ → |1 0 0⟩
    operation Task2 (qs : Qubit[]) : Unit is Adj {
        // ...
        CNOT(qs[0], qs[1]);
        CNOT(qs[0], qs[2]);
        CCNOT(qs[0], qs[1], qs[2]);
    }


    // Task 3. "Parity of bit length of the input" oracle (2 points).
    // Inputs:
    //      1) N qubits in an arbitrary state |x⟩ (input/query register)
    //      2) a qubit in an arbitrary state |y⟩ (target qubit)
    //
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if the bit length of integer x is odd, 
    //                    and 0 otherwise.
    //       Leave the query register in the same state it started in.
    // The integer written in a bit string using big endian notation: bit string |0011⟩ represents 3,
    // and bit string |1000⟩ represents 8.
    // The bit length of the integer is the smallest number of bits necessary to write it down without leading zeros:
    // for integer 3 it's 2, and for integer 8 it's 4. (For integer 0 we define it as 0.)
    // Example of the oracle effect: 
    //       For N = 4, the oracle should mark the states 0100, 0101, 0110, 0111, and 0001.
    operation Task3 (queryRegister : Qubit[], target : Qubit) : Unit is Adj {
        // ...
        let len = Length(queryRegister);

        for i in 0 .. (len-1) {
            for j in 0 .. (i) {
                X(queryRegister[j]);
            }
        
            Controlled X(queryRegister[0..i], target);
            
            for j in 0 .. (i) {
                X(queryRegister[j]);
            }
        }

        if (len % 2 == 1){
            X(target);
            }

}


    // Task 4. Regexp matching marking oracle (3 points).
    // Inputs:
    //      1) N qubits in an arbitrary state |x⟩ (input/query register)
    //      2) a qubit in an arbitrary state |y⟩ (target qubit)
    //      3) a bit pattern of length N represented as an Int[].
    // k-th element of the pattern encodes the allowed states of the qubit x[k]:
    // 0 and 1 values represent states |0⟩ and |1⟩, respectively, 
    // value -1 represents any state.
    // 
    // Goal: Transform state |x, y⟩ into state |x, y ⊕ f(x)⟩ (⊕ is addition modulo 2),
    //       where f(x) = 1 if the bit string x matches the given pattern, and 0 if it does not.
    //       Leave the query register in the same state it started in.
    //
    // For example, pattern [0, -1, 1] would match two states: |001⟩ and |011⟩;
    // pattern [1, -1, -1] would match four states: |100⟩, |101⟩, |110⟩, and |111⟩.
    //
    // Hints: 
    // 1. See task 5 from the MarkingOracles kata for an example of dealing with a similar task.
    // 2. You might need to use mutable variables in this task. See https://github.com/tcNickolas/q-sharp-pocket-guide-samples/blob/main/samples/chapter%205/mutable-variables-refactoring/Code.qs
    // for an example of refactoring the code to extract mutable variables into a function to keep the quantum code adjointable automatically, or
    // https://github.com/tcNickolas/q-sharp-pocket-guide-samples/blob/main/samples/chapter%205/manual-adjoint-unitary/Code.qs
    // for an example of defining adjoint of an operation manually.
    function BitMatch(qu:Qubit[],pattern : Int[]) : Qubit[] {
        mutable quRegisterList = [];

        for i in 0..Length(qu) - 1 {
            if (pattern[i] != -1) {
                set quRegisterList = quRegisterList+ [qu[i]] ;
            }
        }
        return quRegisterList;
    }
    function RegexMatch(qu:Qubit[],pattern : Int[]) : Bool[] {
        mutable patternSubList =[];

        for i in 0..Length(qu) - 1 {
            if (pattern[i] != -1) {
                set patternSubList = patternSubList + [pattern[i] == 1];
            }
        }
        return patternSubList;
        
    }
    operation Task4 (queryRegister : Qubit[], target : Qubit, pattern : Int[]) : Unit is Adj {
        // ...
        ApplyControlledOnBitString(RegexMatch(queryRegister,pattern), X, BitMatch(queryRegister,pattern),target);
        }
}
