//
//  Job.swift
//  Klob
//
//  Created by Nathanael Abel on 09/12/24.
//

import Foundation

class Job: Codable, Identifiable {
    let jobVacancyCode, positionName, corporateID, corporateName: String
    let status: Status
    let descriptions: String
    let corporateLogo: String
    let applied: Bool?
    let salaryFrom, salaryTo: Int
    let postedDate: String?
    var isApplied: Bool = false

    enum CodingKeys: String, CodingKey {
        case jobVacancyCode, positionName
        case corporateID = "corporateId"
        case corporateName, status, descriptions, corporateLogo, applied, salaryFrom, salaryTo, postedDate
    }

    var id: String {
        jobVacancyCode
    }

    // MARK: - Utility Methods

    /// Formats a given amount into IDR currency format.
    func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "IDR "
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }

    /// Converts an HTML string into plain text.
    func cleanHTMLString() -> String {
        guard let data = descriptions.data(using: .utf8) else { return descriptions }
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) {
            return attributedString.string
        }
        return descriptions
    }

    /// Computes the salary range as a string.
    var salaryRange: String? {
        if salaryFrom > 0 && salaryTo > 0 {
            return "\(formatCurrency(salaryFrom)) - \(formatCurrency(salaryTo))"
        }
        return nil
    }

    /// Computes how long ago the job was posted.
    var postedDaysAgo: String {
        guard let postedDate = postedDate else {
            return "Unknown date"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = dateFormatter.date(from: postedDate) else {
            return "Unknown date"
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date, to: Date())

        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }

        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }

        if let days = components.day, days > 0 {
            if days == 1 {
                return "1 day ago"
            } else {
                return "\(days) days ago"
            }
        }

        return "Today"
    }
}

enum Status: String, Codable {
    case karyawanKontrak = "Karyawan Kontrak"
    case karyawanTetap = "Karyawan Tetap"
    case magang = "Magang"
}

typealias JobList = [Job]
