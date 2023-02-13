#
# Be sure to run `pod lib lint zy-lib-idemia-face-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a1 # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

    s.name         = "zy_fpay_validacionfacial_lib_ios"
    s.version      = "0.12.0"
    s.summary      = "A brief description of zy_fpay_validacionfacial_lib_ios project."
    s.description  = <<-DESC
    An extended description of zy_fpay_validacionfacial_lib_ios project.
    DESC
    s.homepage     = "http://www.zytrust.com"
    s.license          = { :type => 'MIT', :file => 'LICENSE' }

    s.author = { "$(git config user.name)" => "$(git config user.email)" }
    s.source = { :git => "https://github.com/ZYTRUST/zy_fpay_validacionfacial_lib_ios.git", :tag => s.version.to_s }
    s.public_header_files = "zy_fpay_validacionfacial_lib_ios.framework/Headers/*.h"
    s.source_files = "zy_fpay_validacionfacial_lib_ios.framework/Headers/*.h"
    s.vendored_frameworks = "zy_fpay_validacionfacial_lib_ios.framework"
    s.platform = :ios
    #s.swift_version = "4.2"
    s.ios.deployment_target  = '12.0'

    s.static_framework = true
    #s.resources = 'Assets/*.{lproj,storyboard,xcassets,png}'
    #s.resources = 'zy_fpay_validacionfacial_lib_ios/Assets/*.{lproj,storyboard,xcassets,png}'

    #s.source_files = 'zy_fpay_validacionfacial_lib_ios/Classes/**/*'

    s.dependency 'zy_lib_idemia_face_ios'
    s.dependency 'zy_lib_become_ocr_ios'
    
    s.dependency 'JWTDecode', '2.6'
    s.dependency 'CryptoSwift', '1.3.3'
    s.dependency 'lottie-ios', '3.3.0'
    s.dependency 'zy_lib_ui_ios', '0.2.5'
    s.dependency 'ZyUICargando', '0.1.3'


end