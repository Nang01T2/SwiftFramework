Pod::Spec.new do |s|
  s.name         = "{PROJECT}"
  s.version      = "0.1"
  s.summary      = "This is an example of a cross-platform Swift framework!"
  s.description  = <<-DESC
    Your description here.
  DESC
  s.source       = { :git => "{URL}.git", :tag => s.version }
  s.homepage     = "{URL}"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "{AUTHOR}" => "{EMAIL}" }
  s.social_media_url   = ""

  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "10.0"

  s.source_files  = "Sources/**/*"
  s.resource_bundles = {
    '{PROJECT}' => [
        'Sources/*.xcassets'
    ]
  }

  #s.dependency 'RxSwift'
end
