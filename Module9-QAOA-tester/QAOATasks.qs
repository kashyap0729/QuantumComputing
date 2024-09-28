// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.QAOA {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;

    //////////////////////////////////////////////////////////////////
    // This is the testing harness for the QAOA assignment (module "Hybrid Quantum Algorithms").
    // You submit this assignment as a Jupyter Notebooks with 4 tasks!
    // This testing harness is designed only to help you validate your solutions for tasks 2-3.
    //////////////////////////////////////////////////////////////////

    // Task 2.  QAOA phase change unitary (4 points).
    operation Task2(qs : Qubit[], gamma : Double) : Unit is Adj + Ctl {
        // ...
        let N = Length(qs);
        for i in 0..N - 2 {
            CNOT(qs[i + 1], qs[i]);
            Controlled R1([qs[i]], (-2.0 * gamma, qs[i + 1]));
        }
    for i in N - 1.. -1..1 {
            CNOT(qs[i], qs[i - 1]);
        }
        // let n = Length(qs);
        // for i in 0..n - 2 {
        //     ApplyControlledOnInt(0, Rz, [qs[i], qs[i + 1]], (-2.0 * gamma, qs[i]));
        //     ApplyControlledOnInt(3, Rz, [qs[i], qs[i + 1]], (-2.0 * gamma, qs[i]));
        // }
    }


    // Task 3.  QAOA mixer unitary (3 points).
    operation Task3(qs : Qubit[], beta : Double) : Unit is Adj + Ctl {
        // ...
    }
}