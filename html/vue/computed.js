var vm = new Vue({
  el: '#example',
  data: {
    message: 'Hello'
  },
  computed: {
    reversedMessage: function(){
      return this.message.split('').reverse().join('')
    }  },
  methods: {
    reversedMessage1: function(){
      return this.message.split('').reverse().join('')
    },
    now: function(){
      return Date.now()
    }
  }
})

var vm2 = new Vue({
  el: '#demo',
  data: {
    firstName: 'Foo',
    lastName: 'Bar',
    fullName: 'Foo Bar'
  },
  watch: {
    firstName: function(val){
      this.fullName = val + ' ' + this.lastName
    },
    lastName: function(val){
      this.fullName = this.firstName + ' ' + val
    }
  }
})

var vm3 = new Vue({
  el: '#demo2',
  data: {
    firstName: 'Foo',
    lastName: 'Bar',
  },
  computed: {
    fullName: {
      get: function(){
        return this.firstName + ' ' + this.lastName
      },
      set: function(newValue){
        var names = newValue.split(' ')
        this.firstName = names[0]
        this.lastName = names[names.length -1]
      }
    }
    /*
    fullName: function(){
      return this.firstName + ' ' + this.lastName
    }*/
  }
})

var watchExampleVM = new Vue({
  el: '#watch-example',
  data: {
    question: '',
    answer: 'I cannot give you an answer until you ask a question!'
  },
  watch: {
    // 如果 `question` 发生改变，这个函数就会运行
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.debouncedGetAnswer()
    }
  },
  created: function () {
    // `_.debounce` 是一个通过 Lodash 限制操作频率的函数。
    // 在这个例子中，我们希望限制访问 yesno.wtf/api 的频率
    // AJAX 请求直到用户输入完毕才会发出。想要了解更多关于
    // `_.debounce` 函数 (及其近亲 `_.throttle`) 的知识，
    // 请参考：https://lodash.com/docs#debounce
    this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
  },
  methods: {
    getAnswer: function () {
      if (this.question.indexOf('?') === -1) {
        this.answer = 'Questions usually contain a question mark. :-)'
        return
      }
      this.answer = 'Thinking...'
      var vm4 = this
      axios.get('https://yesno.wtf/api')
      .then(function (response) {
        vm4.answer = _.capitalize(response.data.answer)
      })
      .catch(function (error) {
        vm4.answer = 'Error! Could not reach the API. ' + error
      })
    }
  }
})

var vm5 = new Vue({
  el: '#demo3',
  data: {
    isActive: true,
    hasError: false
  }
})

var vm6 = new Vue({
  el: '#demo4',
  data: {
    activeColor: 'red',
    fontSize: 30,
    styleObject: {
      color: 'orange',
      fontSize: '13px'
    },
    overridingStyles: {
      color: 'blue',
      fontSize: '20px'
    }
  }
})

