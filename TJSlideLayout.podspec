Pod::Spec.new do |s|
    s.name         = 'TJSlideLayout'
    s.version      = '0.01'
    s.summary      = 'TJSlideLayout is subclass of UICollectionViewLayout.'
    s.homepage     = 'https://github.com/sunfengqian/TJSlideLayout'
    s.license      = 'MIT'
    s.authors      = {'sunfengqian' => 'sunfengqian163@163.com'}
    s.platform     = :ios, '7.0'
    s.source       = {:git => 'https://github.com/sunfengqian/TJSlideLayout.git', :tag => s.version}
    s.source_files = 'TJSlideLayout/**/*.{h,m}'
    s.requires_arc = true
end