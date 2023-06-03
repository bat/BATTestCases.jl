# This file is a part of BATTestCases.jl, licensed under the MIT License (MIT).

import Test
import Aqua
import BATTestCases

Test.@testset "Aqua tests" begin
    Aqua.test_all(BATTestCases)
end # testset
