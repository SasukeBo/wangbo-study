var vm1 = new Vue({
  el: '#demo1',
  data: {
    condition: "false"
  }
})

var vm2 = new Vue({
  el: '#demo2',
  data: {
    math: Math.random()
  }
})

var vm3 = new Vue({
  el: '#demo3',
  data: {
    loginType: "username"
  },
  methods: {
    changeLoginType: function(){
      this.loginType = "email";
    }
  }
})
