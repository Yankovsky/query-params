describe 'queryParams', ->
  beforeEach module 'common'

  queryParams = undefined
  $location = undefined

  beforeEach ->
    inject ($injector) ->
      queryParams = $injector.get('queryParams')
      $location = $injector.get('$location')

  it 'substitute whole params using one arg', ->
    queryParams({a: {b: 1, c: 2}, d: 3})
    queryParams({a: 1, y: 2})
    expect($location.url()).toEqual '?a=1&y=2'

  it 'substitute branch in nested object', ->
    queryParams({a: {b: 1, c: 2}, d: 3})
    queryParams('a', 1)
    expect($location.url()).toEqual '?a=1&d=3'

  it 'add new key', ->
    queryParams({a: 1, b: 2})
    queryParams('c', 3)
    expect($location.url()).toEqual '?a=1&b=2&c=3'

  it 'update existing key', ->
    queryParams({a: 1, b: 2})
    queryParams('b', 3)
    expect($location.url()).toEqual '?a=1&b=3'

  it 'update existing object', ->
    queryParams({a: {a: 1, b: 2}})
    queryParams('a', {c: 3})
    expect($location.url()).toEqual '?a.c=3'

  it 'add new nested key', ->
    queryParams({obj: {a: 1, b: 2}})
    queryParams('obj.c', 3)
    expect($location.url()).toEqual '?obj.a=1&obj.b=2&obj.c=3'

  it 'update existing nested key', ->
    queryParams({obj: {a: 1, b: 2}})
    queryParams('obj.b', 3)
    expect($location.url()).toEqual '?obj.a=1&obj.b=3'

  it 'add new array item', ->
    queryParams({array: [1, 2]})
    queryParams('array.2', 3)
    expect($location.url()).toEqual '?array=1&array=2&array=3'

  it 'update existing array', ->
    queryParams({array: [1, 2]})
    queryParams('array.1', 3)
    expect($location.url()).toEqual '?array=1&array=3'
