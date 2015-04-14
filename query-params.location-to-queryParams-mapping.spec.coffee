describe 'queryParams: location mapping', ->
  beforeEach module 'common'

  queryParams = undefined
  $location = undefined
  $rootScope = undefined

  beforeEach ->
    inject ($injector) ->
      queryParams = $injector.get('queryParams')
      $location = $injector.get('$location')
      $rootScope = $injector.get('$rootScope')

  it 'empty', ->
    expect(queryParams()).toEqual {}

  it 'set camelCasedKey', ->
    $location.url('?camelCasedKey=someValue')
    $rootScope.$apply()
    expect(queryParams()).toEqual {camelCasedKey: 'someValue'}

  it 'set dashed-key', ->
    $location.url('?dashed-key=someValue')
    $rootScope.$apply()
    expect(queryParams()).toEqual {dashedKey: 'someValue'}

  it 'set nested key', ->
    $location.url('?my.nested.key=someValue')
    $rootScope.$apply()
    expect(queryParams()).toEqual {my: {nested: {key: 'someValue'}}}

  it 'set empty value', ->
    $location.url('?empty-value=')
    $rootScope.$apply()
    expect(queryParams()).toEqual {emptyValue: ''}

  it 'set no value', ->
    $location.url('?no-value')
    $rootScope.$apply()
    expect(queryParams()).toEqual {noValue: true}

  it 'set string', ->
    $location.url('?string=str')
    $rootScope.$apply()
    expect(queryParams()).toEqual {string: 'str'}

  it 'set number', ->
    $location.url('?number=1')
    $rootScope.$apply()
    expect(queryParams()).toEqual {number: 1}

  it 'set number 0', ->
    $location.url('?number=0')
    $rootScope.$apply()
    expect(queryParams()).toEqual {number: 0}

  it 'set false', ->
    $location.url('?false-key=false')
    $rootScope.$apply()
    expect(queryParams()).toEqual {falseKey: 'false'}

  it 'set true', ->
    $location.url('?true-key=true')
    $rootScope.$apply()
    expect(queryParams()).toEqual {trueKey: 'true'}

  it 'set date', ->
    $location.url('?date=2013-12-05')
    $rootScope.$apply()
    expect(_.size(queryParams())).toEqual 1
    expect(moment.isMoment(queryParams().date)).toEqual true
    expect(queryParams().date.isSame(moment('2013-12-05'))).toEqual true

  it 'set array with empty values', ->
    $location.url('?array=&array=')
    $rootScope.$apply()
    expect(queryParams()).toEqual {array: ['', '']}

  it 'set array with no values', ->
    $location.url('?array&array')
    $rootScope.$apply()
    expect(queryParams()).toEqual {array: [true, true]}

  it 'set array', ->
    $location.url('?array=1&array=2')
    $rootScope.$apply()
    expect(queryParams()).toEqual {array: [1, 2]}

  it 'set object with empty values', ->
    $location.url('?obj.a=&obj.b=')
    $rootScope.$apply()
    expect(queryParams()).toEqual {obj: {a: '', b: ''}}

  it 'set object with no values', ->
    $location.url('?obj.a&obj.b')
    $rootScope.$apply()
    expect(queryParams()).toEqual {obj: {a: true, b: true}}

  it 'set object', ->
    $location.url('?obj.a=1&obj.b=2')
    $rootScope.$apply()
    expect(queryParams()).toEqual {obj: {a: 1, b: 2}}

  it 'set nested object', ->
    $location.url('?nested-object.a.b.c.d=1')
    $rootScope.$apply()
    expect(queryParams()).toEqual {'nestedObject': {a: {b:
      c: {d: 1}}}}

  it 'set complex object', ->
    $location.url('?a=&b&c=string&d=1&e=0&f=false&g=true&i=1&i=2&j.a=1&j.b=2')
    $rootScope.$apply()
    expect(queryParams()).toEqual {a: '', b: true, c: "string", d: 1, e: 0, f: 'false', g: 'true', i: [1,
                                                                                                       2], j: {a: 1, b: 2}}
