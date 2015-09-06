Pod::Spec.new do |s|

s.name              = 'AKImageViewer'
s.version           = '0.0.1'
s.summary           = 'A clean iOS add-on to view images full-sized with a smooth interface and feel.'
s.homepage          = 'https://github.com/aleckretch/AKImageViewer'
s.license           = { :type => 'MIT', :file => 'LICENSE' }
s.author            = { 'Alec Kretch' => 'aleckretch@gmail.com' }
s.source            = { :git => 'https://github.com/aleckretch/AKImageViewer.git', :tag => s.version.to_s }
s.platform          = :ios
s.source_files      = '*.{m,h}'
s.requires_arc      = true

end