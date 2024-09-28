namespace Quantum.SingleQubitSystems {
    
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;

    //////////////////////////////////////////////////////////////////
    // This is the set of programming assignments for the module "Single-qubit systems".
    //////////////////////////////////////////////////////////////////

    // The tasks cover the following topics:
    //  - single-qubit quantum gates
    //  - superposition
    //  - measurement
    //
    // We recommend to solve the following katas before doing these assignments:
    //  - BasicGates, tasks 1.1 - 1.4, 1.7
    //  - Superposition, tasks 1.1, 1.2, 2.1
    //  - Measurements, tasks 1.1 - 1.4
    // from https://github.com/Microsoft/QuantumKatas


    //////////////////////////////////////////////////////////////////
    // Part I. Basic Gates and Superposition
    //////////////////////////////////////////////////////////////////
    
    // Task 1. Prepare uneven superposition (1 point)
    // Input: a qubit in |0⟩ state.
    // Goal: prepare the following state on this qubit: 0.8|0⟩ - 0.6|1⟩.
    // You can prepare this state up to a global phase.
    operation Task1 (q : Qubit) : Unit {
        // ...
        Ry(1.287, q);
        Z(q);
}
    

    
    // Task 2. Prepare states conditionally (2 points)
    // Inputs:
    //    1) a qubit in |0⟩ state.
    //    2) an integer index.
    // Goal: prepared one of the following states based on the value of index:
    //    0: sqrt(1/3) |0⟩ + sqrt(2/3) |1⟩
    //    1: sqrt(2/3) |0⟩ - sqrt(1/3) |1⟩
    // You can prepare this state up to a global phase.
    operation Task2 (q : Qubit, index : Int) : Unit {
        if (index == 0) {
            Ry(2.0 * ArcSin(Sqrt(2.0 / 3.0)), q);
        } elif (index == 1) {
            Ry(2.0 * ArcSin(Sqrt(1.0 / 3.0)), q);
            Z(q); 
        }
    }




    //////////////////////////////////////////////////////////////////
    // Part II. Measurements
    //////////////////////////////////////////////////////////////////
    
    // Task 3. |0⟩ or |1⟩ ? (1 point)
    // Input: a qubit which is guaranteed to be in |0⟩ or |1⟩ state.
    // Output: 0 if the qubit was in |0⟩ state, or 1 if it was in |1⟩ state.
    // The state of the qubit at the end of the operation does not matter.
    operation Task3 (q : Qubit) : Int {
        // ...
        let result = M(q);
        return (result == Zero ? 0 | 1);
    }
    

    // Task 4. Distinguish two states (2 points)
    // Input: a qubit which is guaranteed to be
    //        either in the state sqrt(1/3) |0⟩ + sqrt(2/3) |1⟩ 
    //        or in the state     sqrt(2/3) |0⟩ - sqrt(1/3) |1⟩.
    // Output: 0 if the qubit was in in the first state, or 1 if it was in the second state.
    // The state of the qubit at the end of the operation does not matter.
    operation Task4 (q : Qubit) : Int {
        // ...
    Ry(-1.911, q);
    let result = M(q);
    return (result == Zero ? 0 | 1);
    
    }
    

    // Task 5. Estimate amplitudes given multiple copies of the state (3 points)
    // Input: A quantum operation that, given a qubit in an arbitrary state,
    //        prepares in in a fixed qubit state |ψ⟩ = α |0⟩ + β |1⟩ 
    //        (amplitudes α and β are non-negative real numbers not given to your solution).
    // Output: a tuple of two numbers (α`, β`) - your estimates of the amplitudes α and β.
    //         The absolute errors |α - α`| and |β - β`| should be less than or equal to 0.1.
    // This task will be tested on several different states |ψ⟩; since the task is dependent on measurement results and 
    // can be not deterministic, you will be given 10 attempts for each state |ψ⟩; you need to pass at least one attempt.
    // Please make sure that your solution passes the test in under 5 seconds.
    operation Task5 (statePrep : Qubit => Unit) : (Double, Double) {
        //...
    mutable zeroCount = 0;
    mutable oneCount = 0;
    let numMeasurements = 1000;

    use q = Qubit();

    for i in 1..numMeasurements {
        statePrep(q);
        if (M(q) == Zero) {
            set zeroCount = zeroCount + 1;
        } else {
            set oneCount = oneCount + 1;
        }
        Reset(q);
    }
     let alphaEstimate = Sqrt(IntAsDouble(zeroCount) / IntAsDouble(numMeasurements));
        let betaEstimate = Sqrt(1.0 - alphaEstimate * alphaEstimate);
     
       

     return (alphaEstimate, betaEstimate);

     }
}
