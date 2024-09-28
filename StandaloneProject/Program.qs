namespace Quantum.StandaloneProject {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    
    @EntryPoint()
    operation HelloQ () : Unit {
        Message("Hello quantum world!");

        use q = Qubit();
        mutable nOnes = 0;
        for _ in 1 .. 100 {
            Ry(2.345, q);
            if MResetZ(q) == One {
                set nOnes += 1;
            }
        }
        Message($"Measured {nOnes} Ones out of 100 runs");
    }
}
