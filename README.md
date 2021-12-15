# AdventOfCode
My solutions in Swift to the Advent of Code challenges.

This repository contains an Xcode project that creates a Command Line Tool (and copies it into your `$HOME` directory after building).

You can find the individual solutions in the [ChallengeSolvers](./AdventOfCode/ChallengeSolvers) directory, with each year having a subdirectory.

## Tests
There are basic tests to make updates to shared methods easier to validate.
There is a suite for each year that all inherit from a shared suite (which is disabled in the schemes).
It's a little messy, but it makes it easy to add new years/challenge solutions.

Command Line Tool targets do not support tests very well, so most source files are directly included in the test target.
The argument parser framework does not work in test targets.
To resolve this a `TESTING` compilation condition was setup for the testing target that can be used to exclude any imports/usage of the framework in files included in the test target.
