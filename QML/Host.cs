
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.Reflection;
using System.Threading.Tasks;
using System.Diagnostics;
using static System.Math;

namespace Microsoft.Quantum.Samples
{
    using Microsoft.Quantum.MachineLearning;

    class Program
    {
        static async Task Main(string[] args)
        {
            var data = await LoadData(Path.Join(Path.GetDirectoryName(Assembly.GetEntryAssembly().Location), "data.json"));

            // Next, we initialize a full state-vector simulator as our target machine.
            using var targetMachine = new QuantumSimulator().WithTimestamps();
            var parameterStartingPoints = new[]
           { new [] {0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  5.34396 ,0.060057, 3.00522,  2.03083,  0.63527,  1.03771,  2.03083,  0.63527,  1.03771},
                new [] {0.586514, 3.371623, 0.860791, 2.92517,  1.14616, 2.99776, 2.26505,  5.62137,0.060057, 3.00522,  2.03083,  0.63527,  1.03771,  2.03083,  0.63527,  1.03771},
                // new [] {1.69704,  1.13912,  2.3595,   4.037552, 1.63698, 1.27549, 0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  2.03083,  0.63527,  1.03771},
                // new [] {5.21662,  6.04363,  0.224184, 1.53913, 0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  5.34396,  1.64524,  2.03083,  0.63527,  1.03771},
                // new [] {0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  5.34396 ,0.060057, 3.00522,  2.03083,  0.63527,  1.03771,  2.03083,  0.63527,  1.03771},
                // new [] {0.586514, 3.371623, 0.860791, 2.92517,  1.14616, 2.99776, 2.26505,  5.62137,0.060057, 3.00522,  2.03083,  0.63527,  1.03771,  2.03083,  0.63527,  1.03771},
                // new [] {1.69704,  1.13912,  2.3595,   4.037552, 1.63698, 1.27549, 0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  2.03083,  0.63527,  1.03771},
                // new [] {5.21662,  6.04363,  0.224184, 1.53913, 0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  5.34396,  1.64524,  2.03083,  0.63527,  1.03771},  new [] {0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  5.34396 ,0.060057, 3.00522,  2.03083,  0.63527,  1.03771,  2.03083,  0.63527,  1.03771},
                // new [] {0.586514, 3.371623, 0.860791, 2.92517,  1.14616, 2.99776, 2.26505,  5.62137,0.060057, 3.00522,  2.03083,  0.63527,  1.03771,  2.03083,  0.63527,  1.03771},
                // new [] {1.69704,  1.13912,  2.3595,   4.037552, 1.63698, 1.27549, 0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  2.03083,  0.63527,  1.03771},
                // new [] {5.21662,  6.04363,  0.224184, 1.53913, 0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  5.34396,  1.64524,  2.03083,  0.63527,  1.03771},
                // new [] {0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  5.34396 ,0.060057, 3.00522,  2.03083,  0.63527,  1.03771,  2.03083,  0.63527,  1.03771},
                // new [] {0.586514, 3.371623, 0.860791, 2.92517,  1.14616, 2.99776, 2.26505,  5.62137,0.060057, 3.00522,  2.03083,  0.63527,  1.03771,  2.03083,  0.63527,  1.03771},
                // new [] {1.69704,  1.13912,  2.3595,   4.037552, 1.63698, 1.27549, 0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  2.03083,  0.63527,  1.03771},
                new [] {5.21662,  6.04363,  0.224184, 1.53913, 0.060057, 3.00522,  2.03083,  0.63527,  1.03771, 1.27881, 4.10186,  5.34396,  1.64524,  2.03083,  0.63527,  1.03771}
            };
            // Once we initialized our target machine,
            // we can then use that target machine to train a QCC classifier.
            var (optimizedParameters, optimizedBias) = await TrainWineModel.Run(
                targetMachine,
                new QArray<QArray<double>>(data.TrainingData.Features.Select(vector => new QArray<double>(vector))),
                new QArray<long>(data.TrainingData.Labels),
                new QArray<QArray<double>>(parameterStartingPoints.Select(parameterSet => new QArray<double>(parameterSet)))
            );

            // After training, we can use the validation data to test the accuracy
            // of our new classifier.
            var testMisses = await ValidateWineModel.Run(
                targetMachine,
                optimizedParameters,
                optimizedBias
            );
            System.Console.WriteLine($"Observed {testMisses} misclassifications.");
        }
        class LabeledData
        {
            public List<double[]> Features { get; set; }
            public List<long> Labels { get; set; }
        }
        class DataSet
        {
            public LabeledData TrainingData { get; set; }
            public LabeledData ValidationData { get; set; }
        }
        static async Task<DataSet> LoadData(string dataPath)
        {
            using var dataReader = File.OpenRead(dataPath);
            return await JsonSerializer.DeserializeAsync<DataSet>(
                dataReader
            );
        }
    }

    public static class SimulatorExtensions
    {
        public static QuantumSimulator WithTimestamps(this QuantumSimulator sim)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();
            var last = stopwatch.Elapsed;
            sim.DisableLogToConsole();
            sim.OnLog += (message) =>
            {
                var now = stopwatch.Elapsed;
                Console.WriteLine($"[{now} +{now - last}] {message}");
                last = now;
            };
            return sim;
        }

    }
}
