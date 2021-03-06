Pod::Spec.new do |s|
  s.name         = "August"
  s.version      = "5.0.1"
  s.summary      = "The Swift Client You Deserve"
  s.description  = <<-DESC
                    A simple Swift HTTP client that casts responses to your domain models.
                   DESC
  s.homepage     = "https://github.com/bradhilton/August"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Brad Hilton" => "brad@skyvive.com" }
  s.source       = { :git => "https://github.com/bradhilton/August.git", :tag => s.version }
  s.swift_version = '5.0'

  s.ios.deployment_target = "8.0"
#  s.osx.deployment_target = "10.10"

  s.source_files  = "Sources", "Sources/**/*.{swift,h,m}"
  s.requires_arc = true

  s.dependency 'Convertible', '5.0.2'
  s.dependency 'AssociatedValues', '5.0.0'

end
