
Pod::Spec.new do |s|
  s.name         = "MailboxActionSheet"
  s.version      = "0.0.1"
  s.summary      = "Mailbox style action sheet"
  s.homepage     = "https://github.com/amleszk/MailboxActionSheet"
  s.platform     = :ios, '3.0'
  s.author       = { "A M Leszkiewicz" => "amleszk@gmail.com" }
  s.source       = { :git => "https://github.com/amleszk/MailboxActionSheet.git", :commit => "61dc91a762a113320dd982c14a297abf27fdc5b5" }
  s.source_files = 'MailboxActionSheet'
  s.frameworks = 'QuartzCore', 'UIKit' , 'Foundation' , 'CoreGraphics'
  s.requires_arc = true
end
