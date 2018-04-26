class ApplicationMailer < ActionMailer::Base
  # 默认的发件人地址，整个应用中的全部邮件程序都会使用这个地址
  default from: "wangbo@giabbs.com"
  layout 'mailer'
end
