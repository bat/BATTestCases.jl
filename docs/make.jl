# Use
#
#     DOCUMENTER_DEBUG=true julia --color=yes make.jl local [nonstrict] [fixdoctests]
#
# for local builds.

using Documenter
using BATTestCases

# Doctest setup
DocMeta.setdocmeta!(
    BATTestCases,
    :DocTestSetup,
    :(using BATTestCases);
    recursive=true,
)

makedocs(
    sitename = "BATTestCases",
    modules = [BATTestCases],
    format = Documenter.HTML(
        prettyurls = !("local" in ARGS),
        canonical = "https://bat.github.io/BATTestCases.jl/stable/"
    ),
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
        "LICENSE" => "LICENSE.md",
    ],
    doctest = ("fixdoctests" in ARGS) ? :fix : true,
    linkcheck = !("nonstrict" in ARGS),
    strict = !("nonstrict" in ARGS),
)

deploydocs(
    repo = "github.com/bat/BATTestCases.jl.git",
    forcepush = true,
    push_preview = true,
)
