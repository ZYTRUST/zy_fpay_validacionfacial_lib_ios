#
# Be sure to run `pod lib lint zy-lib-idemia-face-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a1 # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

    s.name         = "zy_fpay_validacionfacial_lib_ios"
    s.version      = "0.8.3"
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

    s.dependency 'zy_lib_idemia_face_ios', '~> 6.0.2'
    s.dependency 'zy_lib_become_ocr_ios', '~> 7.0.7'
    
    s.dependency 'JWTDecode', '2.6'
    s.dependency 'CryptoSwift', '1.3.3'
    s.dependency 'lottie-ios', '3.3.0'
    s.dependency 'zy_lib_ui_ios', '~>  0.2.3'
    s.dependency 'zy_encrypt_util', '~> 0.1.1'




end

