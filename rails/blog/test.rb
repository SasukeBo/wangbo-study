#!/usr/bin/env ruby
  require 'rubygems'
  require 'rest_client'

  def send_mail
    response = RestClient.post "http://api.sendcloud.net/apiv2/mail/send",
    :apiUser => "您自己设置的API_KEY",
    :apiKey => "API_KEY已发送到您的注册邮箱",
    :from => "service@sendcloud.im",
    :fromName => "SendCloud测试邮件",
    :to => "收件人地址",
    :subject => "来自SendCloud的第一封邮件！",
    :html => "你太棒了！你已成功的从SendCloud发送了一封测试邮件，接下来快登录前台去完善账户信息吧！",
    :respEmailId => "true"
    return response
  end

  response = send_mail
  puts response.code
  puts response.to_str
