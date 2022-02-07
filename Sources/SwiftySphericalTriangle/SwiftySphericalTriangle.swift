import Foundation

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
  public func describe() {
    print("""
          A: \(String(format: "%.9f°", locale: Locale(identifier: "en"), 180*A/Double.pi))   a: \(String(format: "%.9f", locale: Locale(identifier: "en"), a))   dist: \(String(format: "%12.3f", locale: Locale(identifier: "en"), a_dist))
          B: \(String(format: "%.9f°", locale: Locale(identifier: "en"), 180*B/Double.pi))   b: \(String(format: "%.9f", locale: Locale(identifier: "en"), b))   dist: \(String(format: "%12.3f", locale: Locale(identifier: "en"), b_dist))
          C: \(String(format: "%.9f°", locale: Locale(identifier: "en"), 180*C/Double.pi))   c: \(String(format: "%.9f", locale: Locale(identifier: "en"), c))   dist: \(String(format: "%12.3f", locale: Locale(identifier: "en"), c_dist))
          """)
  }
}

/**
 # Three sides provided (SSS)
 Known: the sides a, b, c (in angular units).
 The triangle's angles are computed using the spherical law of cosines
 - Parameter a: side a.  Angular unit if R=1, else length of side a
 - Parameter b: side b.  Angular unit if R=1, else length of side b
 - Parameter c: side c.  Angular unit if R=1, else length of side c
 - Parameter R: radius of sphere.  R=1 will use a unitary sphere
 */
public func sphericalTriangle_SSS(side1: Double, side2: Double, side3: Double, R: Double = 1.0) -> SphericalTriangle {
  let s1 = side1/R; let s2 = side2/R; let s3 = side3/R
  
  let A = acos( (cos(s1) - cos(s2) * cos(s3)) / (sin(s2) * sin(s3)) )
  let B = acos( (cos(s2) - cos(s3) * cos(s1)) / (sin(s1) * sin(s3)) )
  let C = acos( (cos(s3) - cos(s1) * cos(s2)) / (sin(s1) * sin(s2)) )
  
  return SphericalTriangle(A: A, B: B, C: C, a: s1, b: s2, c: s3, R: R)
}

/**
 # Three angles provided (AAA)
 Known: the angkes A, B, C (in radians).
 The triangle's sides are computed using the rule of cosines
 - Parameter A: angle A
 - Parameter B: angle B
 - Parameter C: ange C
 - Parameter R: radius of sphere.  R=1 will use a unitary sphere
 */
public func sphericalTriangle_AAA(vertex1: Double, vertex2: Double, vertex3: Double, R: Double = 1.0) -> SphericalTriangle {
  let A = vertex1; let B = vertex2; let C = vertex3
    
  var a = acos( (cos(A) + cos(B) * cos(C)) / (sin(B) * sin(C)) )
  var b = acos( (cos(B) + cos(A) * cos(C)) / (sin(A) * sin(C)) )
  var c = acos( (cos(C) + cos(A) * cos(B)) / (sin(A) * sin(B)) )

  if a.isNaN { a = 1.0e-15 }
  if b.isNaN { b = 1.0e-15 }
  if c.isNaN { c = 1.0e-15 }

  return SphericalTriangle(A: A, B: B, C: C, a: a, b: b, c: c, R: R)
}

public enum optionSAS {
  case bAc
  case cBa
  case aCb
}
/**
 # Two sides and the inlcuded angle provided (SAS)
 Known: two sides (in angular units) and the angle in between
 The triangle's angles are computed using the spherical law of cosines
 - Parameter side2: side 2.  Angular unit if R=1, else length of side 2
 - Parameter vertex1: included vertex angle 1
 - Parameter side3: side 3.  Angular unit if R=1, else length of side 3
 - Parameter SAS: enum stating which sides and angle are provided (bAc, cBa or aCb)
 - Parameter R: radius of sphere.  R=1 will use a unitary sphere
 */
public func sphericalTriangle_SAS(side2: Double, vertex1 v1: Double, side3: Double, R: Double = 1.0, SAS: optionSAS) -> SphericalTriangle {
  let s2 = side2 / R
  let s3 = side3 / R
  let s1 = acos( cos(s2) * cos(s3) + sin(s2) * sin(s3) * cos(v1) )
  let side1 = s1 * R
  
  switch SAS {
  case .bAc:
    return sphericalTriangle_SSS(side1: side1, side2: side2, side3: side3, R: R)
  case .cBa:
    return sphericalTriangle_SSS(side1: side3, side2: side1, side3: side2, R: R)
  case .aCb:
    return sphericalTriangle_SSS(side1: side2, side2: side3, side3: side1, R: R)
  }
}

public enum optionSSA {
  case abA
  case bcB
  case caC
}
/**
 # Two sides and the non-included angle provided (SSA)
 Known: two sides (in angular units) and the angle not between them
 The triangle's angles are computed using the spherical law of sines, then a further check using SSAA
 - Parameter side1: side 2.  Angular unit if R=1, else length of side 1
 - Parameter side2: side 2.  Angular unit if R=1, else length of side 2
 - Parameter vertex1: included vertex angle 1
 - Parameter SSA: enum stating which sides and angle are provided (abA, bcB, caC)
 - Parameter R: radius of sphere.  R=1 will use a unitary sphere
 */
