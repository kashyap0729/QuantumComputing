// Copyright (c) Microsoft Corporation. All rights reserved.

namespace Quantum.QPEQFT {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;

    open Quantum.QPEQFT.TestingHarness;

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

    @Test("SparseSimulator")
    operation T5_Test () : Unit {
        T5_TestingHarness(Task5);
    }

    @Test("SparseSimulator")
    operation T6_Test () : Unit {
        T6_TestingHarness(Task6);
    }
}
