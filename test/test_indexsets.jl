## Index ##
verbose && print("testing index creation...")

i = Index(1,2,3)
@test typeof(i) <: Index
@test i == Index([1,2,3])
@test i == Index("[1,2,3]")
@test Index(0) == Index("[0]")

@test_throws ArgumentError Index("1,2,3")
@test_throws ArgumentError Index("1,b,3")
@test_throws ArgumentError Index("")
@test_throws MethodError Index(0.)

verbose && println("done")

verbose && print("testing index operators...")

@test zero(i) == Index(0,0,0)
@test one(i) == Index(1,1,1)
@test Index(2,4,6) == 2*i
@test Index(2,4,6) == i*2
@test Index(2,4,6) == Index(2,2,2)*i
@test Index(0,0,0) < i
@test i > Index(0,2,3)
@test i > Index(1,2,2)
@test i > Index(0,2,2)
@test Index(2,4,6) == i+i
@test Index(2,4,6) == Index(1,3,5)+1
@test Index(2,3,4)-1 == i
@test i[1] == 1 && i[2] == 2 && i[3] == 3
@test maximum(i) == 3
@test indmax(i) == 3
@test sum(i) == 6
@test prod(i) == 6
i[1] = 2
@test i[1] == 2 && i[2] == 2 && i[3] == 3
@test diff(i,Index(1,2,3)) == 1
@test i == copy(i)

verbose && println("done")

## Indexset ##
verbose && print("testing index set creation...")

td = TD(3)
sl = SL()
@test ndims(td) == 3
@test ndims(sl) == 1
@test_throws MethodError SL(2)
@test_throws BoundsError TD(0)
@test_throws BoundsError FT(0)
@test_throws BoundsError AD(0)
@test_throws ArgumentError TD(Float64[])
@test_throws ArgumentError TD([1.,1.,0.])
@test_throws MethodError TD([1,1,0])
@test_throws ArgumentError TD([1.,1.,-1.])

verbose && println("done")

verbose && print("testing index set methods...")

@test length(getIndexSet(td,2)) == 10
@test length(getBoundary(getIndexSet(td,2))) == 6
indexset = getIndexSet(td,3)
@test isAdmissable(indexset,Index(4,0,0))
@test_throws MethodError isAdmissable(indexset,Index(0,0))
@test !isAdmissable(indexset,Index(0,0,0))
@test !isAdmissable(indexset,Index(0,0,6))
indexset_sorted = sort(indexset)
@test indexset_sorted[1] == Index(0,0,0)
@test indexset_sorted[end] == Index(3,0,0)

verbose && println("done")

verbose && println("testing print method...")

prettyprint(getIndexSet(TD(2),2))

verbose && println("done")

