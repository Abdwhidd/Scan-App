//
//  TextRecognizer.swift
//  ScanOcrApp
//
//  Created by Wahid on 28/06/22.
//

import Foundation
import VisionKit
import Vision

final class TextRecognizer {
    let cameraScan: VNDocumentCameraScan
    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }
    private let queue = DispatchQueue(label: "scan-qode", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    
    func recognizeText(withCompletionHandler completionHandler: @escaping ([String]) -> Void) {
        queue.async {
            let images = (0..<self.cameraScan.pageCount).compactMap({
                self.cameraScan.imageOfPage(at: $0).cgImage
            })
            let imageAndRequests = images.map({(images: $0, request: VNRecognizeTextRequest())})
            let textPerPage = imageAndRequests.map{image, request->String in
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do {
                    try handler.perform([request])
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {return ""}
                    return observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "\n")
                }
                catch {
                    print(error)
                    return ""
                }
            }
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}
