let Resume =
      https://raw.githubusercontent.com/gaelreyrol/dhall-resume/3de451af096eb2c1df20f7c88f2dd6d05a72187e/package.dhall

let schema =
      "https://raw.githubusercontent.com/jsonresume/resume-schema/v1.0.0/schema.json"

in  Resume.Basic::{
    , `$schema` = Some schema
    , basics = Some Resume.Basics::{
      , email = Some "richard.hendriks@example.com"
      , label = Some "Programmer"
      , location = Some Resume.Location::{
        , address = Some "2712 Broadway St"
        , city = Some "San Francisco"
        , countryCode = Some "US"
        , postalCode = Some "CA 94115"
        , region = Some "California"
        }
      , name = Some "Richard Hendriks"
      , phone = Some "(912) 555-4321"
      , profiles = Some
        [ Resume.Profile::{
          , network = Some "Twitter"
          , username = Some "neutralthoughts"
          }
        , Resume.Profile::{
          , network = Some "SoundCloud"
          , url = Some "https://soundcloud.example.com/dandymusicnl"
          , username = Some "dandymusicnl"
          }
        ]
      , summary = Some
          "Richard hails from Tulsa. He has earned degrees from the University of Oklahoma and Stanford. (Go Sooners and Cardinal!) Before starting Pied Piper, he worked for Hooli as a part time software developer. While his work focuses on applied information theory, mostly optimizing lossless compression schema of both the length-limited and adaptive variants, his non-work interests range widely, everything from quantum computing to chaos theory. He could tell you about it, but THAT would NOT be a “length-limited” conversation!"
      , url = Some "http://richardhendricks.example.com"
      }
    , work = Some
      [ Resume.Work::{
        , name = Some "Pied Piper"
        , position = Some "CEO/President"
        , description = Some "Awesome compression company"
        , startDate = Some 2013-12-01
        , endDate = Some 2014-12-01
        , highlights = Some
          [ "Build an algorithm for artist to detect if their music was violating copy right infringement laws"
          , "Successfully won Techcrunch Disrupt"
          , "Optimized an algorithm that holds the current world record for Weisman Scores"
          ]
        , location = Some "Palo Alto, CA"
        , summary = Some
            "Pied Piper is a multi-platform technology based on a proprietary universal compression algorithm that has consistently fielded high Weisman Scores™ that are not merely competitive, but approach the theoretical limit of lossless compression."
        , url = Some "http://piedpiper.example.com"
        }
      ]
    , volunteer = Some
      [ Resume.Volunteer::{
        , organization = Some "CoderDojo"
        , position = Some "Teacher"
        , summary = Some
            "Global movement of free coding clubs for young people."
        , startDate = Some 2012-01-01
        , endDate = Some 2013-01-01
        , url = Some "http://coderdojo.example.com/"
        , highlights = Some [ "Awarded 'Teacher of the Month'" ]
        }
      ]
    , education = Some
      [ Resume.Education::{
        , area = Some "Information Technology"
        , courses = Some [ "DB1101 - Basic SQL", "CS2011 - Java Introduction" ]
        , institution = Some "University of Oklahoma"
        , score = Some "4.0"
        , startDate = Some 2011-06-01
        , endDate = Some 2014-01-01
        , studyType = Some "Bachelor"
        , url = Some "https://example.com/"
        }
      ]
    , awards = Some
      [ Resume.Award::{
        , awarder = Some "Techcrunch"
        , date = Some 2014-11-01
        , summary = Some "There is no spoon."
        , title = Some "Digital Compression Pioneer Award"
        }
      ]
    , publications = Some
      [ Resume.Publication::{
        , name = Some "Video compression for 3d media"
        , publisher = Some "Hooli"
        , releaseDate = Some 2014-10-01
        , summary = Some
            "Innovative middle-out compression algorithm that changes the way we store data."
        , url = Some "http://en.wikipedia.org/wiki/Silicon_Valley_(TV_series)"
        }
      ]
    , skills = Some
      [ Resume.Skill::{
        , level = Some "Master"
        , name = Some "Web Development"
        , keywords = Some [ "HTML", "CSS", "Javascript" ]
        }
      , Resume.Skill::{
        , level = Some "Master"
        , name = Some "Compression"
        , keywords = Some [ "Mpeg", "MP4", "GIF" ]
        }
      ]
    , languages = Some
      [ Resume.Language::{
        , fluency = Some "Native speaker"
        , language = Some "English"
        }
      ]
    , interests = Some
      [ Resume.Interest::{
        , name = Some "Wildlife"
        , keywords = Some [ "Ferrets", "Unicorns" ]
        }
      ]
    , references = Some
      [ Resume.Reference::{
        , name = Some "Erlich Bachman"
        , reference = Some
            "It is my pleasure to recommend Richard, his performance working as a consultant for Main St. Company proved that he will be a valuable addition to any company."
        }
      ]
    , projects = Some
      [ Resume.Project::{
        , name = Some "Miss Direction"
        , description = Some "A mapping engine that misguides you"
        , entity = Some "Smoogle"
        , startDate = Some 2016-08-24
        , endDate = Some 2016-08-24
        , highlights = Some
          [ "Won award at AIHacks 2016"
          , "Built by all women team of newbie programmers"
          , "Using modern technologies such as GoogleMaps, Chrome Extension and Javascript"
          ]
        , keywords = Some [ "GoogleMaps", "Chrome Extension", "Javascript" ]
        , roles = Some [ "Team lead", "Designer" ]
        , type = Some "application"
        , url = Some "missdirection.example.com"
        }
      ]
    , meta = Some Resume.Meta::{
      , canonical = Some
          "https://raw.githubusercontent.com/jsonresume/resume-schema/master/schema.json"
      , lastModified = Some "2017-12-24T15:53:00"
      , version = Some "v1.0.0"
      }
    }
