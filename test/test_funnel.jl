using BATTestCases
using Test

using Statistics, StatsBase, Distributions
using HypothesisTests

@testset "Funnel Distribution" begin
    Test.@testset "FunnelDistribution ctor" begin
        for i in 2:6
            a = randn()
            b = randn()
            funnel = FunnelDistribution(a=a, b=b, n=i)
            @test mean(funnel) == zeros(i)
            @test StatsBase.params(funnel) == (a, b, i)
        end
    end

    #Tests different forms of instantiate Funnel Distribution
    @test @inferred(FunnelDistribution(1., 2., 3)) isa FunnelDistribution
    @test @inferred(FunnelDistribution()) isa FunnelDistribution
    @test @inferred(FunnelDistribution(a = 1.0, b = 0.5, n = 3)) isa FunnelDistribution

    funnel = FunnelDistribution(a = Float32(1.0), b = Float32(0.5), n = Int32(3))

    #Check Parameters
    @test @inferred(StatsBase.params(funnel)) == (Float32(1.0), Float32(0.5), Int32(3))

    @test @inferred(Base.length(funnel)) == 3 #Number of dimensions
    @test @inferred(Base.eltype(funnel)) == Float32 #Element Type

    #Check mean and covariance
    @test @inferred(Statistics.mean(funnel)) == [0.0, 0.0, 0.0] #Check mean
    @test isapprox(@inferred(Statistics.cov(funnel)), [1.00256 -0.0124585 -0.00373376; 
    -0.0124585 7.04822 -0.165097;  -0.00373376  -0.165097  7.1126], rtol = 1e-1, atol = 0)

    #logpdf
    @test isapprox(@inferred(Distributions._logpdf(funnel, [0., 0., 0.])), -2.75681, atol = 1e-5)

    #KS Test
    #Test the constant-variance Gaussian
    funnel = FunnelDistribution(a = 1., b = 0., n = 1)
    ks_test = HypothesisTests.ExactOneSampleKSTest(rand(funnel, 10^6)[:], Normal(0., 1.))
    @test pvalue(ks_test) > 0.01  # ToDo: Try to increase to 0.05
    
    #Test the variable-variance Gaussian
    funnel = FunnelDistribution(a = 0., b = 0., n = 2)
    ks_test = HypothesisTests.ExactOneSampleKSTest(rand(funnel, 10^6)[2,:], Normal(0., 1.))
    @test pvalue(ks_test) > 0.01  # ToDo: Try to increase to 0.05
end
