Pod::Spec.new do |s|

s.name              = 'AKImageViewer'
s.version           = '1.0.12'
s.summary           = 'A clean iOS add-on to view images full-sized with a smooth interface and feel.'
s.homepage          = 'https://github.com/aleckretch/AKImageViewer'
s.license           = { :type => 'MIT', :file => 'LICENSE' }
s.author            = { 'Alec Kretch' => 'aleckretch@gmail.com' }
s.source            = { :git => 'https://github.com/aleckretch/AKImageViewer.git', :tag => s.version.to_s }
s.platform          = :ios
s.source_files      = 'AKImageViewer/*'
s.requires_arc      = true

end