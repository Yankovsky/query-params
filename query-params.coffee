angular.module('common').factory 'queryParams', (dateFormats, $location, $rootScope, utils) ->
  dashToCamel = (str) ->
    str.replace /-([a-z])/g, (g) ->
      g[1].toUpperCase()

  camelToDash = (str) ->
    str.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase()

  queryParamToValue = (v) ->
    if _.isArray v
      _.map v, queryParamToValue
    else
      valueAsMoment = moment(v, dateFormats.serverDate, true)
      valueAsNumber = utils.asNumber v
      if valueAsMoment.isValid()
        valueAsMoment
      else if _.isNumber(valueAsNumber) && !_.isNaN(valueAsNumber)
        valueAsNumber
      else v

  valueToQueryParam = (v) ->
    if _.isDate v
      v = moment v
    if moment.isMoment v
      v.format(dateFormats.serverDate)
    else if _.isArray(v) && v.length
      _.map v, valueToQueryParam
    else v

  asObject = (queryObj) ->
    _.transform queryObj, (memo, v, k) ->
      current = memo
      props = k.split '.'
      _.each props, (prop, index) ->
        camelCasedProp = dashToCamel prop
        current = current[camelCasedProp] = if index == props.length - 1 then queryParamToValue(v) else current[camelCasedProp] || {}
        true
    , {}

  asQueryObject = (obj, parentNesting = []) ->
    _.transform obj, (memo, v, k) ->
      nesting = parentNesting.concat k
      if _.isPlainObject(v) && !moment.isMoment(v)
        _.assign memo, asQueryObject(v, nesting)
      else
        memo[camelToDash nesting.join('.')] = valueToQueryParam v
      true
    , {}

  value = null
  updateValue = ->
    value = asObject $location.search()

  $rootScope.$on '$locationChangeSuccess', ->
    updateValue()

  $rootScope.$on '$stateChangeSuccess', ->
    updateValue()

  updateValue()

  (key, newValue) ->
    if arguments.length > 0
      if arguments.length > 1
        if key.indexOf('.') != -1
          temp = {}
          temp[key] = newValue
          _.merge value, asObject(temp), (a, b) ->
            if _.isArray(a) && _.isPlainObject(b) then _.transform b, (memo, v, k) ->
              if _.isUndefined(v) || _.isNull(v)
                memo.splice(+k, 1)
              else
                memo[k] = v
            , a
        else
          value[key] = newValue
        $location.search asQueryObject(value)
      else
        $location.search asQueryObject(key)
      updateValue()
    value