public func sphericalTriangle_SSA(side1: Double, side2: Double, vertex1 v1: Double, R: Double = 1.0, SSA: optionSSA) -> SphericalTriangle {
  let s1 = side1 / R
  let s2 = side2 / R
  
  let v2 = asin( sin(v1) * sin(s2) / sin(s1) )
  
  switch SSA {
  case .abA:
    return sphericalTriangle_SSAA(side1: side1, side2: side2, vertex1: v1, vertex2: v2, R: R, SSAA: .abAB)
  case .bcB:
    return sphericalTriangle_SSAA(side1: side1, side2: side2, vertex1: v1, vertex2: v2, R: R, SSAA: .bcBC)
  case .caC:
    return sphericalTriangle_SSAA(side1: side1, side2: side2, vertex1: v1, vertex2: v2, R: R, SSAA: .caCA)
  }
}

public enum optionASA {
  case AcB
  case BaC
  case CbA
}
/**
 # Two angles and the side between (ASA)
 Known: two angles and the side between them
 The triangle's angles are computed using the spherical law of cosines, then a further check using AAA
 - Parameter vertex1: vertex angle 1
 - Parameter side3: side .  Angular unit if R=1, else length of side3
 - Parameter vertex2: vertex angle 2
 - Parameter ASA: enum stating which sides and angle are provided (AcB, BaC, CbA)
 - Parameter R: radius of sphere.  R=1 will use a unitary sphere
 */
public func sphericalTriangle_ASA(vertex1 v1: Double, side3: Double, vertex2 v2: Double, R: Double = 1.0, ASA: optionASA) -> SphericalTriangle {
  let s3 = side3 / R

  let v3 = acos( sin(v1)*sin(v2)*cos(s3) - cos(v1)*cos(v2) )
  
  switch ASA {
  case .AcB:
    return sphericalTriangle_AAA(vertex1: v1, vertex2: v2, vertex3: v3, R: R)
  case .BaC:
    return sphericalTriangle_AAA(vertex1: v3, vertex2: v1, vertex3: v2, R: R)
  case .CbA:
    return sphericalTriangle_AAA(vertex1: v2, vertex2: v3, vertex3: v1, R: R)
  }
}

public enum optionAAS {
  case ABa
  case BCb
  case CAc
}
/**
 # Two angles and the side between (ASA)
 Known: two angles and the side between them
 The triangle's angles are computed using the spherical law of cosines, then a further check using AAA
 - Parameter vertex1: vertex angle 1
 - Parameter side3: side .  Angular unit if R=1, else length of side3
 - Parameter vertex2: vertex angle 2
 - Parameter ASA: enum stating which sides and angle are provided (AcB, BaC, CbA)
 - Parameter R: radius of sphere.  R=1 will use a unitary sphere
 */
public func sphericalTriangle_AAS(vertex1 v1: Double, vertex2 v2: Double, side side1: Double, R: Double, AAS: optionAAS) -> SphericalTriangle {
  let s1 = side1 / R
  
  let s2 = asin( sin(s1) * sin(v2) / sin(v1) )
  let side2 = s2 * R
  
  switch AAS {
  case .ABa:
    return sphericalTriangle_SSAA(side1: side1, side2: side2, vertex1: v1, vertex2: v2, R: R, SSAA: .abAB)
  case .BCb:
    return sphericalTriangle_SSAA(side1: side1, side2: side2, vertex1: v1, vertex2: v2, R: R, SSAA: .bcBC)
  case .CAc:
    return sphericalTriangle_SSAA(side1: side1, side2: side2, vertex1: v1, vertex2: v2, R: R, SSAA: .caCA)
  }
}

public enum optionSSAA {
  case abAB
  case bcBC
  case caCA
}
/**
 # Two angles and the two opposite sides (SSAA)
 Known: two angles and the two opposite sides
 The triangle's angles are computed using Napier Analogies
 - Parameter side1: side1.  Angular unit if R=1, else length of side1
 - Parameter side2: side2.  Angular unit if R=1, else length of side2
 - Parameter vertex1: vertex angle 1
 - Parameter vertex2: vertex angle 2
 - Parameter SSAA: enum stating which sides and angle are provided (abAB, bcBC, caCA)
 - Parameter R: radius of sphere.  R=1 will use a unitary sphere
 */
public func sphericalTriangle_SSAA(side1: Double, side2: Double, vertex1 v1: Double, vertex2 v2: Double, R: Double = 1.0, SSAA: optionSSAA) -> SphericalTriangle {
  let s1 = side1 / R
  let s2 = side2 / R
  
  var p1 = tan( (s1 + s2) / 2 )
  var p2 = cos( (v1 - v2) / 2 )
  var p3 = cos( (v1 + v2) / 2 )
//  let s3 = 2 * atan(p1 * p3 / p2)
  let s3 = 2 * atan2(p1 * p3, p2)

  p1 = tan( (v1 + v2) / 2 )
  p2 = cos( (s1 - s2) / 2 )
  p3 = cos( (s1 + s2) / 2 )
  let v3 = 2 * acot2( p1 * p3, p2 )
  
  switch SSAA {
  case .abAB:
    return SphericalTriangle(A: v1, B: v2, C: v3, a: s1, b: s2, c: s3, R: R)
  case .bcBC:
    return SphericalTriangle(A: v3, B: v1, C: v2, a: s3, b: s1, c: s2, R: R)
  case .caCA:
    return SphericalTriangle(A: v2, B: v3, C: v1, a: s2, b: s3, c: s1, R: R)
  }
}

private func cot(_ x: Double) -> Double {
  return cos(x)/sin(x)
}
private func acot(_ x: Double) -> Double {
  return atan(1/x)
}
private func acot2(_ x: Double, _ y: Double) -> Double {
  return atan2(y, x)
}
