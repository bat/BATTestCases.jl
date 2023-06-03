# This file is a part of BATTestCases.jl, licensed under the MIT License (MIT).

import Test

Test.@testset "Package BATTestCases" begin
    # include("test_aqua.jl")
    include("test_funnel.jl")
    include("test_gaussian_shell.jl")
    include("test_multimodal_student_t.jl")
    include("test_docs.jl")
    isempty(Test.detect_ambiguities(BATTestCases))
end # testset
