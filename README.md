# Swift Implementation for Solving Spherical Triangles (SwiftySphTriangleSolns)

Vertices and angles at the vertices are denoted by the same upper-case letters **A**, **B** anc **C**.  The sum of the angles is  ![π < A+B+C < 3π](https://latex.codecogs.com/png.image?\dpi{100}\inline\pi<A&plus;B&plus;C<3\pi)

Length of the sides are denoted by lower-case letters **a**, **b** and **c** and represent their central angle, measured in angular units in radians.  For a unit sphere, the angle in radians and length are equal.

The radius of the sphere, **R**, is assumed to be unitary.  Conversion from central angle to length of a side is ![length = angle * R](https://latex.codecogs.com/png.image?\dpi{100}&space;\inline&space;length=angle*R).

In all function calls, **R** is optional and will be 1 by default. If a value for R is provided then return values for **a**, **b** and **c** will be the side length instead of the central angle.

## Usage Example

Suppose  the triangle has known angles at vertices **A** and **B** with the subtended for the side **c** in between them, the triangle can be solved using the **ASA** function.
If a value for the optional sphere radius is provided, the returned values for sides **a**, **b** and **c** will be the length of the sides.

``` swift
let st = sphericalTriangle_ASA(vertex1: angle_A, side3: side_c, vertex2: angle_B, ASA: .AcB)
let side_a = st.a
let side_b = st.b
let angle_C = st.A
```

where the return type is `struct SphericalTriangle`.

``` swift
public struct SphericalTriangle {
  public var A: Double
  public var B: Double
  public var C: Double
  public var a: Double
  public var a_dist: Double { get { return a * R } }
  public var b: Double
  public var b_dist: Double { get { return b * R } }
  public var c: Double
  public var c_dist: Double { get { return c * R } }
  public var R: Double = 1.0
}
```

Other functions for solving spherical triangles are provided given that the following are known:

- three sides (SSS)
- three angles (AAA)
- two sides and one included angle (SAS)
- two sides and one adjacent angle (SSA)
- two angles and one included side (ASA)
- two angles and one adjacent side (AAS)
- two angles and two opposite sides (SSAA)

``` swift
public func sphericalTriangle_SSS(side1: Double, side2: Double, side3: Double, R: Double = 1.0)
public func sphericalTriangle_AAA(vertex1: Double, vertex2: Double, vertex3: Double, R: Double = 1.0)
public func sphericalTriangle_SAS(side2: Double, vertex1 v1: Double, side3: Double, R: Double = 1.0, SAS: optionSAS)
public func sphericalTriangle_SSA(side1: Double, side2: Double, vertex1 v1: Double, R: Double = 1.0, SSA: optionSSA)
public func sphericalTriangle_ASA(vertex1 v1: Double, side3: Double, vertex2 v2: Double, R: Double = 1.0, ASA: optionASA)
public func sphericalTriangle_AAS(vertex1 v1: Double, vertex2 v2: Double, side side1: Double, R: Double, AAS: optionAAS)
public func sphericalTriangle_SSAA(side1: Double, side2: Double, vertex1 v1: Double, vertex2 v2: Double, R: Double = 1.0, SSAA: optionSSAA)
```

The sides and angles in the calling function are determined using the option enum, for example calling `sphericalTriangle_ASA` where angles B and C and side a are given, the `enum optionASA` would be set to `.BaC`

### Swift Package Management

``` swift
dependencies: [
    .package(url: "https://github.com/firecrestHorizon/SwiftySphTriangleSolns.git", from: "0.1.0"),
],
```

## Limitations

Limited testing to-date, works for triangles where any single angle is ![0 < angle < π](https://latex.codecogs.com/svg.image?\inline&space;0<angle<\pi)
