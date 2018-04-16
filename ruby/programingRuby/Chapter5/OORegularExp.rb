# 面向对象的正则表达式
# Ruby有一个完全面向对象的正则表达式的处理系统
re = /cat/
puts re.class

# 可见正则表达式的实现类是Regexp
# Regexp#match方法对字符串匹配正则表达式。如果失败了返回nil，成功则返回MatchData类的一个实例。
# MatchData对象让你访问关于这次匹配的所有可用信息。
# 所有这些信息都是通过$变量得到的，它们绑定在一个小巧方便的对象里
# re = /(\d+):(\d+)/ # match a time hh:mm
re = /((\d+):(\d+)).*\s((\d+):(\d+))/ # match a time hh:mm
md = re.match("Time : 9:00am to 6:00pm ")
print "md 的实现类是 ", md.class, "\n"
puts md[0]
puts md[1]
puts md[2]
puts md[3]
puts md[4]
puts md[5]
puts md.pre_match
puts md.post_match

print "\n"*6
re = /(\d+):(\d+)/ # match a time hh:mm
md1 = re.match("Time: 12:34am")
md2 = re.match("Time: 10:30pm")
print md1[1, 2], "\n"
print md2[1, 2], "\n"

print "\n"*6
print [$1, $2], "\n"
$~ = md1 # Ruby把对结果的引用保存在线程局部变量中，可通过$~访问。
print [$1, $2], "\n"
