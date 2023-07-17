Pod::Spec.new do |spec|
  spec.name           = 'LineTextField'
  spec.version        = '1.1.1'
  spec.summary        = 'Custom UITextField with floated placeholder and an underline.'
  spec.homepage       = "https://github.com/NovichenkoAnton/LineTextField"

  spec.license        = { :type => 'MIT', :file => 'LICENSE' }
  spec.author         = { "Anton Novichenko" => "novichenko.anton@gmail.com" }

  spec.platform       = :ios
  spec.ios.deployment_target = '13.0'

  spec.swift_version  = ['5.4']
  spec.source         = { :git => 'https://github.com/NovichenkoAnton/LineTextField.git', :tag => "#{spec.version}" }
  spec.source_files   = 'Sources/*.swift'
  spec.requires_arc  = true
end
