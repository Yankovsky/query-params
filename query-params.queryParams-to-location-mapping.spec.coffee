describe 'queryParams: queryParams to location mapping', ->
  beforeEach module 'common'

  queryParams = undefined
  $location = undefined

  beforeEach ->
    inject ($injector) ->
      queryParams = $injector.get('queryParams')
      $location = $injector.get('$location')

  it 'empty', ->
    expect($location.url()).toEqual ''

  it 'set camelCasedKey', ->
    queryParams('camelCasedKey', 'someValue')
    expect($location.url()).toEqual '?camel-cased-key=someValue'

  it 'set dashed-key', ->
    queryParams('dashed-key', 'someValue')
    expect($location.url()).toEqual '?dashed-key=someValue'

  it 'set nested key', ->
    queryParams('my.nested.key', 'someValue')
    expect($location.url()).toEqual '?my.nested.key=someValue'

  it 'set undefined', ->
    queryParams('undefined', undefined)
    expect($location.url()).toEqual ''

  it 'set null', ->
    queryParams('null', null)
    expect($location.url()).toEqual ''

  it 'set ""', ->
    queryParams('emptyString', '')
    expect($location.url()).toEqual '?empty-string='

  it 'set string', ->
    queryParams('string', 'str')
    expect($location.url()).toEqual '?string=str'

  it 'set string 0', ->
    queryParams('zero', '0')
    expect($location.url()).toEqual '?zero=0'

  it 'set number', ->
    queryParams('number', 1)
    expect($location.url()).toEqual '?number=1'

  it 'set number 0', ->
    queryParams('zero', 0)
    expect($location.url()).toEqual '?zero=0'

  it 'set false', ->
    queryParams('falseKey', false)
    expect($location.url()).toEqual '?false-key=false'

  it 'set true', ->
    queryParams('trueKey', true)
    expect($location.url()).toEqual '?true-key'

  it 'set date', ->
    queryParams('date', new Date(2013, 11, 5))
    expect($location.url()).toEqual '?date=2013-12-05'

  it 'set moment', ->
    queryParams('momentDate', moment(new Date(2013, 11, 5)))
    expect($location.url()).toEqual '?moment-date=2013-12-05'

  it 'set []', ->
    queryParams('emptyArray', {})
    expect($location.url()).toEqual ''

  it 'set [1, 2]', ->
    queryParams('nonEmptyArray', [1, 2])
    expect($location.url()).toEqual '?non-empty-array=1&non-empty-array=2'

  it 'set nested array', ->
    queryParams('nestedArray', [
      [1, 2],
      [3, 4],
      [
        [5, 6],
        []
      ],
      []
    ])
    expect($location.url()).toEqual '?nested-array=1,2&nested-array=3,4&nested-array=5,6,&nested-array='

  it 'set complex array', ->
    queryParams('arr',
      [undefined, null, '', 'string', '0', 1, 0, false, true, new Date(2013, 11, 5), moment(new Date(2013, 11, 5)), [],
       [1, 2]])
    expect($location.url()).toEqual '?arr=undefined&arr=null&arr=&arr=string&arr=0&arr=1&arr=0&arr=false&arr&arr=2013-12-05&arr=2013-12-05&arr=&arr=1,2'

  it 'set {}', ->
    queryParams('emptyObject', {})
    expect($location.url()).toEqual ''

  it 'set {a: 1, b: 2}', ->
    queryParams('nonEmptyObject', {a: 1, b: 2})
    expect($location.url()).toEqual '?non-empty-object.a=1&non-empty-object.b=2'

  it 'set nested object', ->
    queryParams('nestedObject', {a: {b:
      c: {d: 1}}, e: {}})
    expect($location.url()).toEqual '?nested-object.a.b.c.d=1'

  it 'set complex object using two args', ->
    queryParams('obj',
      {a: undefined, b: null, c: '', d: 'string', e: '0', f: 1, g: 0, h: false, i: true, j: new Date(2013, 11,
        5), k: moment(new Date(2013, 11, 5)), l: [], m: [1, 2], n: {}, o: {a: 1, b: 2}})
    expect($location.url()).toEqual '?obj.c=&obj.d=string&obj.e=0&obj.f=1&obj.g=0&obj.h=false&obj.i&obj.j=2013-12-05&obj.k=2013-12-05&obj.m=1&obj.m=2&obj.o.a=1&obj.o.b=2'

  it 'set complex object using one arg', ->
    queryParams({obj: {a: undefined, b: null, c: '', d: 'string', e: '0', f: 1, g: 0, h: false, i: true, j: new Date(2013,
      11, 5), k: moment(new Date(2013, 11, 5)), l: [], m: [1, 2], n: {}, o: {a: 1, b: 2}}})
    expect($location.url()).toEqual '?obj.c=&obj.d=string&obj.e=0&obj.f=1&obj.g=0&obj.h=false&obj.i&obj.j=2013-12-05&obj.k=2013-12-05&obj.m=1&obj.m=2&obj.o.a=1&obj.o.b=2'
