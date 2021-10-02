# types.jl

export Cohesion_PPM,
Similarity_PPMx, Similarity_NiG_indep, Similarity_NN,
Similarity_PPMxStats, Similarity_NiG_indep_stats, Similarity_NN_stats,
Baseline_measure, Baseline_NormDLUnif,
Hypers_shrinkReg, Hypers_DirLap,
LikParams_PPMx, LikParams_PPMxReg;

abstract type Cohesion_PPM end

abstract type Similarity_PPMx end

mutable struct Similarity_NiG_indep <: Similarity_PPMx

    # IG(sig2; shape=a, scale=b) N(mu; mean=mu0, variance=sig2/sc_div0)

    m0::Real
    sc_div0::Real
    a0::Real
    b0::Real

    lsc_div0::Real
    lga0::Real
    lb0::Real

    Similarity_NiG_indep(m0, sc_div0, a0, b0) = new(m0, sc_div0, a0, b0,
        log(sc_div0), SpecialFunctions.loggamma(a0), log(b0))
end

mutable struct Similarity_NN <: Similarity_PPMx

    # N(zeta, sd=sd)
    # zeta ~ N(m0, sd=sd0)

    sd::Real
    m0::Real
    sd0::Real
end


abstract type Similarity_PPMxStats end

mutable struct Similarity_NiG_indep_stats <: Similarity_PPMxStats
    n::Int
    sumx::Real
    sumx2::Real
end

mutable struct Similarity_NN_stats <: Similarity_PPMxStats
    n::Int
    sumx::Real
    sumx2::Real
end


abstract type Baseline_measure end

mutable struct Baseline_NormDLUnif <: Baseline_measure
    mu0::Real
    sig0::Real

    tau0::Real # global shrinkage scale

    upper_sig::Real
end

abstract type Hypers_shrinkReg end

mutable struct Hypers_DirLap{T <: Real} <: Hypers_shrinkReg
    phi::Vector{T}
    psi::Vector{T}
    tau::Real
end

abstract type LikParams_PPMx end

mutable struct LikParams_PPMxReg{T <: Real} <: LikParams_PPMx
    mu::Real
    sig::Real

    beta::Vector{T}
    beta_hypers::Hypers_shrinkReg

    # LikParams_PPMxReg(mu, sig, beta, beta_hypers) = sig <= 0.0 ? error("St. deviation must be positive.") : new(mu, sig, beta, beta_hypers)
end
