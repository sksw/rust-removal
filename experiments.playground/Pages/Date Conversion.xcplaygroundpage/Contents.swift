import Foundation

let utc9amOnly = "13:00:00.000Z"
let utc9amJan = "2020-01-01T13:00:00.000Z"
let utc9amAug = "2020-08-01T13:00:00.000Z"

let formatter = DateFormatter()
formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
let local9amJan = formatter.date(from: utc9amJan)!
let local9amAug = formatter.date(from: utc9amAug)!

formatter.dateFormat = "HH:mm:ss.SSSZ"
let local9amOnly = formatter.date(from: utc9amOnly)!

print("----- parsed dates")
print(local9amJan)
print(local9amAug)
print(local9amOnly)
// 2020-01-01 13:00:00 +0000
// 2020-08-01 13:00:00 +0000
// 2000-01-01 13:00:00 +0000 <-- assumes 2000-01-01
// ^ looks like all the same time

formatter.dateFormat = "HH:mm"

print("----- print time only")
print(formatter.string(from: local9amJan))
print(formatter.string(from: local9amAug))
print(formatter.string(from: local9amOnly))
// 08:00
// 09:00 <-- though time shown the same in debug, when formatted, accounts for daylight savings
// 08:00
// ^ 1 hour off!

extension Date {
    var isLocalDaylightSavingsTime: Bool {
        return TimeZone.current.isDaylightSavingTime(for: self)
    }
}

print("----- daylight savings")
print(local9amJan.isLocalDaylightSavingsTime)
print(local9amAug.isLocalDaylightSavingsTime)
print(local9amOnly.isLocalDaylightSavingsTime)
// false
// true
// false
// ^ this is the difference

extension Date {
    func isSameHourAndMinute(as other: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents(
            [.hour, .minute],
            from: self
        )
        let components2 = calendar.dateComponents(
            [.hour, .minute],
            from: other
        )
        return components1.hour == components2.hour
            && components1.minute == components2.minute
    }
}

print("----- hour + minute date component comparison")
print(local9amJan.isSameHourAndMinute(as: local9amAug))
print(local9amJan.isSameHourAndMinute(as: local9amOnly))
print(local9amAug.isSameHourAndMinute(as: local9amOnly))
// false
// true <-- the 2 non-daylight-savings dates are equal
// false
// ^ not the same

// +--------------------------+
// | Stiching things together |
// +--------------------------+
// because a UTC-time-only string defaults to 2000-01-01, we need to do time correction

extension Date {
    var localDaylightSavingsTimeOffset: TimeInterval {
        return TimeZone.current.daylightSavingTimeOffset(for: self)
    }

    static func on(year: Int, month: Int, day: Int) -> Date {
        let calendar = Calendar.current
        let components = DateComponents(
            calendar: calendar,
            year: year,
            month: month,
            day: day
        )
        return calendar.date(from: components)!
    }
    
    static func adjust(timeOnly: Date, basedOn reference: Date) -> Date {
        var offset: TimeInterval
        switch (timeOnly.isLocalDaylightSavingsTime, reference.isLocalDaylightSavingsTime) {
        case (true, false): offset = -timeOnly.localDaylightSavingsTimeOffset
        case (false, true): offset = reference.localDaylightSavingsTimeOffset
        default: offset = 0
        }

        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents(
            [.hour, .minute],
            from: timeOnly
        )
        var todayComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: reference
        )

        todayComponents.hour = timeComponents.hour!
        todayComponents.minute = timeComponents.minute!
        return calendar
            .date(from: todayComponents)!
            .addingTimeInterval(offset)
    }
}

print("----- pre-stich & post-stitch")
print(formatter.string(from: local9amOnly))
var stitched = Date.adjust(
    timeOnly: local9amOnly,
    basedOn: Date()
)
print(formatter.string(from: stitched))
stitched = Date.adjust(
    timeOnly: local9amOnly,
    basedOn: Date.on(year: 2020, month: 8, day: 1)
)
print(formatter.string(from: stitched))
stitched = Date.adjust(
    timeOnly: local9amOnly,
    basedOn: Date.on(year: 2020, month: 1, day: 1)
)
print(formatter.string(from: stitched))
// 08:00
// 09:00
// 09:00
// 08:00

print("----- reverse (for a daylight savings date with a non-daylight saving reference)")
stitched = Date.adjust(
    timeOnly: local9amAug,
    basedOn: local9amOnly
)
print(formatter.string(from: local9amAug))
print(formatter.string(from: local9amOnly))
print(formatter.string(from: stitched))
// 09:00
// 08:00
// 08:00
