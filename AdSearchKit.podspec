Pod::Spec.new do |s|
  s.name = 'AdSearchKit'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.summary = 'AdSearchKit fetches Apple Search Ads attribution data via AdServices API.'
  s.homepage = 'https://github.com/dimayurkovski/AdSearchKit'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Dima Yurkovski' => 'dima.yurkovski@gmail.com' }
  s.source = { :git => 'https://github.com/dimayurkovski/AdSearchKit.git', :tag => s.version.to_s }
  s.source_files = 'Source/*.swift'
  s.frameworks = 'AdServices'
  s.platform = :ios, '12.0'
  s.swift_versions = ['5']
  s.resource_bundles = {'AdSearchKit' => ['Sources/PrivacyInfo.xcprivacy']}
end
