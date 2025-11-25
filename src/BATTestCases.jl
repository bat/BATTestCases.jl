# This file is a part of BATTestCases.jl, licensed under the MIT License (MIT).

"""
    BATTestCases

A collection of test cases for BAT.jl.
"""
module BATTestCases

using LinearAlgebra
using Random
using Statistics
using ArraysOfArrays: nestedview
using ArgCheck: @argcheck
using Distributions
using DocStringExtensions
using QuadGK: quadgk
using Random123: Philox4x
using SpecialFunctions: gamma
using StatsBase


include("rng.jl")
include("funnel.jl")
include("gaussian_shell.jl")
include("multimodal_student_t.jl")

end # module
