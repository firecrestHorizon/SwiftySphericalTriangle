    import XCTest
    @testable import SwiftySphericalTriangle
    
    // Approx Earth radius in meters
    let Earth_R = 6400000.0
    
    // Length of sides for a triangle, in m
    let side_a = 10.0e+3                  // 10km
    let side_b = 15.0e+3                  // 15km
    let side_c = 13.0e+3                  // 13km
    let a = side_a / Earth_R
    let b = side_b / Earth_R
    let c = side_c / Earth_R
    
    // Angles for the same triangle, in radians
    let angle_A = 0.7169006006312598      // 41.075378747°
    let angle_B = 1.400747719572694       // 80.256932494°
    let angle_C = 1.0239458974317932      // 58.667778373°
    
    let reqAccuracyAngle        = 1e-7
    
    final class SwiftySphericalTriangleTests: XCTestCase {
      func checkTriangle(triangle st: SphericalTriangle) -> Bool {
        var check = true
        if abs(st.A.distance(to: angle_A)) > reqAccuracyAngle {  check = false }
        if abs(st.B.distance(to: angle_B)) > reqAccuracyAngle {  check = false }
        if abs(st.C.distance(to: angle_C)) > reqAccuracyAngle {  check = false }
        if abs(st.a.distance(to: side_a/Earth_R)) > reqAccuracyAngle {  check = false }
        if abs(st.b.distance(to: side_b/Earth_R)) > reqAccuracyAngle {  check = false }
        if abs(st.c.distance(to: side_c/Earth_R)) > reqAccuracyAngle {  check = false }
        
        if !check {
          let s = """
           Calculated Angle A: \(st.A)
                Check Angle A: \(angle_A)
           Calculated Angle B: \(st.B)
                Check Angle B: \(angle_B)
          Calculated Angle C: \(st.C)
                Check Angle C: \(angle_C)
          
            Calculated Side a: \(st.a)
                 Check Side a: \(a)
            Calculated Side b: \(st.b)
                 Check Side b: \(b)
            Calculated Side c: \(st.c)
                 Check Side c: \(c)
          """
          print(s)
        }
        
        return check
      }
      
      func testSSS() {
        let st = sphericalTriangle_SSS(side1: side_a, side2: side_b, side3: side_c, R: Earth_R)
        XCTAssertTrue(checkTriangle(triangle: st))
      }
      
      func testAAA() {
        let st = sphericalTriangle_AAA(vertex1: angle_A, vertex2: angle_B, vertex3: angle_C, R: Earth_R)
        XCTAssertTrue(checkTriangle(triangle: st))
      }
      
      func testSAS() {
        var st = sphericalTriangle_SAS(side2: side_a, vertex1: angle_C, side3: side_b, R: Earth_R, SAS: .aCb)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_SAS(side2: side_b, vertex1: angle_A, side3: side_c, R: Earth_R, SAS: .bAc)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_SAS(side2: side_c, vertex1: angle_B, side3: side_a, R: Earth_R, SAS: .cBa)
        XCTAssertTrue(checkTriangle(triangle: st))
      }
      
      func testSSA() {
        var st = sphericalTriangle_SSA(side1: side_a, side2: side_b, vertex1: angle_A, R: Earth_R, SSA: .abA)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_SSA(side1: side_b, side2: side_c, vertex1: angle_B, R: Earth_R, SSA: .bcB)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_SSA(side1: side_c, side2: side_a, vertex1: angle_C, R: Earth_R, SSA: .caC)
        XCTAssertTrue(checkTriangle(triangle: st))
      }
      
      func testASA() {
        var st = sphericalTriangle_ASA(vertex1: angle_A, side3: side_c, vertex2: angle_B, R: Earth_R, ASA: .AcB)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_ASA(vertex1: angle_B, side3: side_a, vertex2: angle_C, R: Earth_R, ASA: .BaC)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_ASA(vertex1: angle_C, side3: side_b, vertex2: angle_A, R: Earth_R, ASA: .CbA)
        XCTAssertTrue(checkTriangle(triangle: st))
      }
      
      func testAAS() {
        var st = sphericalTriangle_AAS(vertex1: angle_A, vertex2: angle_B, side: side_a, R: Earth_R, AAS: .ABa)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_AAS(vertex1: angle_B, vertex2: angle_C, side: side_b, R: Earth_R, AAS: .BCb)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_AAS(vertex1: angle_C, vertex2: angle_A, side: side_c, R: Earth_R, AAS: .CAc)
        XCTAssertTrue(checkTriangle(triangle: st))
      }
      
      func testSSAA() {
        var st = sphericalTriangle_SSAA(side1: side_a, side2: side_b, vertex1: angle_A, vertex2: angle_B, R: Earth_R, SSAA: .abAB)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_SSAA(side1: side_b, side2: side_c, vertex1: angle_B, vertex2: angle_C, R: Earth_R, SSAA: .bcBC)
        XCTAssertTrue(checkTriangle(triangle: st))
        st = sphericalTriangle_SSAA(side1: side_c, side2: side_a, vertex1: angle_C, vertex2: angle_A, R: Earth_R, SSAA: .caCA)
        XCTAssertTrue(checkTriangle(triangle: st))
      }
      
    }
