// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.UnitaryGates {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    
    //////////////////////////////////////////////////////////////////
    // This is the set of programming assignments for the module "Unitary gates".
    //////////////////////////////////////////////////////////////////

    // The tasks cover the following topics:
    //  - implementing single- and multi-qubit unitary gates using the primitive gates
    //
    // We recommend to solve the following katas before doing these assignments:
    //  - ComplexNumbers tutorial (to learn about the complex numbers).
    //  - VisualizationTools tutorial (to learn about DumpOperation and the endianness of qubits).
    // from https://github.com/Microsoft/QuantumKatas.
    //
    // The reference text for this module is C.P. Williams, Explorations in Quantum Computing, chapter 2
    // (https://iontrap.umd.edu/wp-content/uploads/2016/01/Quantum-Gates-c2.pdf).
    // It discusses single- and multi-qubit gates with complex coefficients in detail,
    // including the decompositions of gates into sequences of other gates which is the topic of this module.
    
    // In all tasks, your gate implementations should have adjont and controlled variants.
    // As long as you only use classical arithmetic and primitive Q# gates,
    // the compiler will be able to generate those automatically based on the "is Adj + Ctl" suffix in the operation signature.
    // 
    // Your operations should implement the described gates exactly, rather than "up to a global phase".
    // To check this, the tests compare the controlled variant of your operation with a controlled variant of the reference solution;
    // this way any difference in the global phase (not observable directly) becomes a difference in the relative phase (observable).
    //
    // Note that the order of qubits in this task is little endian, matching the order used by DumpOperation operation
    // (see details in the VisualizationTools tutorial). This means that printing the matrix of your operation 
    // using DumpOperation should output exactly the same matrix as the one given in the book.


    // Task 1.  Implement the SQRT(NOT) gate (2 points).
    // Input: a qubit in an arbitrary state.
    // Goal: implement the SQRT(NOT) gate acting on this qubit.
    //       The SQRT(NOT) gate is described on page 72 of Williams chapter 2 (page 22 of the pdf), equation 2.10.
    operation Task1 (q : Qubit) : Unit is Adj + Ctl {
        // ...
        H(q);
        S(q);
        H(q);

    }


    // Task 2.  Implement the iSWAP gate (2 points).
    // Input: two qubits in an arbitrary state.
    // Goal: implement the iSWAP gate acting on these qubits.
    //       The iSWAP gate is described on page 95 of Williams chapter 2 (page 45 of the pdf), equation 2.90.
    operation Task2 (qs : Qubit[]) : Unit is Adj + Ctl {
        // ...
        S(qs[0]);
        S(qs[1]);
        H(qs[0]);
        CNOT(qs[0], qs[1]);
        CNOT(qs[1], qs[0]);
        H(qs[1]);
    }


    // Task 3.  Implement the Barenco gate (3 points).
    // Inputs:
    //      1) two qubits in an arbitrary state.
    //      2) three Double numbers alpha, theta, and phi.
    // Goal: implement the Barenco gate with these parameters acting on these qubits.
    //       The Barenco gate is described on page 93 of Williams chapter 2 (page 43 of the pdf), equation 2.89.
    operation Task3 (qs : Qubit[], alpha : Double, theta : Double, phi : Double) : Unit is Adj + Ctl {
        // ...
        Message($"alpha: {alpha}, theta: {theta}, phi: {phi}");
        let (q1, q2) = (qs[0], qs[1]);
        Controlled Rz([q1],(phi, q2));
        Controlled Rx([q1],(theta, q2));
        Rz(-alpha, q2);
        Controlled Rx([q1], (-theta, q2));
        Controlled Rz([q1], (alpha, q2));
    }

    operation CCRX(theta: Double, control1: Qubit, control2: Qubit, target: Qubit): Unit is Adj + Ctl {
        Controlled Rx([control1, control2], (2.0 * theta, target));
    }
    // Task 4.  Implement the Deutsch gate (3 points).
    // Inputs:
    //      1) three qubits in an arbitrary state.
    //      2) a Double number theta.
    // Goal: implement the Deutsch gate with these parameters acting on these qubits.
    //       The Deutsch gate is described on page 93 of Williams chapter 2 (page 43 of the pdf), equation 2.88.
    operation Task4 (qs : Qubit[], theta : Double) : Unit is Adj + Ctl {
        // ...
        // Length of the register
        // let cosTheta = Cos(theta);
        // let sinTheta = Sin(theta);
        Message($"theta: {theta}");
        Controlled Rz([qs[0]],(PI()/2.0, qs[1]));
        CCRX(theta, qs[0], qs[1], qs[2]);
        // R1(2.0 * PI() - 4.0 * theta, qs[2]); // Apply the global phase (-4iθ)
        // Ry(2.0 * ArcSin(sinTheta), qs[2]); // Rotate around Y-axis by angle 2*asin(sin(θ))
        // R1(2.0 * theta, qs[2]); // Add a relative phase of (2iθ)
    }
}