describe 'queryParams', ->
  beforeEach module 'common'

  queryParams = undefined
  $location = undefined

  beforeEach ->
    inject ($injector) ->
      queryParams = $injector.get('queryParams')
      $location = $injector.get('$location')

  it 'set to null', ->
    queryParams('obj', {a: 1, b: 2})
    queryParams(null)
    expect($location.url()).toEqual ''

  it 'set to {}', ->
    queryParams('obj', {a: 1, b: 2})
    queryParams({})
    expect($location.url()).toEqual ''

  it 'delete param that did not exist', ->
    queryParams('key', null)
    expect($location.url()).toEqual ''

  it 'delete param that exist', ->
    queryParams({a: 1, b: 2})
    queryParams('a', null)
    expect($location.url()).toEqual '?b=2'

  it 'delete nested param that exist', ->
    queryParams({a: {b: {c: {d: 1, e: 2}}}})
    queryParams('a.b.c.d', null)
    expect($location.url()).toEqual '?a.b.c.e=2'

  it 'delete branch in nested object', ->
    queryParams({a: {b: {c: {d: {e: 1}}}, f: 5}})
    queryParams('a.b', null)
    expect($location.url()).toEqual '?a.f=5'

  it 'delete element in array', ->
    queryParams({array: [1, 2, 3]})
    queryParams('array.1', null)
    expect($location.url()).toEqual '?array=1&array=3'

  it 'delete element in array nested in object', ->
    queryParams({obj: {array: [1, 2, 3]}})
    queryParams('obj.array.1', null)
    expect($location.url()).toEqual '?obj.array=1&obj.array=3'
