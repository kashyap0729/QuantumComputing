// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.QEC {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;

    open Quantum.QEC.TestingHarness;

    @Test("SparseSimulator")
    operation T1_Test () : Unit {
        T1_TestingHarness(Task1);
    }

    @Test("SparseSimulator")
    operation T2_Test () : Unit {
        T2_TestingHarness(Task2);
    }

    @Test("SparseSimulator")
    operation T3_Test () : Unit {
        T3_TestingHarness(Task3);
    }

    @Test("SparseSimulator")
    operation T4_Test () : Unit {
        T4_TestingHarness(Task4);
    }
}
