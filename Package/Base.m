// The base ring we work over for the Hecke algebra is the Laurent polynomials.
// In Magma, a built-in structure that does this is the Laurent series.
_LaurentPolyRing<v> := LaurentSeriesRing(Integers());
AssignNames(~_LaurentPolyRing, ["v"]);
_v := _LaurentPolyRing.1;

intrinsic IHeckeVersion() -> MonStgElt
{Report version information for IHecke.}
    return "IHecke version 2021-08-18";
end intrinsic;


///////////////////////////////
// Free module (abstract class)
//
// This represents a module which is free over the commutative ring BaseRing, with basis elements
// indexed by (potentially a strict subset of) a Coxeter group. We wil have three core types
// inheriting from IHkeFMod: the Hecke algebra, and the spherical and antispherical modules.

// Attaching the Coxeter group here makes things slightly less general (if we were going fully
// general, we would make yet another type in between this one and the Hecke algebra / spherical /
// antispherical modules). However assuming that our basis elements are always Coxeter group elements
// simplifies a lot of stuff, like the '.' operator, and defining basis transformations.
declare type IHkeFMod;
declare attributes IHkeFMod:
    Name,           // Human-readable name for the module.
    BaseRing,       // Commutative ring this module is over (Laurent polynomials, integers, ...)
    CoxeterGroup,   // Coxeter group of finitely presented type (a GrpFPCox).
    CoxeterMatrix,  // Useful during equality or compatibility comparisons.
    BasisCache;     // An associative array mapping types to instantiations of those bases.


procedure _IHkeFModInit(~fmod, baseRing, name, grp)
    assert ISA(Type(baseRing), Rng);
    assert Type(name) eq MonStgElt;
    assert Type(grp) eq GrpFPCox;

    fmod`BaseRing := baseRing;
    fmod`Name := name;
    fmod`CoxeterGroup := grp;
    fmod`CoxeterMatrix := CoxeterMatrix(grp);
    fmod`BasisCache := AssociativeArray();
end procedure;

intrinsic Print(M::IHkeFMod)
{}
    printf "%o", M`Name;
end intrinsic;

intrinsic BaseRing(M::IHkeFMod) -> Rng
{}
    return M`BaseRing;
end intrinsic;

intrinsic CoxeterGroup(M::IHkeFMod) -> GrpFPCox
{}
    return M`CoxeterGroup;
end intrinsic;

intrinsic 'eq'(fmodA::IHkeFMod, fmodB::IHkeFMod) -> BoolElt
{Fallback implementation for equality (assume false). Types extending IHkeFMod must override this.}
    return false;
end intrinsic;

intrinsic DefaultBasis(M::IHkeFMod) -> AlgIHkeBase
{Fallback implementation for default basis. Types extending IHkeFMod must override this.}
    error "No default basis defined for", M;
end intrinsic;