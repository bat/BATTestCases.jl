# This file is a part of BATTestCases.jl, licensed under the MIT License (MIT).

using BATTestCases
using Test

using Statistics, StatsBase, Distributions
using HypothesisTests

@testset "MultimodalStudentT" begin
    Test.@testset "MultimodalStudentT ctor" begin
        @test_throws ArgumentError BAT.MultimodalStudentT(n=1)
        for i in 2:6
            μ = randn()
            σ = rand(0.01:0.1:2)
            mmc = BAT.MultimodalStudentT(μ=μ,σ=σ, ν=1, n=i)
            @test isequal(mean(mmc), fill(NaN, i))
            @test isequal(var(mmc), fill(NaN, i))
            @test isequal(diag(cov(mmc)), fill(NaN, i))
            ps = StatsBase.params(mmc)
            @test sort(ps[1]) == sort(vcat([μ, -μ], zeros(i-2)))
            @test ps[2] == [σ for j in 1:i]
            @test ps[3] == i
        end
    end

    cm = MixtureModel([Distributions.TDist(1), Distributions.TDist(1)])
    prod = Distributions.product_distribution([Distributions.TDist(1), Distributions.TDist(1)])

    #Instantiates multimodal Student T with Mixture Model and Product
    @test @inferred(MultimodalStudentT(cm, 0.1, 2, prod)) isa MultimodalStudentT
    #Instantiates multimodal Student T with μ, σ and n
    @test @inferred(MultimodalStudentT(μ=60, σ=1., ν = 3, n = 2)) isa MultimodalStudentT
    #Error if n = 1
    @test_throws ArgumentError  MultimodalStudentT(μ=60, σ=1., ν = 3, n = 1)

    #If n = 1, student t = cauchy
    mt = MultimodalStudentT(μ = 1., σ = 0.1, ν = 1, n=4)

    @test @inferred(Base.size(mt)) == (4,)
    @test @inferred(Base.length(mt)) == 4
    @test @inferred(Base.eltype(mt)) == Float64
    @test all(isnan, Statistics.var(mt))
    @test all(isnan, Statistics.mean(mt))

    params = @inferred(StatsBase.params(mt))
    
    #Parameters
    @test params[1] == [-1., 1., 0., 0.]
    @test params[2] == [0.1, 0.1, 0.1, 0.1]
    @test params[3] == 4

    #logpdf
    @test @inferred(Distributions._logpdf(mt, [-1., 0., 1., 2.])) == -11.283438151658

    #If μ = 0, d = 1 the Distribution should be Cauchy-like in every dimension
    mmc = MultimodalStudentT(μ = 0., σ = 0.1, ν = 1, n=2)
    ks_test = HypothesisTests.ExactOneSampleKSTest(rand(mmc, 10^6)[1,:], Cauchy(0., 0.1))#First dimension
    @test pvalue(ks_test) > 0.01  # ToDo: Try to increase to 0.05
    ks_test = HypothesisTests.ExactOneSampleKSTest(rand(mmc, 10^6)[2,:], Cauchy(0., 0.1))#Second dimension
    @test pvalue(ks_test) > 0.01  # ToDo: Try to increase to 0.05

    #If μ = 0, ν > 1 the Distribution should be Student t-like in every dimension
    mmc = MultimodalStudentT(μ = 0., σ = 0.1, ν = 3, n=4)
    tdist = LocationScale(0, 0.1, TDist(3))
    ks_test = HypothesisTests.ExactOneSampleKSTest(rand(mmc, 10^6)[1,:], tdist)
    @test pvalue(ks_test) > 0.01  # ToDo: Try to increase to 0.05
    ks_test = HypothesisTests.ExactOneSampleKSTest(rand(mmc, 10^6)[2,:], tdist)
    @test pvalue(ks_test) > 0.01  # ToDo: Try to increase to 0.05

    @test ~any(isnan, Statistics.var(mmc))
    @test ~any(isnan, Statistics.mean(mmc))
end
