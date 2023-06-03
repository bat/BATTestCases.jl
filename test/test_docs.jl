# This file is a part of BATTestCases.jl, licensed under the MIT License (MIT).

using Test
using BATTestCases
import Documenter

Documenter.DocMeta.setdocmeta!(
    BATTestCases,
    :DocTestSetup,
    :(using BATTestCases);
    recursive=true,
)
Documenter.doctest(BATTestCases)
