// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.QAOA {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;

    open Quantum.QAOA.TestingHarness;

    @Test("SparseSimulator")
    operation T2_Test () : Unit {
        T2_TestingHarness(Task2);
    }


    @Test("SparseSimulator")
    operation T3_Test () : Unit {
        T3_TestingHarness(Task3);
    }
}
