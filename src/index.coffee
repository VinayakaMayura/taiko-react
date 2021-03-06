import fs from 'fs'
import { Component } from 'react'
import { resolveComponent, resolveComponents } from './injected'
import { maxDepth } from './constants'
import { isValidElement } from './helpers'
import Result from './result'
import { NOT_A_REACT_INSTANCE_OR_COMPONENT } from './error-messages'

export ID = 'react'

taiko = undefined
resq = undefined

export clientHandler = (taikoInstance) ->
  taiko = taikoInstance
  resqLocation = require.resolve 'resq'
  resq = fs.readFileSync resqLocation

defaultOptions = {
  multiple: false
  depth: maxDepth
}

export react = (selector, options = defaultOptions) ->
  options = { ...defaultOptions, ...options }

  unless selector?
    throw new Error 'Selector needs to be either a string or an object'
  
  if typeof selector is 'string'
    selectorString = selector
  else if typeof selector is 'function'
    if selector.prototype instanceof Component
      selectorString = selector.displayName or selector.name
    else
      selectorString = selector.name
  else if typeof selector is 'object'
    if isValidElement selector
      selectorString = selector.type
    else
      throw new Error NOT_A_REACT_INSTANCE_OR_COMPONENT
  else
    throw new Error 'Could not ascertain the type of this React component'
  
  if 'depth' of options and typeof options.depth is 'number'
    depth = options.depth
  else
    throw new Error 'Depth needs to be a number'
  
  { selectorToUse, componentResolver } =
  if options?.multiple then {
    selectorToUse: 'resq$$'
    componentResolver: 'resolveComponents'
  }
  else {
    selectorToUse: 'resq$'
    componentResolver: 'resolveComponent'
  }

  expression = "
  (async function() {
    #{ resq }
    const isValidElement = #{ isValidElement };
    const maxDepth = #{ depth };
    const resolveComponent = #{ resolveComponent() };
    const resolveComponents = #{ resolveComponents() };
    await window.resq.waitToLoadReact();
    result = window.resq.#{ selectorToUse }('#{ selectorString }');
    return #{ componentResolver }(result);
  })()
  "

  client = await taiko.client()

  result = await client.Runtime.evaluate({
    expression: expression,
    returnByValue: true,
    awaitPromise: true
  })

  return new Result selectorString, options, result
