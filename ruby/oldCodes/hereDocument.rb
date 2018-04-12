#!/usr/bin/ruby -w
# -*- coding : utf-8 -*-
print <<EOF #EOF和<<之间不能有空格
    这是第一种方式创建here document 。
    多行文字。
EOF

print <<"EOF";#与上面相同
    这是第二种方式创建here document。
    多行文字
EOF
print <<'EOC'
    echo hi there
    echo lo there
EOC
print <<"foo",<<"bar"
    I said foo.
foo
    I said bar.
bar
