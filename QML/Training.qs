// Licensed under the MIT License.

namespace Microsoft.Quantum.Samples {
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.MachineLearning;
    open Microsoft.Quantum.MachineLearning.Datasets as Datasets;
    open Microsoft.Quantum.Math;

    function DefaultSchedule(samples : LabeledSample[]) : SamplingSchedule {
        return SamplingSchedule([
            0..Length(samples) - 1
        ]);
    }
    function DefaultSchedule1(samples : Double[][]) : SamplingSchedule {
        return SamplingSchedule([
            0..Length(samples) - 1
        ]);
    }

    function ClassifierStructure() : ControlledRotation[] {
        return [
            ControlledRotation((0, new Int[0]), PauliX, 4),
            ControlledRotation((0, new Int[0]), PauliZ, 5),
            ControlledRotation((1, new Int[0]), PauliX, 6),
            ControlledRotation((1, new Int[0]), PauliZ, 7),
            ControlledRotation((0, [1]), PauliX, 0),
            ControlledRotation((1, [0]), PauliX, 1),
            ControlledRotation((1, new Int[0]), PauliZ, 2),
            ControlledRotation((1, new Int[0]), PauliX, 3),

            ControlledRotation((2, new Int[0]), PauliX, 12),
            ControlledRotation((2, new Int[0]), PauliZ, 13),
            // ControlledRotation((3, new Int[0]), PauliX, 14),
            // ControlledRotation((3, new Int[0]), PauliZ, 15),
            ControlledRotation((2, [0]), PauliX, 8)
            // ControlledRotation((3, [2]), PauliX, 9),
            // ControlledRotation((3, new Int[0]), PauliZ, 10),
            // ControlledRotation((3, new Int[0]), PauliX, 11)
        ];
    }

    operation SampleSingleParameter() : Double {
        return PI() * (DrawRandomDouble(0.0, 1.0) - 1.0);
    }

    operation SampleParametersForSequence(structure : ControlledRotation[]) : Double[] {
        return ForEach(SampleSingleParameter, ConstantArray(Length(structure), ()));
    }

    operation SampleInitialParameters(nInitialParameterSets : Int, structure : ControlledRotation[]) : Double[][] {
        return ForEach(SampleParametersForSequence, ConstantArray(nInitialParameterSets, structure));
    }

    operation TrainWineModel(
        trainingVectors : Double[][],
        trainingLabels : Int[],
        initialParameters : Double[][]
        ) : (Double[], Double) {
        // Get the first 143 samples to use as training data.
        let samples = Mapped(
            LabeledSample,
            Zipped(Preprocessed(trainingVectors), trainingLabels)
        );
        let structure = ClassifierStructure();
        // Sample a random set of parameters.
        // let initialParameters = SampleInitialParameters(16, structure);

        Message("Ready to train.");
        let (optimizedModel, nMisses) = TrainSequentialClassifier(
            Mapped(
                SequentialModel(structure, _, 0.0),
                initialParameters
            ),
            samples,
            DefaultTrainingOptions()
                w/ LearningRate <- 0.4
                w/ MinibatchSize <- 1000
                w/ Tolerance <- 0.01
                w/ NMeasurements <- 100
                w/ MaxEpochs <- 10
                w/ VerboseMessage <- Message,
            DefaultSchedule1(trainingVectors),
            DefaultSchedule1(trainingVectors)
        );
        Message($"Training complete, found optimal parameters and bias: {optimizedModel::Parameters}, {optimizedModel::Bias}");
        return (optimizedModel::Parameters, optimizedModel::Bias);
    }

    operation ValidateWineModel(
        parameters : Double[],
        bias : Double
    ) : Int {
        // Get the remaining samples to use as validation data.
        let samples = (Datasets.WineData())[143...];
        let tolerance = 0.005;
        let nMeasurements = 10000;
        let results = ValidateSequentialClassifier(
            SequentialModel(ClassifierStructure(), parameters, bias),
            samples,
            tolerance,
            nMeasurements,
            DefaultSchedule(samples)
        );
        return results::NMisclassifications;
    }
    function Preprocessed(samples : Double[][]) : Double[][] {
        let scale = 1.0;

        return Mapped(
            WithProductKernel(scale, _),
            samples
        );
    }
    function WithProductKernel(scale : Double, sample : Double[]) : Double[] {
        return sample + [scale * Fold(TimesD, 1.0, sample)];
    }
}
