//
//  CSVReaderTests.swift
//  CSV
//
//  Created by Yasuhiro Hatta on 2016/06/11.
//
//

import XCTest
@testable import CSV

class CSVReaderTests: XCTestCase {

    func testExample1() {
        let csv = "abab,cdcd,efef"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "cdcd", "efef"])
    }

    func testExample2() {
        let csv = "abab,\"cdcd\",efef"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "cdcd", "efef"])
    }

    func testExample3() {
        let csv = "abab,cdcd,efef\nzxcv,asdf,qwer"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qwer"])
    }

    func testExample4() {
        let csv = "abab,\"cd,cd\",efef"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "cd,cd", "efef"])
    }

    func testExample5() {
        let csv = "abab,cdcd,efef\r\nzxcv,asdf,qwer"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qwer"])
    }

    func testExample6() {
        let csv = "abab,\"\"\"cdcd\",efef\r\nzxcv,asdf,qwer"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "\"cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qwer"])
    }

    func testExample7() {
        let csv = "abab,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\""
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er"])
    }

    func testExample8() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\","
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testExample9() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\",\r"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records.count, 2)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testExample10() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\",\r\n"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records.count, 2)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testExample11() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\",\n"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records.count, 2)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testExample12() {
        let csv = "abab,,\"\rcdcd\n\",efef\r\nzxcv,asdf,\"qw\"\"er\",\n"
        let encoding = NSUTF8StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records.count, 2)
        XCTAssertEqual(records[0], ["abab", "", "\rcdcd\n", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testEncodingWithoutBOM() {
        var index = 0
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\","
        for encoding in allEncodings() {
            print("index: \(index)")
            let records = parse(csv: csv, encoding: encoding)
            XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
            XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
            index += 1
        }
    }

    func testUTF8WithBOM() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\","
        let encoding = NSUTF8StringEncoding
        let mutableData = NSMutableData()
        mutableData.append(utf8BOM, length: utf8BOM.count)
        mutableData.append(csv.data(using: encoding)!)
        let records = parse(data: mutableData, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testUTF16WithNativeEndianBOM() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\","
        let encoding = NSUTF16StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testUTF16WithBigEndianBOM() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\","
        let encoding = NSUTF16StringEncoding
        let mutableData = NSMutableData()
        mutableData.append(utf16BigEndianBOM, length: utf16BigEndianBOM.count)
        mutableData.append(csv.data(using: NSUTF16BigEndianStringEncoding)!)
        let records = parse(data: mutableData, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testUTF16WithLittleEndianBOM() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\","
        let encoding = NSUTF16StringEncoding
        let mutableData = NSMutableData()
        mutableData.append(utf16LittleEndianBOM, length: utf16LittleEndianBOM.count)
        mutableData.append(csv.data(using: NSUTF16LittleEndianStringEncoding)!)
        let records = parse(data: mutableData, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testUTF32WithNativeEndianBOM() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\","
        let encoding = NSUTF32StringEncoding
        let records = parse(csv: csv, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testUTF32WithBigEndianBOM() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\","
        let encoding = NSUTF32StringEncoding
        let mutableData = NSMutableData()
        mutableData.append(utf32BigEndianBOM, length: utf32BigEndianBOM.count)
        mutableData.append(csv.data(using: NSUTF32BigEndianStringEncoding)!)
        let records = parse(data: mutableData, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func testUTF32WithLittleEndianBOM() {
        let csv = "abab,,cdcd,efef\r\nzxcv,asdf,\"qw\"\"er\","
        let encoding = NSUTF32StringEncoding
        let mutableData = NSMutableData()
        mutableData.append(utf32LittleEndianBOM, length: utf32LittleEndianBOM.count)
        mutableData.append(csv.data(using: NSUTF32LittleEndianStringEncoding)!)
        let records = parse(data: mutableData, encoding: encoding)
        XCTAssertEqual(records[0], ["abab", "", "cdcd", "efef"])
        XCTAssertEqual(records[1], ["zxcv", "asdf", "qw\"er", ""])
    }

    func allEncodings() -> [NSStringEncoding] {
        return [
            // multi-byte character encodings
            NSShiftJISStringEncoding,
            NSJapaneseEUCStringEncoding,
            NSUTF8StringEncoding,
            // wide character encodings
            NSUTF16BigEndianStringEncoding,
            NSUTF16LittleEndianStringEncoding,
            NSUTF32BigEndianStringEncoding,
            NSUTF32LittleEndianStringEncoding,
        ]
    }

    func parse(csv: String, encoding: NSStringEncoding) -> [[String]] {
        let data = csv.data(using: encoding)!
        return parse(data: data, encoding: encoding)
    }

    func parse(data: NSData, encoding: NSStringEncoding) -> [[String]] {
        let stream = NSInputStream(data: data)
        let reader = try! CSVReader(stream: stream, encoding: encoding)
        var records = [[String]]()
        while try! reader.moveNext() {
            records.append(reader.current!)
        }
        return records
    }

    static var allTests : [(String, (CSVReaderTests) -> () throws -> Void)] {
        return [
            ("testExample1", testExample1),
        ]
    }

}
